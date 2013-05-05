#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
  kLjsErrorCode_NotFound = 40272,
  kLjsErrorCode_AlreadyExists,
  kLjsErrorCode_InvalidArgument
} LjsErrorFactoryCode;


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

+ (NSError *) errorForInvalidArgumentWithLocalizedDescription:(NSString *) aLocalizedDescription;

@end
