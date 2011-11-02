#import <UIKit/UIKit.h>
#import "UIViewController+ParentOrPresenting.h"

@class LjsModalViewController;

@protocol LjsModalWindowDismissDelegate <NSObject>

@required
- (void) controllerDidFinish:(LjsModalViewController *) controller;
@end


@interface LjsModalViewController : UIViewController

@property (nonatomic, assign) id<LjsModalWindowDismissDelegate> dismissDelegate;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dismissDelegate:(id<LjsModalWindowDismissDelegate>) aDismissDelegate;

@end




