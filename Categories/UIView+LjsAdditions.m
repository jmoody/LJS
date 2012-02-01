#import "UIView+LjsAdditions.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation UIView (UIView_LjsAdditions)

- (void) centerWithX:(CGFloat) x {
  CGFloat selfy = self.center.y;
  self.center = CGPointMake(x, selfy);
  [self setNeedsDisplay];
}

- (void) centerWithY:(CGFloat) y {
  CGFloat selfx = self.center.x;
  self.center = CGPointMake(selfx, y);
  [self setNeedsDisplay];
}

- (void) centerXToView:(UIView *) aView {
  CGFloat aviewx = aView.center.x;
  [self centerWithX:aviewx];
}

- (void) centerYToView:(UIView *) aView {
  CGFloat aviewy = aView.center.y;
  [self centerWithY:aviewy];
}

- (NSString *) frameToString {
  return NSStringFromCGRect(self.frame);
}

- (NSString *) centerToString {
  return NSStringFromCGPoint(self.center);
}

- (NSString *) boundsToString {
  return NSStringFromCGRect(self.bounds);
}


@end
