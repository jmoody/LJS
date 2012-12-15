
#import "LjsManagedObjectContextTest.h"
#import "Lumberjack.h"
#import "LjsIdGenerator.h"
#import "LjsFileUtilities.h"
#import "LjsProgressiveMigration.h"
#import "LjsDateHelper.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


@implementation LjsManagedObjectContextTest


- (void) saveContext:(NSManagedObjectContext *) aContext {
  NSError *error = nil;
  if (aContext != nil) {
    if ([aContext hasChanges] && ![aContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. 
      // You should not use this function in a shipping application, although it
      // may be useful during development. 
      GHTestLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}


- (NSManagedObjectContext *) contextWithStoreNamed:(NSString *)aStoreName {
  NSURL *originalStoreURL = [[NSBundle mainBundle] URLForResource:aStoreName
                                            withExtension:@"sqlite"];
  NSFileManager *fm = [NSFileManager defaultManager];
  
  GHAssertTrue([fm fileExistsAtPath:[originalStoreURL path]], 
               @"file needs to exist at path: %@",
               originalStoreURL);
  
  NSError *fileCopyError = nil;
  NSString *uuid = [LjsIdGenerator generateUUID];
  NSString *filename = [aStoreName stringByAppendingFormat:@"-%@.sqlite",
                        uuid];
  NSString *docDir = [LjsFileUtilities findDocumentDirectory];
  NSDateFormatter *df = [LjsDateHelper orderedDateFormatter];
  NSString *dateStr = [df stringFromDate:[NSDate date]];
  NSString *timestampedDirName = [NSString stringWithFormat:@"core-data-working-dir-%@", dateStr];
  NSString *directory = [docDir stringByAppendingPathComponent:timestampedDirName];
  NSError *directoryCreateError = nil;
  BOOL created = [fm createDirectoryAtPath:directory
               withIntermediateDirectories:YES
                                attributes:nil error:&directoryCreateError];
  GHAssertTrue(created, @"could not create directory %@ found error: %@", 
               directory, directoryCreateError);
  NSString *newPath = [directory stringByAppendingPathComponent:filename];
  NSLog(@" filename ==> %@", filename);
  NSLog(@"directory ==> %@", directory);
  NSLog(@" new path ==> %@", newPath);
  NSURL *newStoreURL = [[NSURL alloc] initFileURLWithPath:newPath isDirectory:NO];
  NSLog(@"new store ==> %@", newStoreURL);
  BOOL copied = [fm copyItemAtURL:originalStoreURL 
                            toURL:newStoreURL 
                            error:&fileCopyError];
  GHAssertTrue(copied, @"could not copy:\n%@ to:\n%@ found error: %@",
               [originalStoreURL path], [newStoreURL path], fileCopyError);
  
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" 
                                            withExtension:@"momd"]; 

  GHAssertTrue([fm fileExistsAtPath:[modelURL path]], @"%@ should exist", modelURL);
  
  NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  
  /*
  NSDictionary *options = nil;
  options = [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
  */
  NSPersistentStore *ps;
  NSError *error = nil;
  
  LjsProgressiveMigration *pm = [LjsProgressiveMigration new];
  BOOL success = [pm progressivelyMigrateURL:newStoreURL
                                   storeType:NSSQLiteStoreType
                                     toModel:mom
                                       error:&error];
  GHAssertTrue(success, @"should have had success migrating: %@", error);
  
  ps = [psc addPersistentStoreWithType:NSSQLiteStoreType 
                         configuration:nil 
                                   URL:newStoreURL
                               options:nil//options 
                                 error:&error];
  if (ps == nil) {
    NSString *message = [NSString stringWithFormat:@"failed to create persistent store - failed with this error: %@: %@",
                         [error localizedDescription], error];
    GHTestLog(message);
    GHAssertNotNil(ps, message);
  }
  
  NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
  moc.persistentStoreCoordinator = psc;
  GHAssertNotNil(moc, @"context should be non-nil");
  return moc;
}

- (NSManagedObjectContext *) inMemoryContextWithModelName:(NSString *) aModelName {
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:aModelName
                                            withExtension:@"momd"]; 
  NSFileManager *fm = [NSFileManager defaultManager];
  GHAssertTrue([fm fileExistsAtPath:[modelURL path]], @"%@ should exist", modelURL);
  
  NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  
  NSDictionary *options = nil;
  options = [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
  
  NSPersistentStore *ps;
  NSError *error = nil;
  ps = [psc addPersistentStoreWithType:NSInMemoryStoreType 
                         configuration:nil 
                                   URL:nil 
                               options:options 
                                 error:&error];
  if (ps == nil) {
    NSString *message = [NSString stringWithFormat:@"failed to create persistent store - failed with this error: %@: %@",
                         [error localizedDescription], error];
    GHTestLog(message);
    GHAssertNotNil(ps, message);
  }
  
  NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
  GHAssertNotNil(moc, @"one off context should be non-nil");
  moc.persistentStoreCoordinator = psc;
  return moc;
}



- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  [super setUpClass];
  // Run at start of all tests in the class
}

- (void) tearDownClass {
  [super tearDownClass];
  // Run at end of all tests in the class
}

- (void) setUp {
  [super setUp];
  // Run before each test method
}

- (void) tearDown {
  [super tearDown];
  // Run after each test method
}  

- (void) test_adhoc_4ePodcasts_context {
  NSManagedObjectContext *moc = [self inMemoryContextWithModelName:@"4ePodcasts"];
  GHAssertNotNil(moc, @"4ePodcast MOC should not be nil");
}



@end
