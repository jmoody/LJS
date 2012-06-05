#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation NSError (NSError_LjsAdditions)


+ (NSError *) errorWithDomain:(NSString *) aDomain
                         code:(NSInteger) aCode
         localizedDescription:(NSString *) aLocalizedDescription
                otherUserInfo:(NSDictionary *) aOtherUserInfo {
  NSMutableDictionary *userInfo;
  if (aOtherUserInfo == nil) {
    userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
  } else {
    userInfo = [NSMutableDictionary dictionaryWithDictionary:aOtherUserInfo];
  }

  [userInfo setObject:aLocalizedDescription forKey:NSLocalizedDescriptionKey];
  [userInfo setObject:[NSNumber numberWithInteger:NSUTF8StringEncoding]
               forKey:NSStringEncodingErrorKey];
  return [NSError errorWithDomain:aDomain
                             code:aCode
                         userInfo:userInfo];

}


+ (NSError *) errorWithDomain:(NSString *) aDomain
                         code:(NSInteger) aCode
         localizedDescription:(NSString *) aLocalizedDescription {
  return [NSError errorWithDomain:aDomain
                             code:aCode
             localizedDescription:aLocalizedDescription
                    otherUserInfo:nil];
}

@end
