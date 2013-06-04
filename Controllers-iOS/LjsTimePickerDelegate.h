// Copyright 2011 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
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


