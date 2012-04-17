#import <Foundation/Foundation.h>

/**
 NSLocale on NSLocale_LjsAdditions category.
 */
@interface NSLocale (NSLocale_LjsAdditions)

+ (NSLocale *) localeForEnglishUS;
- (BOOL) localeUses24HourClock;
@end
