#import <UIKit/UIKit.h>

/**
 UIView on UIView_LjsAdditions category.
 */
@interface UIView (UIView_LjsAdditions)

- (void) centerWithX:(CGFloat) x;

- (void) centerWithY:(CGFloat) y;

- (void) centerXToView:(UIView *) aView;

- (void) centerYToView:(UIView *) aView;

- (NSString *) frameToString;
- (NSString *) centerToString;
- (NSString *) boundsToString;

@end
