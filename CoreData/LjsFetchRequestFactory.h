#import <Foundation/Foundation.h>

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSUInteger, LjsFetchRequestFactoryErrorCode) {
  kLjsFetchRequestFactoryErrorCodeInvalidArgument
};


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
                        error:(NSError **) aError;

- (BOOL) entityExistsForKey:(NSString *) aKey
                 entityName:(NSString *) aEntityName
                    context:(NSManagedObjectContext *) aContext
                      count:(NSUInteger *) aCountRef
                      error:(NSError **) aError;

- (id) entityForKey:(NSString *) aKey
         entityName:(NSString *) aEntityName
              count:(NSUInteger *) aCountRef
            context:(NSManagedObjectContext *) aContext
              error:(NSError **) aError;

/** @name Predicates */
- (NSPredicate *) predicateForKey:(NSString *) aKey;
- (NSPredicate *) predicateForAttribute:(NSString *) aAttributeName
                                  value:(NSString *) aAttributeValue;
- (NSPredicate *) predicateForAttribute:(NSString *) aAttributeName
                                  value:(NSString *) aAttributeValue
                                    key:(NSString *) aKey;
@end
