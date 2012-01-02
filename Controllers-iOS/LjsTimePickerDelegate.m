// Copyright 2011 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsTimePickerDelegate.h"
#import "Lumberjack.h"
#import "LjsDateHelper.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *LjsTimePickerDelegatePickerViewDidChangeNotification = @"com.littlejoysoftware.ljs.LjsTimePickerDelegate Picker View Did Change Notification";
NSString *LjsTimePickerDelegatePickerViewTimeUserInfoKey = @"com.littlejoysoftware.ljs.LjsTimePickerDelegate Time User Info Key";

static NSInteger const LjsTimePickerLargeInteger = 24000;

@implementation LjsTimePickerDelegate

@synthesize amPm, minutes, hours;
@synthesize delegate;
@synthesize AM, PM;

#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating LjsDatePickerDelegate");
}


/**
 @return an initialized receiver
 @param aDelegate the callback delegate
 @bug Localization of AM/PM might not be a good idea from a layout point
 of view - AM for Portugal Locale is a.m. for example.
 */
- (id) initWithDelegate:(id<LjsTimePickerDidChangeCallBackDelegate>) aDelegate {
  self = [super init];
  if (self) {
    self.delegate = aDelegate;
    self.AM = NSLocalizedString(@"AM", @"before noon");
    self.PM = NSLocalizedString(@"PM", @"after noon");
    self.amPm = [NSArray arrayWithObjects:AM, PM, nil];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:60];
    NSInteger index;
    NSString *value;
    for (index = 0; index < 60; index++) {
      value = [NSString stringWithFormat:@"%02d", index];
      [array addObject:value];
    }
    
    self.minutes = array;
    
    array = [NSMutableArray arrayWithCapacity:12];
    for (index = 0; index < 12; index++) {
      value = [NSString stringWithFormat:@"%d", index + 1];
      [array addObject:value];
    }
    self.hours = array;
  }
  return self;
}

/** @name UIPickerViewDataSource */

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *) pickerView {
  return 3;
}


- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
  NSInteger result;
  switch (component) {
    case 0:
      result = LjsTimePickerLargeInteger;
      break;
    case 1:
      result = LjsTimePickerLargeInteger;
      break;
    case 2:
      result = 2;
      break;
    default:
      DDLogError(@"fell through switch statement for component: %d", component);
      result = 999;
      break;
  }
  return result;
}

/** @name UIPickerViewDelegate */
- (NSString *) pickerView:(UIPickerView *)pickerView 
              titleForRow:(NSInteger)row 
             forComponent:(NSInteger)component {
  NSString *result;
  switch (component) {
    case 0:
      return [self.hours objectAtIndex:row % [self.hours count]]; 
      break;
    case 1:
      return [self.minutes objectAtIndex:row % [self.minutes count]];
      break;
    case 2:
      return [self.amPm objectAtIndex:row];
      break;
    default:
      DDLogError(@"fell through switch for (row, component) = (%d, %d)", row, component);
      result = @"FIXME";
      break;
  }
  return result;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  NSString *timeString = [self timeStringWithPicker:pickerView];
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:timeString 
                                                       forKey:LjsTimePickerDelegatePickerViewTimeUserInfoKey];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:LjsTimePickerDelegatePickerViewDidChangeNotification
                                                      object:self
                                                    userInfo:userInfo];
  [self.delegate pickerView:pickerView didChange:timeString];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
  CGFloat result;
  switch (component) {
    case 0:
      return 50.0;
      break;
    case 1:
      return 50.0;
      break;
    case 2:
      return 50.0;
      break;
    default:
      DDLogError(@"fell through switch for component %d", component);
      result = 200;
      break;
  }
  return result;
}

/**
 @return a view
 @param pickerView the picker view
 @param row the row
 @param component the component
 @param view a view to reuse
 @bug Does not properly reuse the view.
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
  CGFloat width = [self pickerView:pickerView widthForComponent:component];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 45)];
  
  label.textAlignment = UITextAlignmentCenter;
  
  label.opaque = NO;
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor blackColor];
  label.font = [UIFont boldSystemFontOfSize:20];
  label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
  return label;
}


/**
 sets the picker view to represent the time in the timeString parameter
 @param pickerView a picker view
 @param timeString a time representation
 */
- (void) pickerView:(UIPickerView *) pickerView setSelectedWithTimeString:(NSString *) timeString {
  NSDictionary *dictionary = [LjsDateHelper componentsWithAmPmTimeString:timeString];
  NSString *amPmString, *hourString, *minuteString;
  if (dictionary != nil) {
    NSString *canonicalAmPm = [dictionary objectForKey:LjsDateHelperAmPmKey];
    if ([LjsDateHelperCanonicalAM isEqualToString:canonicalAmPm]) {
      amPmString = self.AM;
    } else {
      amPmString = self.PM;
    }
    hourString = [dictionary objectForKey:LjsDateHelper12HoursStringKey];
    minuteString = [dictionary objectForKey:LjsDateHelperMinutesStringKey];
  } else {
    amPmString = self.AM;
    hourString = @"12";
    minuteString = @"00";
  }
  
  if ([amPmString isEqualToString:self.AM]) {
    [pickerView selectRow:0 inComponent:2 animated:YES];
  } else {
    [pickerView selectRow:1 inComponent:2 animated:YES];
  }
  
  DDLogDebug(@"setting picker to: %@:%@ %@", hourString, minuteString, amPmString);
  [pickerView selectRow:12 * 2 + [self indexForHour:hourString] inComponent:0 animated:YES];
  [pickerView selectRow:60 * 2 + [self indexForMinute:minuteString] inComponent:1 animated:YES];

}

/**
 @return the index of hour
 @param hourString the hour to look for
 */
- (NSInteger) indexForHour:(NSString *) hourString {
  return [self indexForString:hourString inArray:self.hours];
}

/**
 @return the index of the minute
 @param minuteString the minute to look for
 */
- (NSInteger) indexForMinute:(NSString *) minuteString {
  return [self indexForString:minuteString inArray:self.minutes];
}

/**
 convenience method
 @return the index of a string in an array
 @param string the string to search for
 @param array the array to seach
 */
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


/**
 @return a string representation of the picker view
 @param pickerView the picker view
 */
- (NSString *) timeStringWithPicker:(UIPickerView *) pickerView {
  NSString *hoursString = [self.hours objectAtIndex:[pickerView selectedRowInComponent:0] % [self.hours count]];
  NSString *minutesString = [self.minutes objectAtIndex:[pickerView selectedRowInComponent:1] % [self.minutes count]];
  NSString *amPmString = [self.amPm objectAtIndex:[pickerView selectedRowInComponent:2]];
  return [NSString stringWithFormat:@"%@:%@ %@", hoursString, minutesString, amPmString];
}

/**
 @return a localized am pm time string
 @param timeString the string to localize
 @param swap if YES the am/pm'ness is swapped
 @bug localization might not be the way to go because some Locales like Portugal
 use a.m. which might effect the layout.
 */
- (NSString *) localizedAmPmTimeString:(NSString *) timeString swapAmPm:(BOOL) swap {
  NSString *result = nil;
  NSDictionary *dictionary = [LjsDateHelper componentsWithTimeString:timeString];
  if (dictionary != nil) {
    NSString *amPmStr = [dictionary objectForKey:LjsDateHelperAmPmKey];
    NSString *hoursStr = [dictionary objectForKey:LjsDateHelper12HoursStringKey];
    NSString *minutesStr = [dictionary objectForKey:LjsDateHelperMinutesStringKey];
    if ([LjsDateHelperCanonicalAM isEqualToString:amPmStr]) {
      amPmStr = self.AM;
    } else if ([LjsDateHelperCanonicalPM isEqualToString:amPmStr]) {
      amPmStr = self.PM;
    }
    
    if (swap == YES) {
      if ([amPmStr isEqualToString:self.AM]) {
        amPmStr = self.PM;
      } else {
        amPmStr = self.AM;
      }
    } 
    
    result = [NSString stringWithFormat:@"%@:%@ %@", hoursStr, minutesStr, amPmStr];
  }
  return result;
}

/**
 @return a localized am pm time string
 @param date the to localize
 @param swap if YES the am/pm'ness is swapped
 @bug localization might not be the way to go because some Locales like Portugal
 use a.m. which might effect the layout.
 */
- (NSString *) localizedAmPmTimeStringWithDate:(NSDate *) date swapAmPm:(BOOL) swap {
  NSDateFormatter *formatter = [LjsDateHelper hoursMinutesAmPmFormatter];
  NSString *timeString = [formatter stringFromDate:date];
  return [self localizedAmPmTimeString:timeString swapAmPm:swap];
}


@end
