#import <Cocoa/Cocoa.h>


@interface LjsGoogleMacOSAppDelegate : NSObject 
<NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, strong, readonly) NSManagedObjectContext *context; 
@property (nonatomic, strong, readonly) NSManagedObjectModel *model; 
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSArray *places;

- (void) saveContext;

@end
