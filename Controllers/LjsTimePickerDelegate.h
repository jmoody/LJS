#import <Foundation/Foundation.h>


extern NSString *LjsTimePickerDelegatePickerViewDidChangeNotification;
extern NSString *LjsTimePickerDelegatePickerViewTimeUserInfoKey;

@protocol LjsTimePickerDidChangeCallBackDelegate <NSObject>

@required
- (void) pickerView:(UIPickerView *) pickerView didChange:(NSString *) timeString;

@end


@interface LjsTimePickerDelegate : NSObject <UIPickerViewDelegate, UIPickerViewDataSource> 

@property (nonatomic, retain) NSArray *amPm;
@property (nonatomic, retain) NSArray *minutes;
@property (nonatomic, retain) NSArray *hours;
@property (nonatomic, assign) id<LjsTimePickerDidChangeCallBackDelegate> delegate;
@property (nonatomic, copy) NSString *AM;
@property (nonatomic, copy) NSString *PM;

- (id) initWithDelegate:(id<LjsTimePickerDidChangeCallBackDelegate>) aDelegate;

- (void) pickerView:(UIPickerView *) pickerView setSelectedWithTimeString:(NSString *) timeString;

- (NSInteger) indexForHour:(NSString *) hourString;
- (NSInteger) indexForMinute:(NSString *) minuteString;
- (NSInteger) indexForString:(NSString *) string inArray:(NSArray *) array;
- (NSString *) timeStringWithPicker:(UIPickerView *) pickerView;
- (NSString *) localizedAmPmTimeString:(NSString *) amPmTimeString swapAmPm:(BOOL) swap;
- (NSString *) localizedAmPmTimeStringWithDate:(NSDate *) date swapAmPm:(BOOL) swap;



@end


