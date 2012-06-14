#import <Foundation/Foundation.h>

/**
 Documentation
 */
@interface LjsProgressiveMigration : NSObject 

/** @name Properties */

/** @name Initializing Objects */

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */
- (BOOL) progressivelyMigrateURL:(NSURL *) aSourceStoreURL
                       storeType:(NSString *) aStoreType 
                         toModel:(NSManagedObjectModel *) aFinalModel 
                           error:(NSError **) aError;

@end
