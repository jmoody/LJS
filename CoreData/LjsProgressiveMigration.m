#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsProgressiveMigration.h"
#import "Lumberjack.h"
#import <CoreData/CoreData.h>
#import "LjsIdGenerator.h"
#import "LjsDateHelper.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSString *const desintationModelKey = @"com.littlejoysoftware.core data progressive migration model key";
static NSString *const mappingModelKey = @"com.littlejoysoftware.core data progressive migration mapping key";
static NSString *const modelPathKey = @"com.littlejoysoftware.core data progressive migration model path key";

@interface LjsProgressiveMigration ()

@property (nonatomic, strong) NSString *timestampedDirectory;


- (NSArray *) collectModelVersions; 
- (NSDictionary *) findPathDestinationAndMappingModelWithModelPaths:(NSArray *) aModelPaths
                                                        sourceModel:(NSManagedObjectModel *) aSourceModel;

- (NSURL *) URLforDestinationStoreWithSourceStoreURL:(NSURL *) aSourceStoreURL 
                                           modelName:(NSString *) aModelName
                                      storeExtension:(NSString *) aStoreExtention
                                               error:(NSError **) aError;

- (BOOL) makeBackupsToPreserveSourceWithSourceStoreURL:(NSURL *) aSourceStoreURL
                                   destinationStoreURL:(NSURL *) aDestinationStoreURL
                                             modelName:(NSString *) aModelName
                                        storeExtension:(NSString *) aStoreExtension
                                                 error:(NSError **) aError;


@end

@implementation LjsProgressiveMigration
@synthesize timestampedDirectory;


#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
}

- (id) init {
  //  [self doesNotRecognizeSelector:_cmd];
  self = [super init];
  if (self) {
    NSDateFormatter *df = [LjsDateHelper orderedDateFormatterWithMillis];
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    self.timestampedDirectory = [NSString stringWithFormat:@"migration-%@", dateStr];
  }
  return self;
}


- (BOOL) progressivelyMigrateURL:(NSURL *) aSourceStoreURL
                       storeType:(NSString *) aStoreType 
                         toModel:(NSManagedObjectModel *) aFinalModel 
                           error:(NSError **) aError {

  NSDictionary *sourceMetadata = 
  [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:aStoreType
                                                             URL:aSourceStoreURL
                                                           error:aError];
  // no metadata - return nil
  if (sourceMetadata == nil) return NO;
  
  // compatible model - nil the error and return YES
  if ([aFinalModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata]) {
    if (aError != NULL) *aError = nil;
    return YES;
  }
  
  //Find the source model
  NSManagedObjectModel *sourceModel = [NSManagedObjectModel 
                                       mergedModelFromBundles:nil
                                       forStoreMetadata:sourceMetadata];
  if (sourceModel == nil) {
    NSString *message = [NSString stringWithFormat:@"failed to create source model from metadata: %@",
                         sourceMetadata];
    DDLogError(@"%@", message);
    if (aError != NULL) {
      *aError = [NSError errorWithDomain:@"Zarra" code:8001
                    localizedDescription:message];
    }
    return NO;
  }
  
  //Find all of the mom and momd files in the Resources directory
  NSArray *modelPaths = [self collectModelVersions];
  
  if (modelPaths == nil || [modelPaths emptyp]) {
    NSString *message = @"No models found in bundle.";
    DDLogError(@"%@", message);
    if (aError != NULL) {
      *aError = [NSError errorWithDomain:@"Zarra" code:8001
                    localizedDescription:message];
    }
    return NO;
  }

  //See if we can find a matching path, destination (mom) model, and mapping model
  NSDictionary *map = [self findPathDestinationAndMappingModelWithModelPaths:modelPaths
                                                                 sourceModel:sourceModel];
  if (map == nil) {
    NSString *message = @"Could not find matching destination MOM and mapping.";
    DDLogError(@"%@", message);
    if (aError != NULL) {
      
      *aError = [NSError errorWithDomain:@"Zarra" code:8001
                    localizedDescription:message];
    }
    return NO;
  }
  NSMappingModel *mappingModel = [map objectForKey:mappingModelKey];
  NSManagedObjectModel *destinationModel = [map objectForKey:desintationModelKey];
  NSString *modelPath = [map objectForKey:modelPathKey];


  //We have a mapping model and a destination model.  Time to migrate
  NSMigrationManager *manager = [[NSMigrationManager alloc] 
                                 initWithSourceModel:sourceModel
                                 destinationModel:destinationModel];

  NSString *modelName = [[modelPath lastPathComponent] stringByDeletingPathExtension];
  NSString *storeExtension = [[aSourceStoreURL path] pathExtension];
  NSURL *destinationStoreURL = [self URLforDestinationStoreWithSourceStoreURL:aSourceStoreURL
                                                                    modelName:modelName
                                                               storeExtension:storeExtension
                                                                        error:aError];
  if (destinationStoreURL == nil) {
    // error populated in the URLforDestinationStore
    return NO;
  }
  
  // do migration - if returns NO, then we return NO
  if ([manager migrateStoreFromURL:aSourceStoreURL 
                              type:aStoreType 
                           options:nil 
                  withMappingModel:mappingModel 
                  toDestinationURL:destinationStoreURL 
                   destinationType:aStoreType 
                destinationOptions:nil 
                             error:aError] == NO) return NO;
  

  //Migration was successful, move the files around to preserve the source
  if ([self makeBackupsToPreserveSourceWithSourceStoreURL:aSourceStoreURL
                                      destinationStoreURL:destinationStoreURL
                                                modelName:modelName
                                           storeExtension:storeExtension
                                                    error:aError] == NO) return NO;
    
  //We may not be at the "current" model yet, so recurse
  return [self progressivelyMigrateURL:aSourceStoreURL
                             storeType:aStoreType 
                               toModel:aFinalModel 
                                 error:aError];
}


- (NSArray *) collectModelVersions {
  NSBundle *main = [NSBundle mainBundle];
  NSArray *momdArray = [main pathsForResourcesOfType:@"momd" 
                                         inDirectory:nil];
  NSMutableArray *modelPaths = [NSMutableArray array];
  for (NSString *momdPath in momdArray) {
    NSString *resourceSubpath = [momdPath lastPathComponent];
    NSArray *array = [main pathsForResourcesOfType:@"mom" 
                                       inDirectory:resourceSubpath];
    [modelPaths addObjectsFromArray:array];
  }
  NSArray* otherModels = [main pathsForResourcesOfType:@"mom" 
                                           inDirectory:nil];
  [modelPaths addObjectsFromArray:otherModels];
  return [NSArray arrayWithArray:modelPaths];
}

- (NSDictionary *) findPathDestinationAndMappingModelWithModelPaths:(NSArray *) aModelPaths
                                                    sourceModel:(NSManagedObjectModel *) aSourceModel{
  __block NSMappingModel *mappingModel = nil;
  __block NSManagedObjectModel *destinationModel = nil;
  __block NSString *modelPath = nil;
  [aModelPaths mapc:^(NSString *path, NSUInteger idx, BOOL *stop) {
    modelPath = path;
    NSURL *url = [NSURL fileURLWithPath:path];
    destinationModel = [[NSManagedObjectModel alloc] 
                        initWithContentsOfURL:url];
    mappingModel = [NSMappingModel mappingModelFromBundles:nil 
                                            forSourceModel:aSourceModel 
                                          destinationModel:destinationModel];
    if (mappingModel != nil) {
      *stop = YES;
    } 
  }];
  
  if (mappingModel == nil) {
    return nil;
  }
  
  return [NSDictionary dictionaryWithObjectsAndKeys:
          mappingModel, mappingModelKey,
          destinationModel, desintationModelKey, 
          modelPath, modelPathKey, nil];
    
}


- (NSURL *) URLforDestinationStoreWithSourceStoreURL:(NSURL *) aSourceStoreURL 
                                           modelName:(NSString *) aModelName
                                      storeExtension:(NSString *) aStoreExtention
                                               error:(NSError **) aError {
  NSString *baseDirPath = [[aSourceStoreURL path] stringByDeletingLastPathComponent];
  NSString *timestampDirPath = [baseDirPath stringByAppendingPathComponent:self.timestampedDirectory];
  
  NSString *lastPathDir = [baseDirPath lastPathComponent];
  if ([lastPathDir isEqualToString:self.timestampedDirectory] == NO) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:timestampDirPath] == NO) {
      if ([[NSFileManager defaultManager] createDirectoryAtPath:timestampDirPath
                                    withIntermediateDirectories:YES
                                                     attributes:nil error:aError] == NO) {
        NSString *message = [NSString stringWithFormat:@"Could not create tmp directory %@ at path %@",
                             self.timestampedDirectory, timestampDirPath];
        DDLogError(@"%@", message);
        if (aError != NULL) {
          *aError = [NSError errorWithDomain:@"Zarra" code:8001
                        localizedDescription:message];
        }
        return nil;
      }
    }
  }
  
  NSString *destStoreName = [NSString stringWithFormat:@"%@.%@", 
                             aModelName, aStoreExtention];
  NSString *storePath = [timestampDirPath stringByAppendingPathComponent:destStoreName];
  
  return [NSURL fileURLWithPath:storePath];
}


- (BOOL) makeBackupsToPreserveSourceWithSourceStoreURL:(NSURL *) aSourceStoreURL
                                   destinationStoreURL:(NSURL *) aDestinationStoreURL
                                             modelName:(NSString *) aModelName
                                        storeExtension:(NSString *) aStoreExtension
                                                 error:(NSError **) aError {
  NSString *storePath = [aDestinationStoreURL path];
  
  NSString *guid = [LjsIdGenerator generateUUID];
  guid = [guid stringByAppendingPathExtension:aModelName];
  guid = [guid stringByAppendingPathExtension:aStoreExtension];
  NSString *appSupportPath = [storePath stringByDeletingLastPathComponent];
  NSString *backupPath = [appSupportPath stringByAppendingPathComponent:guid];
  
  
  if ([[NSFileManager defaultManager] moveItemAtPath:[aSourceStoreURL path]
                                              toPath:backupPath
                                               error:aError] == NO) {
    //Failed to copy the file
    return NO;
  }
  
  //Move the destination to the source path
  if ([[NSFileManager defaultManager] moveItemAtPath:storePath
                                              toPath:[aSourceStoreURL path]
                                               error:aError] == NO) {
    //Try to back out the source move first, no point in checking it for errors
    [[NSFileManager defaultManager] moveItemAtPath:backupPath
                                            toPath:[aSourceStoreURL path]
                                             error:nil];
    return NO;
  }

  return YES;
}


@end
