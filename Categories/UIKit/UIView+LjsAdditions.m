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
}

- (void) centerWithY:(CGFloat) y {
  CGFloat selfx = self.center.x;
  self.center = CGPointMake(selfx, y);
}

- (void) centerXToView:(UIView *) aView {
  CGFloat aviewx = aView.center.x;
  [self centerWithX:aviewx];
}

- (void) centerYToView:(UIView *) aView {
  CGFloat aviewy = aView.center.y;
  [self centerWithY:aviewy];
}


- (void) setHeightWithHeight:(CGFloat) h {
  CGFloat w = self.frame.size.width;
  [self setSizeWithWidth:w andHeight:h];
}

- (void) setWidthWithWidth:(CGFloat) w {
  CGFloat h = self.frame.size.height;
  [self setSizeWithWidth:w andHeight:h];
}

- (void) setSizeWithWidth:(CGFloat) w 
                andHeight:(CGFloat) h {
  CGRect frame = self.frame;
  self.frame = CGRectMake(frame.origin.x,
                          frame.origin.y,
                          w, h);
}

- (void) setXWithX:(CGFloat) x {
  CGFloat y = self.frame.origin.y;
  [self setOriginWithX:x andY:y];
}

- (void) setYWithY:(CGFloat) y {
  CGFloat x = self.frame.origin.x;
  [self setOriginWithX:x andY:y];
}

- (void) setEndXWithXInset:(CGFloat) xInset
                  withView:(UIView *) aView {
  CGFloat endX = [aView endX];  
  [self setEndXWithXInset:xInset withMaxWidth:endX];
}

- (void) setEndXWithXInset:(CGFloat) xInset
              withMaxWidth:(CGFloat) aMaxWidth {
  CGFloat w = self.frame.size.width;
  CGFloat x = aMaxWidth - w - xInset;
  [self setXWithX:x];
}

- (void) setEndYWithYInset:(CGFloat) yInset
                  withView:(UIView *) aView {
  CGFloat endY = [aView endY];
  [self setEndYWithYInset:yInset withMaxHeight:endY];
}

- (void) setEndYWithYInset:(CGFloat)yInset 
             withMaxHeight:(CGFloat)aMaxHeight {
  CGFloat h = self.frame.size.height;
  CGFloat y = aMaxHeight - h - yInset;
  [self setYWithY:y];
}


- (void) setOriginWithX:(CGFloat) x
                   andY:(CGFloat) y {
  CGRect frame = self.frame;
  self.frame = CGRectMake(x, y, 
                          frame.size.width, 
                          frame.size.height);
}

- (void) adjustX:(CGFloat) scale {
  self.frame = CGRectMake(self.frame.origin.x + scale,
                          self.frame.origin.y,
                          self.frame.size.width,
                          self.frame.size.height);
}

- (void) adjustY:(CGFloat) scale {
  self.frame = CGRectMake(self.frame.origin.x,
                          self.frame.origin.y + scale,
                          self.frame.size.width,
                          self.frame.size.height);
}

- (void) adjustW:(CGFloat) scale {
  self.frame = CGRectMake(self.frame.origin.x,
                          self.frame.origin.y,
                          self.frame.size.width + scale,
                          self.frame.size.height);
}

- (void) adjustH:(CGFloat) scale {
  self.frame = CGRectMake(self.frame.origin.x,
                          self.frame.origin.y,
                          self.frame.size.width,
                          self.frame.size.height + scale);
}

- (CGFloat) endX {
  CGRect frame = self.frame;
  return frame.origin.x + frame.size.width;
}

- (CGFloat) endY {
  CGRect frame = self.frame;
  return frame.origin.y + frame.size.height;
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

- (BOOL) containsSubviewWithTag:(NSInteger) aTag {
  return [self viewWithTag:aTag] != nil;
}

+ (CGRect) frameX:(CGFloat) aX
                w:(CGFloat) aWidth
                h:(CGFloat) aHeight
      centeredToH:(CGFloat) aCenterH {
  CGFloat y = (aCenterH/2) - (aHeight/2);
  return CGRectMake(aX, y, aWidth, aHeight);
}

@end
