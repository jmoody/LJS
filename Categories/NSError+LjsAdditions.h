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
