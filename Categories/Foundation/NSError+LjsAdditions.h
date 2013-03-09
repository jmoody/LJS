#import <Foundation/Foundation.h>

/**
 NSError on NSError_LjsAdditions category.
 */
@interface NSError (NSError_LjsAdditions)

+ (NSError *) errorWithDomain:(NSString *) aDomain
                         code:(NSInteger) aCode
         localizedDescription:(NSString *) aLocalizedDescription
                otherUserInfo:(NSDictionary *) aOtherUserInfo;

+ (NSError *) errorWithDomain:(NSString *) aDomain
                         code:(NSInteger) aCode
         localizedDescription:(NSString *) aLocalizedDescription;


@end

/**
 Category on NSString to make stringWithFormat a little less verbose
 */
@interface NSString (NSString_LjsErrorFactory)

+ (NSString *) swf:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end


/**
 Documentation
 */
@interface LjsErrorFactory : NSObject

/** @name Properties */

/** @name Initializing Objects */

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */

+ (NSError *) errorWithCode:(NSInteger) aCode
       localizedDescription:(NSString *) aLocalizedDescription
              otherUserInfo:(NSDictionary *) aOtherUserInfo;

+ (NSError *) errorWithCode:(NSInteger) aCode
       localizedDescription:(NSString *) aLocalizedDescription;

+ (NSError *) errorWithCode:(NSInteger) aCode
       localizedDescription:(NSString *) aLocalizedDescription
             userInfoObject:(id) aObject
                userInfoKey:(id) aKey;


@end
