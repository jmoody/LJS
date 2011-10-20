
#import <Foundation/Foundation.h>

/**
 cribbed from here:
 http://www.framewreck.net/2010/07/custom-tintcolor-for-each-segment-of.html
 */
@interface UISegmentedControl (UISegmentedColor_Colors)


-(void)setTag:(NSInteger)tag forSegmentAtIndex:(NSUInteger)segment;
-(void)setTintColor:(UIColor*)color forTag:(NSInteger)aTag;
-(void)setTextColor:(UIColor*)color forTag:(NSInteger)aTag;
-(void)setShadowColor:(UIColor*)color forTag:(NSInteger)aTag;

@end
