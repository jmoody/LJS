#import <UIKit/UIKit.h>
#import "UIViewController+ParentOrPresenting.h"

@class LjsModalViewController;

@protocol LjsModalWindowDismissDelegate <NSObject>

@required
- (void) controllerDidFinish:(LjsModalViewController *) controller;
@end


@interface LjsModalViewController : UIViewController

@property (nonatomic, assign) id<LjsModalWindowDismissDelegate> delegate;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id) aDelegate;

@end




