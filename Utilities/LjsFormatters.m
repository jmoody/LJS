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

//  LjsFormatters.m
//  ProjectTemplate
//
//  Created by Joshua Moody on 12/31/10.

#import "LjsFormatters.h"
#import "Lumberjack.h"
#import "LjsGlobals.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


int const LjsWholeScale = 0;
int const LjsCurrencyScale = 2;
int const LjsTenthsScale = 1;
int const LjsHundredthsScale = 2;
int const LjsThousandthsScale = 3;

NSRoundingMode const LjsDefaultRoundingMode = NSRoundBankers;

NSString *LjsWholePrecision = @"1.0";
NSString *LjsTenthsPrecision = @"0.1";
NSString *LjsHundredthsPrecision = @"0.01";
NSString *LjsThousandthsPrecision = @"0.001";

NSString *LjsHoursMinutesSecondsDateFormat = @"H:mm:ss";

@implementation LjsFormatters

LjsFormatters *_singleton = nil;

@synthesize twoDecimalPlacesFormatter;
@synthesize currencyFormatter;
@synthesize truncateFormatter;
@synthesize iso8601dateFormatter;
@synthesize dateFormatter;
@synthesize wholeHandler;
@synthesize currencyHandler;
@synthesize tenthsHandler;
@synthesize hundredthsHandler;
@synthesize thousandthsHandler;
@synthesize hourMinutesSecondsFormatter;

+ (LjsFormatters *) sharedInstance {
  static LjsFormatters *s_MySingleton = nil;
  if (s_MySingleton == nil) {
    s_MySingleton = [self singleton];
  }
  return s_MySingleton;
}

- (id) initSingleton {
  self = [super initSingleton];
  if (self != nil) {
    self.twoDecimalPlacesFormatter = [[NSNumberFormatter alloc] init];
    [self.twoDecimalPlacesFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.twoDecimalPlacesFormatter setMaximumFractionDigits:2];
    [self.twoDecimalPlacesFormatter setUsesGroupingSeparator:NO];
    [self.twoDecimalPlacesFormatter release];
    
    self.currencyFormatter = [[NSNumberFormatter alloc] init];
    [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];              
    [self.currencyFormatter release];
    
    self.truncateFormatter = [[NSNumberFormatter alloc] init];
    [self.truncateFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.truncateFormatter setMaximumFractionDigits:2];
    [self.truncateFormatter release];
    
    self.iso8601dateFormatter = [[NSDateFormatter alloc] init];
    [self.iso8601dateFormatter setDateFormat:Ljs_ISO8601_DateFormatWithMillis];
    [self.iso8601dateFormatter release];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter release];
    
    self.hourMinutesSecondsFormatter = [[NSDateFormatter alloc] init];
    [self.hourMinutesSecondsFormatter setDateFormat:LjsHoursMinutesSecondsDateFormat];
    [self.hourMinutesSecondsFormatter release];
    
    
    self.wholeHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:LjsDefaultRoundingMode
                                                                                  scale:LjsWholeScale
                                                                       raiseOnExactness:YES
                                                                        raiseOnOverflow:YES
                                                                       raiseOnUnderflow:YES
                                                                    raiseOnDivideByZero:YES];
    
    
    
    self.currencyHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:LjsDefaultRoundingMode
                                                                                       scale:LjsCurrencyScale
                                                                            raiseOnExactness:YES
                                                                             raiseOnOverflow:YES
                                                                            raiseOnUnderflow:YES
                                                                    raiseOnDivideByZero:YES];
    
    
    self.tenthsHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:LjsDefaultRoundingMode
                                                                                       scale:LjsTenthsScale
                                                                            raiseOnExactness:YES
                                                                             raiseOnOverflow:YES
                                                                            raiseOnUnderflow:YES
                                                                  raiseOnDivideByZero:YES];
    
    self.hundredthsHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:LjsDefaultRoundingMode
                                                                                scale:LjsHundredthsScale
                                                                     raiseOnExactness:YES
                                                                      raiseOnOverflow:YES
                                                                     raiseOnUnderflow:YES
                                                                  raiseOnDivideByZero:YES];

    self.thousandthsHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:LjsDefaultRoundingMode
                                                                                    scale:LjsThousandthsScale
                                                                         raiseOnExactness:YES
                                                                          raiseOnOverflow:YES
                                                                         raiseOnUnderflow:YES
                                                                      raiseOnDivideByZero:YES];
    
        
  }
  return self;
}

- (void) dealloc {
  [twoDecimalPlacesFormatter release];
  [currencyFormatter release];
  [truncateFormatter release];
  [iso8601dateFormatter release];
  [dateFormatter release];
  [hourMinutesSecondsFormatter release];
  [wholeHandler release];
  [currencyHandler release];
  [tenthsHandler release];
  [hundredthsHandler release];
  [thousandthsHandler release];
  [super dealloc];
}

- (NSString *) stringWithTwoDecimalPlacesWithDouble:(double) number {
  return [self.twoDecimalPlacesFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
}

- (NSString *) stringToCurrencyWithDouble:(double) number {
  return [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
}

- (NSString *) stringToCurrencyWithDecimal:(NSDecimalNumber *) number {
  return [self.currencyFormatter stringFromNumber:number];
}


- (double) truncateDouble:(double) number toNDecimalPlaces:(int) n {
  double result;
  if (n > 0) {
    [self.truncateFormatter setMaximumFractionDigits:n];
    result = [[self.truncateFormatter stringFromNumber:[NSNumber numberWithDouble:number]] doubleValue];
  } else {
    DDLogError(@"n must be > 0, but found %d thus no truncation is possible - returning the original number %f",
               n, number);
    result = number;
  }
  return result;
}


- (NSDecimalNumber *) roundWithCurrencyHandler:(NSDecimalNumber *) number {
  return [number decimalNumberByRoundingAccordingToBehavior:self.currencyHandler];
}

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
- (NSDecimalNumber *) roundWithTenthsHandler:(NSDecimalNumber *) number {
  return [number decimalNumberByRoundingAccordingToBehavior:self.tenthsHandler];
}

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
- (NSDecimalNumber *) roundWithHundredthsHandler:(NSDecimalNumber *) number {
  return [number decimalNumberByRoundingAccordingToBehavior:self.hundredthsHandler];
}

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
- (NSDecimalNumber *) roundWithThousandthsHandler:(NSDecimalNumber *) number {
  return [number decimalNumberByRoundingAccordingToBehavior:self.thousandthsHandler];
}

- (NSDecimalNumberHandler *) handlerForPrecision:(NSString *) precision {
  NSDecimalNumberHandler *result = nil;
  if ([precision isEqualToString:LjsWholePrecision]) {
    result = self.wholeHandler;
  } else if ([precision isEqualToString:LjsTenthsPrecision]) {
    result = self.tenthsHandler;
  } else if ([precision isEqualToString:LjsHundredthsPrecision]) {
    result = self.hundredthsHandler;
  } else if ([precision isEqualToString:LjsThousandthsPrecision]) {
    result = self.thousandthsHandler;
  } else {
    DDLogError(@"no handler was found for precision = %@ - returning nil", precision);
  }
  return result;
}



@end

