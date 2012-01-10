#import <Foundation/Foundation.h>

extern NSString *LjsNumericPickerDelegatePickerViewDidChangeNotification;
extern NSString *LjsNumericPickerDelegatePickerViewStringValueUserInfoKey;
extern NSString *LjsNumericPickerDelegatePickerViewIntegerValueUserInfoKey;
extern NSUInteger const LjsNumericPickerDelegageMaximumInteger; 

@protocol LjsNumericPickerDidChangeCallBackDelegate <NSObject>

@required
- (void) pickerView:(UIPickerView *) pickerView 
    didChangeString:(NSString *) newString
   didChangeInteger:(NSUInteger) newInteger;

@end

@interface LjsNumericPickerDelegate : NSObject <UIPickerViewDelegate, UIPickerViewDataSource> 

@property (nonatomic, unsafe_unretained) id<LjsNumericPickerDidChangeCallBackDelegate> callbackDelegate;
@property (nonatomic, strong) NSArray *digitsForMostSignicantColumn;
@property (nonatomic, strong) NSArray *zeroToNine;
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger startingValue;
@property (nonatomic, assign) NSUInteger maxValue;
@property (nonatomic, copy) NSString *maxStrValue;
@property (nonatomic, assign) NSUInteger minValue;
@property (nonatomic, copy) NSString *minStrValue;
@property (nonatomic, assign) NSUInteger minimumMostSignicantColumn;
@property (nonatomic, copy) NSString *minimumMostSignicantDigit;
@property (nonatomic, copy) NSString *conversionFormatString;


- (id) initWithCallbackDelegate:(id<LjsNumericPickerDidChangeCallBackDelegate>) aCallbackDelegate
                  startingValue:(NSUInteger) aStartingValue
                       minValue:(NSUInteger) aMinValue
                       maxValue:(NSUInteger) aMaxValue;

- (NSString *) stringFromPicker:(UIPickerView *) pickerView;
- (NSUInteger) integerFromPicker:(UIPickerView *) pickerView;
- (NSArray *) digitsForMostSignificantColumnWithMaximumValue:(NSUInteger) aMaxValue;

- (void) pickerView:(UIPickerView *) pickerView setSelectedWithInteger:(NSUInteger) aInteger;
- (void) pickerView:(UIPickerView *) pickerView setSelectedWithString:(NSString *) aString;

- (NSInteger) indexForString:(NSString *) string inArray:(NSArray *) array;


@end
