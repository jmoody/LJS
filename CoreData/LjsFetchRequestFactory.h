#import <Foundation/Foundation.h>

/**
 Documentation
 */
@interface LjsFetchRequestFactory : NSObject

/** @name Properties */

/** @name Initializing Objects */

/** @name Handling Notifications, Requests, and Events */

/** @name Requests */

- (NSUInteger) countForEntity:(NSString *) aEntityName
                    predicate:(NSPredicate *) aPredicateOrNil
                      context:(NSManagedObjectContext *) aContext
                        error:(NSError **) error;

/** @name Predicates */
- (NSPredicate *) predicateForKey:(NSString *) aKey;
- (NSPredicate *) predicateForAttribute:(NSString *) aAttributeName
                                  value:(NSString *) aAttributeValue;
- (NSPredicate *) predicateForAttribute:(NSString *) aAttributeName
                                  value:(NSString *) aAttributeValue
                                    key:(NSString *) aKey;
@end
