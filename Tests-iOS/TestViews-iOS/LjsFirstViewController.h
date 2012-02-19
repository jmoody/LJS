#import <UIKit/UIKit.h>
#import "LjsNumericPickerDelegate.h"
#import "LjsGlassButton.h"
#import "LjsButton.h"
#import "LjsGradientView.h"

@interface LjsFirstViewController : UIViewController
<LjsNumericPickerDidChangeCallBackDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet UIPickerView *picker;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *label;
@property (nonatomic, unsafe_unretained) IBOutlet LjsGlassButton *glass;
@property (nonatomic, unsafe_unretained) IBOutlet LjsButton *ljs;

@property (nonatomic, strong) LjsNumericPickerDelegate *pickerDelegate;

@property (nonatomic, unsafe_unretained) IBOutlet LjsGradientView *progress;

- (IBAction)progressTouched:(id)sender;

@end
