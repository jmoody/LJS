#import <UIKit/UIKit.h>
#import "LjsPanAndZoomImageView.h"

@interface LjsPanZoomController : UIViewController

@property (nonatomic, strong) LjsPanAndZoomImageView *panAndZoom;

- (void) buttonTouchedResetTo1x:(id) sender;
- (void) configureViewForCurrentIndex;

@end
