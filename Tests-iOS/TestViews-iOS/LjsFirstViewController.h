#import <UIKit/UIKit.h>
#import "LjsNumericPickerDelegate.h"

@interface LjsFirstViewController : UIViewController
<LjsNumericPickerDidChangeCallBackDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet UIPickerView *picker;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *label;
@property (nonatomic, strong) LjsNumericPickerDelegate *pickerDelegate;


@end
