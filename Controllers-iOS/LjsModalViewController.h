#import <UIKit/UIKit.h>
#import "UIViewController+ParentOrPresenting.h"

@class LjsModalViewController;

/**
 Provides a callback method that allows the presenter/owner of LjsModalViewController
 to ask its owner to be dismissed
 */
@protocol LjsModalWindowDismissDelegate <NSObject>

@required

/**
 a callback that allows the presenter/owner to call dismiss
 @param controller the controller that did finish
 */
- (void) controllerDidFinish:(LjsModalViewController *) controller;
@end


/**
 Intended an abstract class, LjsModalViewController provides a dismiss delegate.
 
 For capatibility across iOS 4 and 5, see the UIViewController+ParentOrPresenting
 category.
 */
@interface LjsModalViewController : UIViewController

/** @name Properties */

@property (nonatomic, assign) id<LjsModalWindowDismissDelegate> dismissDelegate;

/** @name Memory Management */

/**
 @return an initialized receiver
 @param nibNameOrNil the nib or nil
 @param nibBundleOrNil the nib bundle or nil
 @param aDismissDelegate the dismiss delegate
 */
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
       dismissDelegate:(id<LjsModalWindowDismissDelegate>) aDismissDelegate;

@end




