#import <Cocoa/Cocoa.h>
#import "LjsGooglePlacesRequestManager.h"

@interface LjsGoogleMacOSAppDelegate : NSObject 
<NSApplicationDelegate, LjsGooglePlaceRequestManagerResultHandlerDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, strong, readonly) NSManagedObjectContext *context; 
@property (nonatomic, strong, readonly) NSManagedObjectModel *model; 
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *coordinator;


- (void) saveContext;

@end
