#import <UIKit/UIKit.h>

/**
 As of iOS 5, presentingViewController became available and is recommended over
 parentViewController.  This Category defines a method for getting the
 appropriate view controller for the iOS version.
 */
@interface UIViewController (UIViewController_ParentOrPresenting)

/** @name Finding the Parent or Presenting Controller */

/**
 @return the view controller that is the parent or presenting view controller
 */
- (UIViewController *) parentOrPresentingViewController;
@end
