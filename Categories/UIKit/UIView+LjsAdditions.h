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
- (void) setEndXWithXInset:(CGFloat) xInset
             withView:(UIView *) aView;
- (void) setEndXWithXInset:(CGFloat) xInset
              withMaxWidth:(CGFloat) aMaxWidth;
- (void) setEndYWithYInset:(CGFloat) yInset
             withView:(UIView *) aView;
- (void) setEndYWithYInset:(CGFloat) yInset
             withMaxHeight:(CGFloat) aMaxHeight;


- (void) adjustX:(CGFloat) scale;
- (void) adjustY:(CGFloat) scale;
- (void) adjustW:(CGFloat) scale;
- (void) adjustH:(CGFloat) scale;

- (CGFloat) endX;
- (CGFloat) endY;

- (NSString *) frameToString;
- (NSString *) centerToString;
- (NSString *) boundsToString;

+ (CGRect) frameX:(CGFloat) aX
                w:(CGFloat) aWidth
                h:(CGFloat) aHeight
      centeredToH:(CGFloat) aCenterH;

- (BOOL) containsSubviewWithTag:(NSInteger) aTag;
@end
