// Copyright (c) 2010 Little Joy Software
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

//  LjsFormatters.h
//  ProjectTemplate
//
//  Created by Joshua Moody on 12/31/10.

#import <Foundation/Foundation.h>
#import "FTSWAbstractSingleton.h"

extern int const LjsWholeScale;
extern int const LjsCurrencyScale;
extern int const LjsTenthsScale;
extern int const LjsHundredthsScale;
extern int const LjsThousandthsScale;


extern NSString *LjsWholePrecision;
extern NSString *LjsTenthsPrecision;
extern NSString *LjsHundredthsPrecision;
extern NSString *LjsThousandthsPrecision;


extern NSRoundingMode const LjsDefaultRoundingMode;

extern NSString *LjsHoursMinutesSecondsDateFormat;

@interface LjsFormatters : FTSWAbstractSingleton {

}

@property (nonatomic, retain) NSNumberFormatter *twoDecimalPlacesFormatter;
@property (nonatomic, retain) NSNumberFormatter *currencyFormatter;
@property (nonatomic, retain) NSNumberFormatter *truncateFormatter;
@property (nonatomic, retain) NSDateFormatter *iso8601dateFormatter;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDateFormatter *hourMinutesSecondsFormatter;
@property (nonatomic, retain) NSDecimalNumberHandler *wholeHandler;
@property (nonatomic, retain) NSDecimalNumberHandler *currencyHandler;
@property (nonatomic, retain) NSDecimalNumberHandler *tenthsHandler;
@property (nonatomic, retain) NSDecimalNumberHandler *hundredthsHandler;
@property (nonatomic, retain) NSDecimalNumberHandler *thousandthsHandler;


/**
 returns the instance of this singleton object
 @return the LjsFormatters
 */
+ (LjsFormatters *) sharedInstance;


/**
 returns a string representation of the double, but with only two decimal places
 this method will round the 100's decimal place up if the 1000's place is >= 5
 for example 2.335 => 2.34
 useful for handling currency to string conversions
 @param number the number to convert
 @return a string with only two decimal places
 */
- (NSString *) stringWithTwoDecimalPlacesWithDouble:(double) number;

/**
 returns a string representation of the number, but as currency
 this method will round the 100's decimal place up if the 1000's place is >= 5
 for example 2.335 => $2.34
 @param number the number to convert
 @return a string that represents number as currency
 */
- (NSString *) stringToCurrencyWithDouble:(double) number;

/**
 returns a string representation of the number, but as currency
 this method will round the 100's decimal place up if the 1000's place is >= 5
 for example 2.335 => $2.34
 @param number the number to convert
 @return a string that represents number as currency
 */
- (NSString *) stringToCurrencyWithDecimal:(NSDecimalNumber *) number;

/**
 converts a double to another double with n significant decimal places
 this method will round the the nth decimal place by the n+1 decimal place
 for example, if n = 2 and number = 2.335, this method will return the equivalent
 to 2.34.  it is possible that if the double is printed, it will print with an
 indeterminate number of trailing zeros.  for example:  2.340000.
 
 n must be > 0
 
 @param number the number to convert
 @param n the number of significant decimal places
 @return truncates a double to n decimal places, rounding it up if the n+1 place
 is >= 5
 */
- (double) truncateDouble:(double) number toNDecimalPlaces:(int) n;


/**
 Rounds and scales number using self.currencyHandler which uses scale = 2,
 indicating 2 decimal places and rounding mode NSRoundBankers and returns a
 new NSDecimalNumber as the result.  
 
 From the docs:
 
 "Round to the closest possible return value; when halfway between two 
 possibilities, return the possibility whose last digit is even. In practice, 
 this means that, over the long run, numbers will be rounded up as often as they 
 are rounded down; there will be no systematic bias."
 @param number the number to rounded
 @return a new NSDecimalNumber
 */
- (NSDecimalNumber *) roundWithCurrencyHandler:(NSDecimalNumber *) number;

/**
 Rounds and scales number using self.tenthsHandler which uses scale = 1,
 indicating 1 decimal place and rounding mode NSRoundBankers and returns a
 new NSDecimalNumber as the result.
 From the docs:
 
 "Round to the closest possible return value; when halfway between two 
 possibilities, return the possibility whose last digit is even. In practice, 
 this means that, over the long run, numbers will be rounded up as often as they 
 are rounded down; there will be no systematic bias."
 @param number the number to rounded
 @return a new NSDecimalNumber
 */
- (NSDecimalNumber *) roundWithTenthsHandler:(NSDecimalNumber *) number;

/**
 Rounds and scales number using self.hundredthsHandler which uses scale = 2,
 indicating 1 decimal place and rounding mode NSRoundBankers and returns a
 new NSDecimalNumber as the result.
 From the docs:
 
 "Round to the closest possible return value; when halfway between two 
 possibilities, return the possibility whose last digit is even. In practice, 
 this means that, over the long run, numbers will be rounded up as often as they 
 are rounded down; there will be no systematic bias."
 @param number the number to rounded
 @return a new NSDecimalNumber
 */
- (NSDecimalNumber *) roundWithHundredthsHandler:(NSDecimalNumber *) number;

/**
 Rounds and scales number using self.thousandthsHandler which uses scale = 3,
 indicating 1 decimal place and rounding mode NSRoundBankers and returns a
 new NSDecimalNumber as the result.
 From the docs:
 
 "Round to the closest possible return value; when halfway between two 
 possibilities, return the possibility whose last digit is even. In practice, 
 this means that, over the long run, numbers will be rounded up as often as they 
 are rounded down; there will be no systematic bias."
 @param number the number to rounded
 @return a new NSDecimalNumber
 */
- (NSDecimalNumber *) roundWithThousandthsHandler:(NSDecimalNumber *) number;

/**
 tests the precision string against the known precision (whole, tenths, 
 hundredths, and thousandths) and returns the appropriate handler.  if no
 match is found, returns nil.
 @param precision a string representation of the precision
 @return the appropriate handler indicated by precision and nil if no match is found
 */
- (NSDecimalNumberHandler *) handlerForPrecision:(NSString *) precision;

@end
