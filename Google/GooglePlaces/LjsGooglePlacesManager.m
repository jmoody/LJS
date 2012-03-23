// Copyright 2012 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGooglePlacesManager.h"
#import "LjsGoogleGlobals.h"
#import "Lumberjack.h"
#import "LjsFileUtilities.h"
#import "LjsCaesarCipher.h"
#import "LjsGooglePlacesDetailsReply.h"
#import "LjsGooglePlacesPredictiveReply.h"
#import "LjsGooglePlacesDetails.h"
#import "LjsGooglePlacesPrediction.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSString *LjsGooglePlacesManagerModelFile = @"LjsGooglePlacesModel";
static NSString *LjsGooglePlacesSqlLiteStore = @"com.littlejoysoftware.LjsGooglePlaces.sqlite";

@interface LjsGooglePlacesManager ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *model; 
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *coordinator; 
@property (nonatomic, copy) NSString *sqliteFilename;
@property (nonatomic, copy) NSString *sqliteDirectory;


- (NSURL *) urlForSqlitePath;
- (NSString *) decodeDefaultApiKey;

@end

@implementation LjsGooglePlacesManager

@synthesize context = __moContext;
@synthesize model = __moModel;
@synthesize coordinator = __coordinator;
@synthesize sqliteFilename;
@synthesize sqliteDirectory;
@synthesize apiToken;
@synthesize requestManager = __requestManager;


#pragma mark Memory Management
- (void) dealloc {
   DDLogDebug(@"deallocating %@", [self class]);
}

- (NSString *) decodeDefaultApiKey {
  NSString *defaultToken = LjsGoogleApiKey_joshuajmoody;
  NSUInteger lenght = [defaultToken length];
  LjsCaesarCipher *cipher = [[LjsCaesarCipher alloc] initWithRotate:lenght];
  NSString *decoded = [cipher stringByDecodingString:defaultToken];
  return decoded;
}

- (id) init {
  NSString *decoded = [self decodeDefaultApiKey];
  return [self initWithStoreDirectory:[LjsFileUtilities findLibraryDirectoryPath:YES]
                        storeFilename:LjsGooglePlacesSqlLiteStore
                             apiToken:decoded];
                          
}


- (id) initWithApiToken:(NSString *) aApiToken {
  return [self initWithStoreDirectory:[LjsFileUtilities findLibraryDirectoryPath:YES]
                        storeFilename:LjsGooglePlacesSqlLiteStore
                             apiToken:aApiToken];
                           
}

- (id) initWithStoreFilename:(NSString *) aFilename 
                    apiToken:(NSString *) aApiToken {
  return [self initWithStoreDirectory:[LjsFileUtilities findLibraryDirectoryPath:YES]
                        storeFilename:aFilename
                             apiToken:aApiToken];
                          
}

- (id) initWithStoreDirectory:(NSString *) aDirectory
                storeFilename:(NSString *) aFilename
                     apiToken:(NSString *) aApiToken {
  self = [super init];
  if (self != nil) {
    self.sqliteDirectory = aDirectory;
    self.sqliteFilename = aFilename;
    self.apiToken = aApiToken;
    
    // initalize
    [self requestManager];
    
    // initialize
    [self context];
  }
  return self;
}



- (void) requestForPredictionsCompletedWithPredictions:(NSArray *)aPredictions {
  LjsGooglePlacesPrediction *prediction;
  for (prediction in aPredictions) {
    DDLogDebug(@"starting request for details with prediction: %@", prediction);
    [self.requestManager performDetailsRequestionForPrediction:prediction
                                               language:@"en"];
  }
}

- (void) requestForPredictionsFailedWithCode:(NSUInteger)aCode 
                                     request:(ASIHTTPRequest *)aRequest {
  DDLogDebug(@"request failed with code: %d", aCode);
}

- (void) requestForPredictionsFailedWithCode:(NSString *) aStatusCode
                                       reply:(LjsGooglePlacesPredictiveReply *) aReply
                                       error:(NSError *) aError {
  DDLogDebug(@"request failed with code: %@", aStatusCode);
}

- (void) requestForDetailsCompletedWithDetails:(LjsGooglePlacesDetails *) aDetails {
  DDLogDebug(@"details = %@", aDetails);
}

- (void) requestForDetailsFailedWithCode:(NSUInteger) aCode
                                 request:(ASIHTTPRequest *) aRequest {
  DDLogDebug(@"failed with code: %d", aCode);
}

- (void) requestForDetailsFailedWithCode:(NSString *) aStatusCode
                                   reply:(LjsGooglePlacesDetailsReply *) aReply
                                   error:(NSError *) aError {
  DDLogDebug(@"failed with code : %@", aStatusCode);
}


- (LjsGooglePlacesRequestManager *) requestManager {
  if (__requestManager != nil) {
    return __requestManager;
  }
  
  __requestManager =  [[LjsGooglePlacesRequestManager alloc]
                       initWithApiToken:self.apiToken
                       resultHandler:self];
  return __requestManager;
}


#pragma mark Core Data Stack

- (NSURL *) urlForSqlitePath {
  NSURL *dirUrl = [NSURL fileURLWithPath:self.sqliteDirectory];
  NSURL *result = [dirUrl URLByAppendingPathComponent:self.sqliteFilename];
  return result;
}

- (NSManagedObjectModel *) model {
  if (__moModel != nil) { 
    return __moModel; 
  } 
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:LjsGooglePlacesManagerModelFile 
                                            withExtension:@"momd"]; 
  __moModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  return __moModel; 
} 


- (NSPersistentStoreCoordinator *) coordinator {
  if (__coordinator != nil) {
    return __coordinator;
  }

  
  NSURL *storeURL = [self urlForSqlitePath];
  
  NSError *error = nil;
  __coordinator = [[NSPersistentStoreCoordinator alloc]
                   initWithManagedObjectModel:self.model];
  
  NSDictionary *options = nil;
  options = [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
  
  if (![__coordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                   configuration:nil 
                                             URL:storeURL 
                                         options:options
                                           error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You 
     should not use this function in a shipping application, although it may be 
     useful during development. 
     
     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed
     object model.
     Check the error message to determine what the actual problem was.
     
     
     If the persistent store is not accessible, there is typically something 
     wrong with the file path. Often, a file URL is pointing into the application's
     resources directory instead of a writeable directory.
     
     If you encounter schema incompatibility errors during development, you can
     reduce their frequency by:
     * Simply deleting the existing store:
     
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
     
     * Performing automatic lightweight migration by passing the following 
     dictionary as the options parameter: 
     
     [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], 
     NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
     NSInferMappingModelAutomaticallyOption, nil];
     
     Lightweight migration will only work for a limited set of schema changes; 
     consult "Core Data Model Versioning and Data Migration Programming Guide" 
     for details.
     */
    DDLogDebug(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  return __coordinator;
}


- (NSManagedObjectContext *) context { 
  if (__moContext != nil) { 
    return __moContext; 
  } 
  
  NSPersistentStoreCoordinator *coordinator = self.coordinator;
  if (coordinator != nil) { 
    Class mocClass = [NSManagedObjectContext class];
    if ([mocClass instancesRespondToSelector:@selector(initWithConcurrencyType:)]) {
      __moContext = [[NSManagedObjectContext alloc] 
                     initWithConcurrencyType:NSMainQueueConcurrencyType];
      [__moContext performBlockAndWait:^(void) {
        [__moContext setPersistentStoreCoordinator:coordinator];
      }];
      
    } else {
      __moContext = [[NSManagedObjectContext alloc] init];
      [__moContext setPersistentStoreCoordinator:coordinator];
    }
  } 
  
  return __moContext; 
} 

- (void) saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.context;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. 
      // You should not use this function in a shipping application, although it
      // may be useful during development. 
      DDLogError(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}


@end
