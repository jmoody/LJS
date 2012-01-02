#import <Foundation/Foundation.h>

extern NSString *LjsTimePickerDelegatePickerViewDidChangeNotification;
extern NSString *LjsTimePickerDelegatePickerViewTimeUserInfoKey;

/**
 Provides a callback to notify pickerView owner that a change has occurred.
 */
@protocol LjsTimePickerDidChangeCallBackDelegate <NSObject>

@required
/**
 A callback to allow the pickerView owner to notify that a change has occurred.
 @param pickerView the picker view
 @param timeString the new value
 */
- (void) pickerView:(UIPickerView *) pickerView didChange:(NSString *) timeString;

@end

/**
 On iOS devices the Date and Time format can be overridden by the user settings,
 so regardless of Locale and NSDateFormatter settings you can end up with 
 unexpected/unparseable data and time values.  This can cause major headaches 
 when trying to layout views that contain date and time references.
 
 LjsTimePickerDelegate solves this problem by bypassing the normal Foundation
 date formatting and replacing it with LjsDateHelper methods.
 */
@interface LjsTimePickerDelegate : NSObject <UIPickerViewDelegate, UIPickerViewDataSource> 

/** @name Properties */

/**
 an array with am or pm - data source for rightmost column
 */
@property (nonatomic, strong) NSArray *amPm;

/**
 an array with 00 to 59 - data source for minutes column
 */
@property (nonatomic, strong) NSArray *minutes;

/**
 an array with 1 to 12 - data source for hours column
 */
@property (nonatomic, strong) NSArray *hours;

/**
 the callback delegate
 */
@property (nonatomic, unsafe_unretained) id<LjsTimePickerDidChangeCallBackDelegate> delegate;

/**
 localized AM
 */
@property (nonatomic, copy) NSString *AM;

/**
 localized PM
 */
@property (nonatomic, copy) NSString *PM;

/** @name Memory Management */

- (id) initWithDelegate:(id<LjsTimePickerDidChangeCallBackDelegate>) aDelegate;


/** @name Controlling the Value Displayed in PickerView */
- (void) pickerView:(UIPickerView *) pickerView setSelectedWithTimeString:(NSString *) timeString;

/** @name Utility */
- (NSInteger) indexForHour:(NSString *) hourString;
- (NSInteger) indexForMinute:(NSString *) minuteString;
- (NSInteger) indexForString:(NSString *) string inArray:(NSArray *) array;
- (NSString *) timeStringWithPicker:(UIPickerView *) pickerView;
- (NSString *) localizedAmPmTimeString:(NSString *) amPmTimeString swapAmPm:(BOOL) swap;
- (NSString *) localizedAmPmTimeStringWithDate:(NSDate *) date swapAmPm:(BOOL) swap;



@end


