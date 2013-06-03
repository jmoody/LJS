#import <Foundation/Foundation.h>

/**
 a core data store migration tool based on Marcus S. Zarra
 
 useful links
 
 - https://gist.github.com/2321704
 - http://pragprog.com/titles/mzcd/source_code
 */
@interface LjsProgressiveMigration : NSObject 

/** @name Properties */

/** @name Initializing Objects */
- (id) initWithIgnorableModels:(NSArray *) aIgnorableModels;

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */
- (BOOL) progressivelyMigrateURL:(NSURL *) aSourceStoreURL
                       storeType:(NSString *) aStoreType 
                         toModel:(NSManagedObjectModel *) aFinalModel 
                           error:(NSError **) aError;

@end
