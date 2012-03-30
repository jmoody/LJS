#import "LjsGoogleMacOSAppDelegate.h"
#import "Lumberjack.h"
#import "LjsCategories.h"
#import "LjsDn.h"
#import "LjsGooglePlacesManager.h"
#import "LjsLocationManager.h"
#import "LjsGooglePlace.h"
#import "LjsGooglePlacePredictionOptions.h"


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

  LjsLocation location = [lm location];

  
//  NSArray *strings = [NSArray arrayWithObjects:@"s", @"st", @"sta", @"star", @"starbu",
//                      @"starbuc", @"starbuck", @"starbucks", nil];

  //  NSArray *strings = [NSArray arrayWithObjects:@"c", @"ca", @"caf", @"cafe", nil];

  NSMutableArray *strings = [NSMutableArray array]; 
  //                   
  NSString *input = @"HB";
  for (NSUInteger index = 0; index < [input length]; index++) {
    [strings nappend:[input substringToIndex:index + 1]];
  }
  DDLogDebug(@"strings = %@", strings);

  
  for (NSString *searchString in strings) {
    LjsGpPredictionSortOptions *sortOptions = [LjsGpPredictionSortOptions sortAscending];
    LjsGpPredictionGoogleOptions *googleOptions;
    googleOptions = [LjsGpPredictionGoogleOptions optionsWithRadius:10000
                                               searchEstablishments:NO
                                                      langCodeOrNil:nil
                                                       searchString:searchString];
    LjsGpPredicateFactory *factory = [[LjsGpPredicateFactory alloc] init];
//    NSPredicate *predicate = [factory establishmentPredicateWithSearchString:searchString];    

    NSArray *tokens = [searchString componentsSeparatedByString:@" "];
    NSMutableArray *preds = [NSMutableArray arrayWithCapacity:[tokens count]];
    //[preds push:[factory nonEstablishmentPredicate]];
    NSPredicate *subs;
    for (NSString *token in tokens) {
      subs = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@ OR vicinity CONTAINS[cd] %@)",
                   token, tokens];
      [preds push:subs];
    }
    
    NSPredicate *ors = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
    NSArray *ands = [NSArray arrayWithObjects:ors, [factory nonEstablishmentPredicate], nil];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:ands];


    
    

    
    LjsGooglePlacePredictionOptions *options;
    options = [[LjsGooglePlacePredictionOptions alloc]
               initWithLocation:location
               predicate:predicate
               limit:NSNotFound
               sortOptions:sortOptions
               googleOptions:googleOptions];
    
  
    NSArray *sorted;
    sorted = [self.manager predicationsWithOptions:options];  
    
    
    DDLogDebug(@"location = %@", NSStringFromLjsLocation(location));
    DDLogDebug(@"==============  %@ ==========================", searchString);
    for (LjsGooglePlace *place in sorted) {
      NSDecimalNumber *km = [lm dnKilometersBetweenA:[place location] b:location];
      DDLogDebug(@"%@ ==> %@", km, place);
    }
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
