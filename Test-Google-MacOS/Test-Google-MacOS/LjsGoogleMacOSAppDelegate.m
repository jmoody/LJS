#import "LjsGoogleMacOSAppDelegate.h"
#import "Lumberjack.h"
#import "LjsCategories.h"
#import "LjsDn.h"
#import "LjsGooglePlacesManager.h"
#import "LjsLocationManager.h"
#import "LjsGooglePlace.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsGoogleMacOSAppDelegate () 

@property (nonatomic, strong) LjsGooglePlacesManager *manager;

@end

@implementation LjsGoogleMacOSAppDelegate

@synthesize window = _window;
@synthesize context = __moContext;
@synthesize model = __moModel;
@synthesize coordinator = __coordinator;
@synthesize manager;
@synthesize places;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // kick off the logger
  LjsDefaultFormatter *formatter = [[LjsDefaultFormatter alloc] init];
  [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  
  
  DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
  fileLogger.maximumFileSize = 1024 * 1024;
  fileLogger.rollingFrequency = 60 * 60 * 24;
  fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
  [DDLog addLogger:fileLogger];
  DDLogDebug(@"logging initialized");
  
  LjsLocationManager *lm = [[LjsLocationManager alloc] init];
  
  self.manager = [[LjsGooglePlacesManager alloc] initWithLocationManager:lm];
  
  
  NSString *input, *langCode;
  CGFloat radius;
  BOOL establishment;
  
  input = @"Basel";
  langCode = @"en";
  radius = 5000;
  establishment = NO;
  NSArray *results;
//  
//  results = [self.manager placesWithNameBeginningWithString:input
//                                                      limit:0
//                                                       sort:NO
//                                                  ascending:NO
//                                  performPredicationRequest:YES
//                                           predictionRadius:radius
//                                         predictionLanguage:langCode];
//  
////  self.places = results;
//  
//  NSArray *inputs = [NSArray arrayWithObjects:@"paris", @"lisbon", @"madrid",
//                     @"boston", @"los angeles", @"london", @"kiev", nil];
//  
//  for (NSString *city in inputs) {
//    results = [self.manager placesWithNameBeginningWithString:city
//                                                        limit:0
//                                                         sort:NO
//                                                    ascending:NO
//                                    performPredicationRequest:YES
//                                             predictionRadius:radius
//                                           predictionLanguage:langCode];
//  }
//  
//  CGFloat lat = [lm latitude];
//  CGFloat lng = [lm longitude];
//  
//  results = [self.manager placesWithNameBeginningWithString:@"b"
//                                  performPredicationRequest:NO
//                                           predictionRadius:radius
//                                         predictionLanguage:langCode];
//
//  LjsLocation location = LjslocationMake(lat,lng);
////  NSArray *sorted = [self.manager arrayBySortingPlaces:results
////                              withDistanceFromLatitude:lat
////                                            longitidue:lng
////                                             ascending:YES];
//
//  DDLogDebug(@"========================================");
//  for (LjsGooglePlace *place in results) {
//    DDLogDebug(@"%.5f ==> %@", [place metersFromLocation:location], place);
//  }
//
//  
//  results = [self.manager placesWithNameBeginningWithString:@"ba"
//                                  performPredicationRequest:NO
//                                           predictionRadius:radius
//                                         predictionLanguage:langCode];
//  
//  
////  sorted = [self.manager arrayBySortingPlaces:results
////                              withDistanceFromLatitude:lat
////                                            longitidue:lng
////                                             ascending:YES];
//  
//  DDLogDebug(@"========================================");
//  for (LjsGooglePlace *place in results) {
//    DDLogDebug(@"%.5f ==> %@", [place metersFromLocation:location], place);
//  }
//
//  results = [self.manager placesWithNameBeginningWithString:@"bas"
//                                                      limit:NSNotFound
//                                  performPredicationRequest:NO
//                                           predictionRadius:radius
//                                         predictionLanguage:langCode];
// 
  NSArray *sorted;
  sorted = [self.manager placesWithNameBeginningWithString:@"bas"
                                                      limit:NSNotFound
                                                       sort:YES 
                                                  ascending:YES
                                  performPredicationRequest:NO
                                           predictionRadius:radius
                                         predictionLanguage:langCode];
  
  LjsLocation location = [lm location];
//  sorted = [self.manager arrayBySortingPlaces:sorted
//                     withDistanceFromLatitude:location.latitude
//                                   longitidue:location.longitude
//                                    ascending:YES];
  

  DDLogDebug(@"location = %@", NSStringFromLjsLocation(location));
  DDLogDebug(@"========================================");
  for (LjsGooglePlace *place in sorted) {
    NSDecimalNumber *km = [lm dnKilometersBetweenA:[place location] b:location];
    DDLogDebug(@"%@ ==> %@", km, place);
  }

}

// Returns the directory the application uses to store the Core Data store file. 
// This code uses a directory named "com.littlejoysoftware.Test_Google_MacOS" 
// in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory 
                                              inDomains:NSUserDomainMask] lastObject];
  return [appSupportURL URLByAppendingPathComponent:@"com.littlejoysoftware.Test_Google_MacOS"];
}



// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *) model {
  if (__moModel) {
    return __moModel;
  }
	
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Test_Google_MacOS" withExtension:@"momd"];
  __moModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return __moModel;
}


// Returns the persistent store coordinator for the application. 
// This implementation creates and return a coordinator, having added the store
// for the application to it. (The directory for the store is created, 
// if necessary.)
- (NSPersistentStoreCoordinator *) coordinator {
  if (__coordinator) {
    return __coordinator;
  }
  
  NSManagedObjectModel *mom = [self model];
  if (!mom) {
    NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
    return nil;
  }
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
  NSError *error = nil;
  
  NSDictionary *properties = [applicationFilesDirectory 
                              resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] 
                              error:&error];
  
  if (!properties) {
    BOOL ok = NO;
    if ([error code] == NSFileReadNoSuchFileError) {
      ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] 
                  withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if (!ok) {
      [[NSApplication sharedApplication] presentError:error];
      return nil;
    }
  } else {
    if (![[properties objectForKey:NSURLIsDirectoryKey] boolValue]) {
      // Customize and localize this error.
      NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).",
                                      [applicationFilesDirectory path]];
      
      NSMutableDictionary *dict = [NSMutableDictionary dictionary];
      [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
      error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
      
      [[NSApplication sharedApplication] presentError:error];
      return nil;
    }
  }
  
  NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Test_Google_MacOS.storedata"];
  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
  if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
    [[NSApplication sharedApplication] presentError:error];
    return nil;
  }
  __coordinator = coordinator;
  
  return __coordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *) context {
  if (__moContext) {
    return __moContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self coordinator];
  if (!coordinator) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
    [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
    NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    [[NSApplication sharedApplication] presentError:error];
    return nil;
  }
  __moContext = [[NSManagedObjectContext alloc] init];
  [__moContext setPersistentStoreCoordinator:coordinator];
  
  return __moContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window{
  return [[self context] undoManager];
}

- (void) saveContext {
  NSError *error = nil;
  
  if (![[self context] commitEditing]) {
    NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
  }
  
  if (![[self context] save:&error]) {
    [[NSApplication sharedApplication] presentError:error];
  }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
  // Save changes in the application's managed object context before the application terminates.
  
  if (!__moContext) {
    return NSTerminateNow;
  }
  
  if (![[self context] commitEditing]) {
    NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
    return NSTerminateCancel;
  }
  
  if (![[self context] hasChanges]) {
    return NSTerminateNow;
  }
  
  NSError *error = nil;
  if (![[self context] save:&error]) {
    
    // Customize this code block to include application-specific recovery steps.              
    BOOL result = [sender presentError:error];
    if (result) {
      return NSTerminateCancel;
    }
    
    NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
    NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
    NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
    NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:question];
    [alert setInformativeText:info];
    [alert addButtonWithTitle:quitButton];
    [alert addButtonWithTitle:cancelButton];
    
    NSInteger answer = [alert runModal];
    
    if (answer == NSAlertAlternateReturn) {
      return NSTerminateCancel;
    }
  }
  
  return NSTerminateNow;
}

@end
