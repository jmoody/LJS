
#import <Foundation/Foundation.h>

@interface LjsValidator : NSObject {
    
}

+ (BOOL) stringContainsOnlyNumbers:(NSString *) string;
+ (BOOL) isDictionary:(id) value;
+ (BOOL) isArray:(id) value;
+ (BOOL) isString:(id) value;
+ (BOOL) dictionary:(NSDictionary *) dictionary containsKey:(NSString *) key;

@end
