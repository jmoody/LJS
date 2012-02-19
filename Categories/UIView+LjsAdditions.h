#import <UIKit/UIKit.h>

/**
 UIView on UIView_LjsAdditions category.
 */
@interface UIView (UIView_LjsAdditions)

- (void) centerWithX:(CGFloat) x;

- (void) centerWithY:(CGFloat) y;

- (void) centerXToView:(UIView *) aView;

- (void) centerYToView:(UIView *) aView;

- (void) setHeightWithHeight:(CGFloat) h;
- (void) setWidthWithWidth:(CGFloat) w;
- (void) setSizeWithWidth:(CGFloat) w 
                andHeight:(CGFloat) h;

- (void) setXWithX:(CGFloat) x;
- (void) setYWithY:(CGFloat) y;
- (void) setOriginWithX:(CGFloat) x
                   andY:(CGFloat) y;

- (void) adjustX:(CGFloat) scale;
- (void) adjustY:(CGFloat) scale;
- (void) adjustW:(CGFloat) scale;
- (void) adjustH:(CGFloat) scale;

- (NSString *) frameToString;
- (NSString *) centerToString;
- (NSString *) boundsToString;

- (BOOL) containsSubviewWithTag:(NSInteger) aTag;
@end
