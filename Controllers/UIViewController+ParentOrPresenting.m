
#import "UIViewController+ParentOrPresenting.h"


#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation UIViewController (UIViewController_ParentOrPresenting)

- (UIViewController *) parentOrPresentingViewController {
  DDLogDebug(@"looking for parent or presenting view controller");
  UIViewController *parent = nil;
  if ([self respondsToSelector:@selector(presentingViewController)]) {
    parent = self.presentingViewController;
  } else {
    parent = self.parentViewController;
  }
  if (parent == nil) {
    DDLogError(@"could not find the parent");
  }
  return parent;
}

@end
