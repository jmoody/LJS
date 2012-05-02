#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsNumericPickerDelegate.h"
#import "Lumberjack.h"
#import "LjsLocaleUtils.h"
#import "NSDecimalNumber+LjsAdditions.h"

NSString *LjsNumericPickerDelegatePickerViewDidChangeNotification = @"com.littlejoysoftware.ljs LJS Numeric Picker Did Change Notification";
NSString *LjsNumericPickerDelegatePickerViewStringValueUserInfoKey = @"com.littlejoysoftware.ljs LJS Numeric Picker View String Value User Info Key";
NSString *LjsNumericPickerDelegatePickerViewIntegerValueUserInfoKey = @"com.littlejoysoftware.ljs LJS Numeric Picker View Integer Value User Info Key";

NSUInteger const LjsNumericPickerDelegageMaximumInteger = 99999;


static NSUInteger const LjsNumericPickerDelegateRowIndexOffset = 10 * 5;

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSInteger const LjsNumericPickerLargeInteger = 24000;

@implementation LjsNumericPickerDelegate

@synthesize callbackDelegate;
@synthesize digitsForMostSignicantColumn;
@synthesize zeroToNine;
@synthesize numberOfColumns;
@synthesize maxValue;
@synthesize minValue;
@synthesize minimumMostSignicantColumn;
@synthesize minimumMostSignicantDigit;
@synthesize startingValue;
@synthesize maxStrValue;
@synthesize minStrValue;
@synthesize conversionFormatString;


#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating %@", [self class]);
  self.callbackDelegate = nil;
}

- (id) initWithCallbackDelegate:(id<LjsNumericPickerDidChangeCallBackDelegate>) aCallbackDelegate
                  startingValue:(NSUInteger) aStartingValue
                       minValue:(NSUInteger) aMinValue
                       maxValue:(NSUInteger) aMaxValue { 
  self = [super init];
  if (self != nil) {
    NSDecimalNumber *start, *min, *max, *zero, *maxAllowed;
    start = [LjsDn dnWithInteger:aStartingValue];
    min = [LjsDn dnWithInteger:aMinValue];
    max = [LjsDn dnWithInteger:aMaxValue];
    zero = [NSDecimalNumber zero];
    maxAllowed = [LjsDn dnWithInteger:LjsNumericPickerDelegageMaximumInteger];
    NSAssert(aCallbackDelegate != nil, @"callback delegate must not be nil");
    NSAssert1([LjsDn dn:min gte:zero], @"< %@ > must be greater than zero", min);
    NSAssert2([LjsDn dn:max lte:maxAllowed], @"< %@ > must be <= %@", max, maxAllowed);
    NSAssert3([LjsDn dn:start isOnMin:min max:max],
              @"< %@ > must be on (%@, %@)", start, min, max);
    
    self.callbackDelegate = aCallbackDelegate;
    self.startingValue = aStartingValue;
    self.minValue = aMinValue;
    self.maxValue = aMaxValue;
    
    self.maxStrValue = [NSString stringWithFormat:@"%d", self.maxValue];
    self.minStrValue = [NSString stringWithFormat:@"%d", self.minValue];

    self.digitsForMostSignicantColumn = 
    [self digitsForMostSignificantColumnWithMaximumValue:aMaxValue];
    
    NSMutableArray *digits = [NSMutableArray array];
    for (NSUInteger index = 0; index < 10; index++) {
      [digits addObject:[NSString stringWithFormat:@"%d", index]];
    }
    
    self.zeroToNine = digits;
  
    NSString *minstr = [NSString stringWithFormat:@"%d", aMinValue];
    
    self.minimumMostSignicantDigit = [minstr substringToIndex:1];
    self.minimumMostSignicantColumn = self.numberOfColumns - [minstr length];
    
    NSString *maxstr = [NSString stringWithFormat:@"%d", aMaxValue];
    self.numberOfColumns = [maxstr length];
    self.conversionFormatString = [NSString stringWithFormat:@"\%%0%dd",
                                   self.numberOfColumns];
  }
  return self;
}

- (NSString *) stringFromPicker:(UIPickerView *) pickerView {
  NSMutableArray *values = [NSMutableArray array];
  
  NSInteger row = [pickerView selectedRowInComponent:0];
  NSString *value = [self.digitsForMostSignicantColumn objectAtIndex:row];
  [values addObject:value];
  
  NSInteger length = [self numberOfComponentsInPickerView:pickerView];
  for (int index = 1; index < length; index++) {
    value = [self.zeroToNine objectAtIndex:[pickerView selectedRowInComponent:index] % [self.zeroToNine count]];
    [values addObject:value];
  }
  return [values componentsJoinedByString:@""];
}

- (NSUInteger) integerFromPicker:(UIPickerView *) pickerView {
  NSString *string = [self stringFromPicker:pickerView];
  return [string integerValue];
}

- (NSArray *) digitsForMostSignificantColumnWithMaximumValue:(NSUInteger) aMaxValue {
  NSMutableArray *digits = [NSMutableArray array];
  NSString *string = [NSString stringWithFormat:@"%d", aMaxValue];
  NSString *first = [string substringToIndex:1];
  NSInteger number = [first integerValue];
  for (NSInteger index = 0; index <= number; index++) {
    [digits addObject:[NSString stringWithFormat:@"%d", index]];
  }
  return digits;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *) pickerView {
  return self.numberOfColumns;
}


- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
  NSInteger result;
  if (component == 0) {
    result = [self.digitsForMostSignicantColumn count];
  } else {
    result = LjsNumericPickerLargeInteger;
  }
  return result;
}

- (NSString *) pickerView:(UIPickerView *)pickerView 
              titleForRow:(NSInteger)row 
             forComponent:(NSInteger)component {
  NSString *result;
  if (component == 0) {
    result = [self.digitsForMostSignicantColumn objectAtIndex:row];
  } else {
    result = [self.zeroToNine objectAtIndex:row % [self.zeroToNine count]];
  }
  return result;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  NSString *string = [self stringFromPicker:pickerView];
  NSUInteger value = [string integerValue];
    
  if (value > self.maxValue) {
    DDLogDebug(@"value: %d is greater than max value %d", value, self.maxValue);
    [self pickerView:pickerView setSelectedWithString:self.maxStrValue];
    DDLogDebug(@"max str value = %@", maxStrValue);
    string = self.maxStrValue;
  } else if (value < self.minValue) {
    DDLogDebug(@"value: %d is less than min value %d", value, self.minValue);
    [self pickerView:pickerView setSelectedWithString:self.minStrValue];
    string = self.minStrValue;
  }
 
  NSDictionary *userInfo = 
  [NSDictionary dictionaryWithObjectsAndKeys:
   string, LjsNumericPickerDelegatePickerViewStringValueUserInfoKey,
   [NSNumber numberWithInteger:[string integerValue]], LjsNumericPickerDelegatePickerViewIntegerValueUserInfoKey, nil];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:LjsNumericPickerDelegatePickerViewDidChangeNotification
                                                      object:self
                                                    userInfo:userInfo];
  [self.callbackDelegate pickerView:pickerView 
                          didChangeString:string
                   didChangeInteger:[string integerValue]];
  
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
  return 50.0;
}



- (void) pickerView:(UIPickerView *) pickerView setSelectedWithInteger:(NSUInteger) aInteger {
  NSString *string = [NSString stringWithFormat:self.conversionFormatString, aInteger];
  [self pickerView:pickerView setSelectedWithString:string];
}

- (void) pickerView:(UIPickerView *) pickerView setSelectedWithString:(NSString *) aString {
  NSUInteger len = [aString length];
  NSString *string = [aString copy];
  if (len != self.numberOfColumns) {
    string = [NSString stringWithFormat:self.conversionFormatString, [aString integerValue]];
    len = [string length];
  }
 
  NSString *next;
  NSInteger rowIndex;
  
  for (NSUInteger index = 0; index < len; index++) {
    next = [string substringWithRange:NSMakeRange(index, 1)];
    if (index == 0) {
      rowIndex = [self indexForString:next inArray:self.digitsForMostSignicantColumn];
      [pickerView selectRow:rowIndex inComponent:index animated:YES];
    } else {
      rowIndex = [self indexForString:next inArray:self.zeroToNine];
      [pickerView selectRow:LjsNumericPickerDelegateRowIndexOffset + rowIndex 
                inComponent:index animated:YES];
    }
  }  
}

- (NSInteger) indexForString:(NSString *) string inArray:(NSArray *) array {
  NSInteger index = 0;
  for (NSString *value in array) {
    if ([value isEqualToString:string]) {
      return index;
    }
    index++;
  }
  return -1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row 
          forComponent:(NSInteger)component reusingView:(UIView *)view {
  CGFloat width = [self pickerView:pickerView widthForComponent:component];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 45)];
  
  label.opaque = NO;
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor blackColor];
  label.font = [UIFont boldSystemFontOfSize:20];
  label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
  label.textAlignment = UITextAlignmentCenter;
  return label;
}


@end
