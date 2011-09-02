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

//  LjsFormattersTests.m
//  ProjectTemplate
//
//  Created by Joshua Moody on 12/31/10.

// a1 is always the RECEIVED value
// a2 is always the EXPECTED value
// GHAssertNoErr(a1, description, ...)
// GHAssertErr(a1, a2, description, ...)
// GHAssertNotNULL(a1, description, ...)
// GHAssertNULL(a1, description, ...)
// GHAssertNotEquals(a1, a2, description, ...)
// GHAssertNotEqualObjects(a1, a2, desc, ...)
// GHAssertOperation(a1, a2, op, description, ...)
// GHAssertGreaterThan(a1, a2, description, ...)
// GHAssertGreaterThanOrEqual(a1, a2, description, ...)
// GHAssertLessThan(a1, a2, description, ...)
// GHAssertLessThanOrEqual(a1, a2, description, ...)
// GHAssertEqualStrings(a1, a2, description, ...)
// GHAssertNotEqualStrings(a1, a2, description, ...)
// GHAssertEqualCStrings(a1, a2, description, ...)
// GHAssertNotEqualCStrings(a1, a2, description, ...)
// GHAssertEqualObjects(a1, a2, description, ...)
// GHAssertEquals(a1, a2, description, ...)
// GHAbsoluteDifference(left,right) (MAX(left,right)-MIN(left,right))
// GHAssertEqualsWithAccuracy(a1, a2, accuracy, description, ...)
// GHFail(description, ...)
// GHAssertNil(a1, description, ...)
// GHAssertNotNil(a1, description, ...)
// GHAssertTrue(expr, description, ...)
// GHAssertTrueNoThrow(expr, description, ...)
// GHAssertFalse(expr, description, ...)
// GHAssertFalseNoThrow(expr, description, ...)
// GHAssertThrows(expr, description, ...)
// GHAssertThrowsSpecific(expr, specificException, description, ...)
// GHAssertThrowsSpecificNamed(expr, specificException, aName, description, ...)
// GHAssertNoThrow(expr, description, ...)
// GHAssertNoThrowSpecific(expr, specificException, description, ...)
// GHAssertNoThrowSpecificNamed(expr, specificException, aName, description, ...)

#import <GHUnit/GHUnit.h>
#import "LjsFormatters.h"

@interface LjsFormattersTests : GHTestCase {}
@property (nonatomic, retain) LjsFormatters *formatters;
@end

@implementation LjsFormattersTests
@synthesize formatters;

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void)setUpClass {
  // Run at start of all tests in the class
  self.formatters = [LjsFormatters sharedInstance];
}

- (void)tearDownClass {
  // Run at end of all tests in the class
  [formatters release];
}

- (void)setUp {
  // Run before each test method
}

- (void)tearDown {
  // Run after each test method
}  

- (void) test_stringWithTwoDecimalPlacesWithDouble {
  
  NSString *string = [formatters stringWithTwoDecimalPlacesWithDouble:2.335];
  GHAssertEquals([[NSNumber numberWithInt:[string length]] intValue],
                 [[NSNumber numberWithInt:4] intValue], nil);
  GHAssertEqualStrings(string, @"2.34", nil);
  
  string = [formatters stringWithTwoDecimalPlacesWithDouble:0.01];
  GHAssertEqualStrings(string, @"0.01", nil);
  
  string = [formatters stringWithTwoDecimalPlacesWithDouble:29924242.32];
  GHAssertEqualStrings(string, @"29924242.32", nil);
  
}


- (void) test_stringToCurrencyWithDouble {
  NSString *string = [formatters stringToCurrencyWithDouble:2.335];
  GHAssertEqualStrings(string, @"$2.34", nil);
  
  string = [formatters stringToCurrencyWithDouble:0.01];
  GHAssertEqualStrings(string, @"$0.01", nil);
}

- (void) test_truncateDoubletoNDecimalPlaces {
  double tmp = [formatters truncateDouble:2.335 toNDecimalPlaces:2];
  GHAssertEquals([[NSNumber numberWithDouble:tmp] doubleValue],
                 [[NSNumber numberWithDouble:2.34] doubleValue], nil);

  tmp = [formatters truncateDouble:2.335 toNDecimalPlaces:3];
  GHAssertEquals([[NSNumber numberWithDouble:tmp] doubleValue],
                 [[NSNumber numberWithDouble:2.335] doubleValue], nil);
  
  tmp = [formatters truncateDouble:2.334 toNDecimalPlaces:0];
  GHAssertEquals([[NSNumber numberWithDouble:tmp] doubleValue],
                 [[NSNumber numberWithDouble:2.334] doubleValue], nil);
}

- (void) test_settingDefaultHandlerOfNSDecimalNumber {
  NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:@"123.456"];
  GHAssertEqualsWithAccuracy((double)[number doubleValue], (double)123.456, 0.001, nil);
  GHAssertEquals((int)[[NSDecimalNumber defaultBehavior] roundingMode], (int)NSRoundPlain, nil);
  GHAssertEquals((int)[[NSDecimalNumber defaultBehavior] scale], (int)NSDecimalNoScale, nil);
  
  [NSDecimalNumber setDefaultBehavior:[[LjsFormatters sharedInstance] currencyHandler]];
  
  GHAssertEquals((int)[[NSDecimalNumber defaultBehavior] roundingMode], (int)NSRoundBankers, nil);
  GHAssertEquals((int)[[NSDecimalNumber defaultBehavior] scale], (int)LjsCurrencyScale, nil);

  number = [NSDecimalNumber decimalNumberWithString:@"123.456"];
  
  NSDecimalNumber *added = [number decimalNumberByAdding:[NSDecimalNumber zero]];
  NSDecimalNumber *rounded = [[LjsFormatters sharedInstance] roundWithCurrencyHandler:number];
  GHAssertEquals((double)[rounded doubleValue], (double)[added doubleValue], nil);
    
  [NSDecimalNumber setDefaultBehavior:[NSDecimalNumberHandler defaultDecimalNumberHandler]];
  GHAssertEquals((int)[[NSDecimalNumber defaultBehavior] roundingMode], (int)NSRoundPlain, nil);
  GHAssertEquals((int)[[NSDecimalNumber defaultBehavior] scale], (int)NSDecimalNoScale, nil);
}

- (void) test_roundWithCurrencyHandler {
  //- (NSDecimalNumber *) roundWithCurrencyHandler:(NSDecimalNumber *) number;
  NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:@"123.454"];
  NSDecimalNumber *actual = [formatters roundWithCurrencyHandler:number];
  GHAssertEqualStrings([actual stringValue], @"123.45", nil);
  
  number = [NSDecimalNumber decimalNumberWithString:@"123.456"];
  actual = [formatters roundWithCurrencyHandler:number];
  GHAssertEqualStrings([actual stringValue], @"123.46", nil);
  
  number = [NSDecimalNumber decimalNumberWithString:@"123.4555"];
  actual = [formatters roundWithCurrencyHandler:number];
  GHAssertEqualStrings([actual stringValue], @"123.46", nil);
  
  
}


- (void) test_roundWithTenthsHandler {
  NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:@"123.454"];
  NSDecimalNumber *actual = [formatters roundWithTenthsHandler:number];
  GHAssertEqualStrings([actual stringValue], @"123.5", nil);
  
  number = [NSDecimalNumber decimalNumberWithString:@"123.43"];
  actual = [formatters roundWithTenthsHandler:number];
  GHAssertEqualStrings([actual stringValue], @"123.4", nil);
    
}

- (void) test_roundWithHundredthsHandler {
  NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:@"123.454"];
  NSDecimalNumber *actual = [formatters roundWithHundredthsHandler:number];
  GHAssertEqualStrings([actual stringValue], @"123.45", nil);
  
  number = [NSDecimalNumber decimalNumberWithString:@"123.43"];
  actual = [formatters roundWithHundredthsHandler:number];
  GHAssertEqualStrings([actual stringValue], @"123.43", nil);
  
}

- (void) test_roundWithThousandthsHandler {
  NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:@"123.4567"];
  NSDecimalNumber *actual = [formatters roundWithThousandthsHandler:number];
  GHAssertEqualStrings([actual stringValue], @"123.457", nil);
  
  number = [NSDecimalNumber decimalNumberWithString:@"123.4561"];
  actual = [formatters roundWithThousandthsHandler:number];
  GHAssertEqualStrings([actual stringValue], @"123.456", nil);

}

- (void) test_handlerForPrecision {
  NSDecimalNumberHandler *actual = [formatters handlerForPrecision:LjsWholePrecision];
  GHAssertEqualObjects(actual, formatters.wholeHandler, nil);
  
  actual = [formatters handlerForPrecision:LjsTenthsPrecision];
  GHAssertEqualObjects(actual, formatters.tenthsHandler, nil);
  
  actual = [formatters handlerForPrecision:LjsHundredthsPrecision];
  GHAssertEqualObjects(actual, formatters.hundredthsHandler, nil);
  
  actual = [formatters handlerForPrecision:LjsThousandthsPrecision];
  GHAssertEqualObjects(actual, formatters.thousandthsHandler, nil);
  
  actual = [formatters handlerForPrecision:@""];
  GHAssertNil(actual, nil);

}

- (void) test_hoursMinutesSecondsDateHandler {
  NSDateFormatter *formatter = [formatters hourMinutesSecondsFormatter];
  NSDate *longago = [NSDate date];
  NSString *result = [formatter stringFromDate:longago];
  GHTestLog(@"hourminutesecondsformatter = %@", result);
  
  longago = [NSDate dateWithTimeIntervalSinceReferenceDate:60];
  result = [formatter stringFromDate:longago];
  GHTestLog(@"hourminutesecondsformatter = %@", result);
}


@end
