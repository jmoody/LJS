// Copyright 2011 The Little Joy Software Company. All rights reserved.
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

#import "LjsTestCase.h"
#import "LjsDateHelper.h"
#import "LjsLocaleUtils.h"
#import <objc/runtime.h>
#import "NSDate+LjsAdditions.h"
#import "LjsGestalt.h"

@interface LjsDateHelperTests : LjsTestCase {}

- (NSString *) swizzledLjsDateHelperCanonicalAmWithString:(NSString *) ignored;

- (NSString *) swizzledLjsDateHelperCanonicalPmWithString:(NSString *) ignored;
@end


@implementation LjsDateHelperTests

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  [super setUpClass];
  // Run at start of all tests in the class
}

- (void) tearDownClass {
  // Run at end of all tests in the class
  [super tearDownClass];
}

- (void) setUp {
  [super setUp];
  // Run before each test method
}

- (void) tearDown {
  // Run after each test method
  [super tearDown];
}  

- (void) test_dateIsFuture {
  BOOL result;
  
  result = [LjsDateHelper dateIsFuture:[NSDate distantFuture]];
  GHAssertTrue(result, nil);
  
  result = [LjsDateHelper dateIsFuture:[NSDate distantPast]];
  GHAssertFalse(result, nil);
}
  
- (void) test_dateIsPast {
  BOOL result;
  
  result = [LjsDateHelper dateIsPast:[NSDate distantPast]];
  GHAssertTrue(result, nil);
  
  result = [LjsDateHelper dateIsPast:[NSDate distantFuture]];
  GHAssertFalse(result, nil);

}

- (void) test_upcaseAndRemovePeriodsFromAmPmString {
  NSString *amPmString, *actual, *expected;
  
  amPmString = nil;
  expected = nil;
  actual = [LjsDateHelper upcaseAndRemovePeroidsFromAmPmString:amPmString];
  GHAssertNil(actual, nil);
  
  amPmString = @"";
  expected = @"";
  actual = [LjsDateHelper upcaseAndRemovePeroidsFromAmPmString:amPmString];
  GHAssertEqualStrings(actual, expected, nil);
  
  amPmString = @"a.m.";
  expected = @"AM";
  actual = [LjsDateHelper upcaseAndRemovePeroidsFromAmPmString:amPmString];
  GHAssertEqualStrings(actual, expected, nil);

  amPmString = @"AM";
  expected = @"AM";
  actual = [LjsDateHelper upcaseAndRemovePeroidsFromAmPmString:amPmString];
  GHAssertEqualStrings(actual, expected, nil);

  amPmString = @"a.m.b.c.";
  expected = @"AMBC";
  actual = [LjsDateHelper upcaseAndRemovePeroidsFromAmPmString:amPmString];
  GHAssertEqualStrings(actual, expected, nil);

  amPmString = @"a.m.b@c.";
  expected = @"AMB@C";
  actual = [LjsDateHelper upcaseAndRemovePeroidsFromAmPmString:amPmString];
  GHAssertEqualStrings(actual, expected, nil);

}

- (void) test_canonicalAmWithString {
  NSString *am, *expected, *actual;
  
  am = nil;
  expected = nil;
  actual = [LjsDateHelper canonicalAmWithString:am];
  GHAssertNil(actual, nil);
  
  am = @"";
  expected = nil;
  actual = [LjsDateHelper canonicalAmWithString:am];
  GHAssertNil(actual, nil);

  am = @"a.m.extra";
  expected = nil;
  actual = [LjsDateHelper canonicalAmWithString:am];
  GHAssertNil(actual, nil);

  am = @"PM";
  expected = nil;
  actual = [LjsDateHelper canonicalAmWithString:am];
  GHAssertNil(actual, nil);

  
  am = @"am";
  expected = @"AM";
  actual = [LjsDateHelper canonicalAmWithString:am];
  GHAssertEqualStrings(actual, expected, nil);

  am = @"a.M.";
  expected = @"AM";
  actual = [LjsDateHelper canonicalAmWithString:am];
  GHAssertEqualStrings(actual, expected, nil);
  
  
}

- (void) test_canonicalPmWithString {
  NSString *pm, *expected, *actual;
  
  pm = nil;
  expected = nil;
  actual = [LjsDateHelper canonicalPmWithString:pm];
  GHAssertNil(actual, nil);
  
  pm = @"";
  expected = nil;
  actual = [LjsDateHelper canonicalPmWithString:pm];
  GHAssertNil(actual, nil);
  
  pm = @"p.m.extra";
  expected = nil;
  actual = [LjsDateHelper canonicalPmWithString:pm];
  GHAssertNil(actual, nil);
  
  pm = @"pm";
  expected = @"PM";
  actual = [LjsDateHelper canonicalPmWithString:pm];
  GHAssertEqualStrings(actual, expected, nil);
  
  pm = @"p.M.";
  expected = @"PM";
  actual = [LjsDateHelper canonicalPmWithString:pm];
  GHAssertEqualStrings(actual, expected, nil);
}

- (NSString *) swizzledLjsDateHelperCanonicalAmWithString:(NSString *) ignored {
  return @"AM";
}

- (NSString *) swizzledLjsDateHelperCanonicalPmWithString:(NSString *) ignored {
  return @"PM";
}

- (void) test_canonicalAmPmWithString {
  NSString *amOrPm, *expected, *actual;
  
  amOrPm = nil;
  expected = nil;
  actual = [LjsDateHelper canonicalAmPmWithString:amOrPm];
  GHAssertNil(actual, nil);

  amOrPm = @"";
  expected = nil;
  actual = [LjsDateHelper canonicalAmPmWithString:amOrPm];
  GHAssertNil(actual, nil);

  amOrPm = @"gibberish";
  expected = nil;
  actual = [LjsDateHelper canonicalAmPmWithString:amOrPm];
  GHAssertNil(actual, nil);

   
  Method originalAm = class_getClassMethod([LjsDateHelper class], @selector(canonicalAmWithString:));
  Method mockAm = class_getInstanceMethod([self class], @selector(swizzledLjsDateHelperCanonicalAmWithString:));
  method_exchangeImplementations(originalAm, mockAm);
  
  Method orignialPm = class_getClassMethod([LjsDateHelper class], @selector(canonicalPmWithString:));
  Method mockPm = class_getInstanceMethod([self class], @selector(swizzledLjsDateHelperCanonicalPmWithString:));
  method_exchangeImplementations(orignialPm, mockPm);
  

  
  amOrPm = @"am";
  expected = nil;
  actual = [LjsDateHelper canonicalAmPmWithString:amOrPm];
  GHAssertNil(actual, nil);

  method_exchangeImplementations(mockAm, originalAm);
  method_exchangeImplementations(mockPm, orignialPm);
  
  amOrPm = @"AM";
  expected = @"AM";
  actual = [LjsDateHelper canonicalAmPmWithString:amOrPm];
  GHAssertEquals(actual, expected, nil);

  amOrPm = @"PM";
  expected = @"PM";
  actual = [LjsDateHelper canonicalAmPmWithString:amOrPm];
  GHAssertEquals(actual, expected, nil);
}

- (void) test_isValidAmPmTime {
  NSString *time;
  BOOL actual;
  
  time = nil;
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"1234567890";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"12:00 AM";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertTrue(actual, nil);
  
  time = @"12:59 AM";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertTrue(actual, nil);
  
  time = @"1:59 AM";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertTrue(actual, nil);
  
  time = @"11:01 PM";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertTrue(actual, nil);
  
  time = nil;
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"13:01 AM";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"1:60 AM";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"12:01 CM";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"13:01";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"9:10 a.m.";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertTrue(actual, nil);

  time = @"12:10 a.m.";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertTrue(actual, nil);

  time = @"9:10 p.m.";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertTrue(actual, nil);

  time = @"12:10 p.m.";
  actual = [LjsDateHelper isValidAmPmTime:time];
  GHAssertTrue(actual, nil);
}

- (void) test_isValid24HourTime {
  NSString *time;
  BOOL actual;
  
  time = nil;
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"1234567890";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertFalse(actual, nil);

  time = @"123";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertFalse(actual, nil);

  time = @"12:00";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertTrue(actual, nil);
  
  time = @"12:00 PM";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertTrue(actual, nil);
  
  time = @"12:00 AM";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertFalse(actual, nil);
  
  time = @"15:00";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertTrue(actual, nil);

  time = @"15:00 PM";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertTrue(actual, nil);

  time = @"24:00";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertFalse(actual, nil);

  time = @"15:00 p.m.";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertTrue(actual, nil);
  
  time = @"15:00 pm";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertTrue(actual, nil);

  time = @"09:00 a.m.";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertTrue(actual, nil);
  
  time = @"09:00 am";
  actual = [LjsDateHelper isValid24HourTime:time];
  GHAssertTrue(actual, nil);



}

- (void) test_minuteStringValid {
  NSString *minutes;
  BOOL actual;
  
  minutes = nil;
  actual = [LjsDateHelper minutesStringValid:minutes];
  GHAssertFalse(actual, nil);

  minutes = @"";
  actual = [LjsDateHelper minutesStringValid:minutes];
  GHAssertFalse(actual, nil);
  
  minutes = @"00";
  actual = [LjsDateHelper minutesStringValid:minutes];
  GHAssertTrue(actual, nil);
  
  minutes = @"59";
  actual = [LjsDateHelper minutesStringValid:minutes];
  GHAssertTrue(actual, nil);

  minutes = @"--";
  actual = [LjsDateHelper minutesStringValid:minutes];
  GHAssertFalse(actual, nil);

  minutes = @"60";
  actual = [LjsDateHelper minutesStringValid:minutes];
  GHAssertFalse(actual, nil);

  minutes = @"-1";
  actual = [LjsDateHelper minutesStringValid:minutes];
  GHAssertFalse(actual, nil);
  
  minutes = @"045";
  actual = [LjsDateHelper minutesStringValid:minutes];
  GHAssertFalse(actual, nil);


}

- (void) test_hourStringValid {
  NSString *hours;
  BOOL actual, a24clock;
  
  hours = nil;
  a24clock = NO;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertFalse(actual, nil);
  
  hours = @"";
  a24clock = NO;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  
  hours = @"00";
  a24clock = NO;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  hours = @"00";
  a24clock = YES;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertTrue(actual, nil);
  

  hours = @"10";
  a24clock = YES;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertTrue(actual, nil);

  hours = @"10";
  a24clock = NO;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertTrue(actual, nil);

  hours = @"13";
  a24clock = YES;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertTrue(actual, nil);

  hours = @"13";
  a24clock = NO;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertFalse(actual, nil);
  
  hours = @"23";
  a24clock = YES;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertTrue(actual, nil);

  hours = @"23";
  a24clock = NO;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  hours = @"24";
  a24clock = YES;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  hours = @"-1";
  a24clock = YES;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertFalse(actual, nil);
  
  hours = @"013";
  a24clock = YES;
  actual = [LjsDateHelper hourStringValid:hours using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

}

- (void) test_amPmStringValid {
  NSString *amPm;
  BOOL actual;

  amPm = nil;
  actual = [LjsDateHelper amPmStringValid:amPm];
  GHAssertFalse(actual, nil);
  
  amPm = @"";
  actual = [LjsDateHelper amPmStringValid:amPm];
  GHAssertFalse(actual, nil);
  
  amPm = @"gibberish";
  actual = [LjsDateHelper amPmStringValid:amPm];
  GHAssertFalse(actual, nil);

  amPm = @"AM";
  actual = [LjsDateHelper amPmStringValid:amPm];
  GHAssertTrue(actual, nil);
  
  amPm = @"PM";
  actual = [LjsDateHelper amPmStringValid:amPm];
  GHAssertTrue(actual, nil);

  amPm = @"a.m.";
  actual = [LjsDateHelper amPmStringValid:amPm];
  GHAssertTrue(actual, nil);

  amPm = @"p.m.";
  actual = [LjsDateHelper amPmStringValid:amPm];
  GHAssertTrue(actual, nil);


}

- (void) test_timeStringHasCorrectLength {
  NSString *time;
  BOOL actual, a24clock;
  
  time = nil;
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);
  
  time = nil;
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  time = @"";
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  time = @"";
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);
  
  time = @"123";
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  time = @"123456";
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  time = @"123$";
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertTrue(actual, nil);
  
  time = @"1234567";
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertTrue(actual, nil);
  
  time = @"12345678";
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertTrue(actual, nil);
  
  time = @"12345678";
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertTrue(actual, nil);


  time = @"12345678901";
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);
  
  time = @"12345678901";
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);


  NSDateFormatter *formatter = [LjsDateHelper hoursMinutesAmPmFormatter];
  [formatter setLocale:[LjsLocaleUtils localeWith24hourClock]];
  time = [formatter stringFromDate:[NSDate date]];
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertTrue(actual, nil);

  [formatter setLocale:[LjsLocaleUtils localeWith12hourClock]];
  time = [formatter stringFromDate:[NSDate date]];
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectLength:time using24HourClock:a24clock];
  GHAssertTrue(actual, nil);
}


- (void) test_timeStringHasCorrectComponents {
  NSString *time;
  BOOL actual, a24clock;
  
  time = nil;
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectComponents:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);
  
  time = nil;
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectComponents:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);
  
  time = @"";
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectComponents:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  time = @"";
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectComponents:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  time = @"13:45";
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectComponents:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);
  

  time = @"13:45";
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectComponents:time using24HourClock:a24clock];
  GHAssertTrue(actual, nil);

  time = @"00:45 AM";
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectComponents:time using24HourClock:a24clock];
  GHAssertTrue(actual, nil);
  

  time = @"00:45 AM";
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectComponents:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  time = @"6:30 CM";
  a24clock = NO;
  actual = [LjsDateHelper timeStringHasCorrectComponents:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);

  time = @"6:30 CM";
  a24clock = YES;
  actual = [LjsDateHelper timeStringHasCorrectComponents:time using24HourClock:a24clock];
  GHAssertFalse(actual, nil);
  
}

- (void) test_componentsWithTimeString {
  NSString *amPmA, *twelveHourA, *twentyFourHoursA, *minuteA;
  NSString *amPmE, *twelveHourE, *twentyFourHoursE, *minuteE;
  
  NSInteger twelveHourNumberA, twentyFourHourNumberA, minuteNumberA;
  NSInteger twelveHourNumberE, twentyFourHourNumberE, minuteNumberE;
  
  NSString *timeString;
  NSDictionary *components;
  
  timeString = nil;
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNil(components, nil);
  
  timeString = @"";
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNil(components, nil);
  
  timeString = @"asdj@#!@#123";
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNil(components, nil);

  timeString = @"12:00 PM";
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNotNil(components, nil);
  amPmA = [components objectForKey:LjsDateHelperAmPmKey];
  amPmE = @"PM";
  GHAssertEqualStrings(amPmA, amPmE, nil);
  twelveHourA = [components objectForKey:LjsDateHelper12HoursStringKey];
  twelveHourE = @"12";
  GHAssertEqualStrings(twelveHourA, twelveHourE, nil);
  twentyFourHoursA = [components objectForKey:LjsDateHelper24HoursStringKey];
  twentyFourHoursE = @"12";
  GHAssertEqualStrings(twentyFourHoursA, twentyFourHoursE, nil);
  minuteA = [components objectForKey:LjsDateHelperMinutesStringKey];
  minuteE = @"00";
  GHAssertEqualStrings(minuteA, minuteE, nil);
  twelveHourNumberA = [[components objectForKey:LjsDateHelper12HoursNumberKey] integerValue];
  twelveHourNumberE = 12;
  GHAssertEquals((NSInteger)twelveHourNumberA, (NSInteger)twelveHourNumberE, nil);
  twentyFourHourNumberA = [[components objectForKey:LjsDateHelper24HoursNumberKey] integerValue];
  twentyFourHourNumberE = 12;
  GHAssertEquals((NSInteger)twentyFourHourNumberA, (NSInteger)twentyFourHourNumberE, nil);
  minuteNumberA = [[components objectForKey:LjsDateHelperMinutesNumberKey] integerValue];
  minuteNumberE = 0;
  GHAssertEquals((NSInteger)minuteNumberA, (NSInteger)minuteNumberE, nil);

  
  
  timeString = @"11:00 AM";
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNotNil(components, nil);
  amPmA = [components objectForKey:LjsDateHelperAmPmKey];
  amPmE = @"AM";
  GHAssertEqualStrings(amPmA, amPmE, nil);
  twelveHourA = [components objectForKey:LjsDateHelper12HoursStringKey];
  twelveHourE = @"11";
  GHAssertEqualStrings(twelveHourA, twelveHourE, nil);
  twentyFourHoursA = [components objectForKey:LjsDateHelper24HoursStringKey];
  twentyFourHoursE = @"11";
  GHAssertEqualStrings(twentyFourHoursA, twentyFourHoursE, nil);
  minuteA = [components objectForKey:LjsDateHelperMinutesStringKey];
  minuteE = @"00";
  GHAssertEqualStrings(minuteA, minuteE, nil);
  twelveHourNumberA = [[components objectForKey:LjsDateHelper12HoursNumberKey] integerValue];
  twelveHourNumberE = 11;
  GHAssertEquals((NSInteger)twelveHourNumberA, (NSInteger)twelveHourNumberE, nil);
  twentyFourHourNumberA = [[components objectForKey:LjsDateHelper24HoursNumberKey] integerValue];
  twentyFourHourNumberE = 11;
  GHAssertEquals((NSInteger)twentyFourHourNumberA, (NSInteger)twentyFourHourNumberE, nil);
  minuteNumberA = [[components objectForKey:LjsDateHelperMinutesNumberKey] integerValue];
  minuteNumberE = 0;
  GHAssertEquals((NSInteger)minuteNumberA, (NSInteger)minuteNumberE, nil);

  timeString = @"11:00 PM";
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNotNil(components, nil);
  amPmA = [components objectForKey:LjsDateHelperAmPmKey];
  amPmE = @"PM";
  GHAssertEqualStrings(amPmA, amPmE, nil);
  twelveHourA = [components objectForKey:LjsDateHelper12HoursStringKey];
  twelveHourE = @"11";
  GHAssertEqualStrings(twelveHourA, twelveHourE, nil);
  twentyFourHoursA = [components objectForKey:LjsDateHelper24HoursStringKey];
  twentyFourHoursE = @"23";
  GHAssertEqualStrings(twentyFourHoursA, twentyFourHoursE, nil);
  minuteA = [components objectForKey:LjsDateHelperMinutesStringKey];
  minuteE = @"00";
  GHAssertEqualStrings(minuteA, minuteE, nil);
  twelveHourNumberA = [[components objectForKey:LjsDateHelper12HoursNumberKey] integerValue];
  twelveHourNumberE = 11;
  GHAssertEquals((NSInteger)twelveHourNumberA, (NSInteger)twelveHourNumberE, nil);
  twentyFourHourNumberA = [[components objectForKey:LjsDateHelper24HoursNumberKey] integerValue];
  twentyFourHourNumberE = 23;
  GHAssertEquals((NSInteger)twentyFourHourNumberA, (NSInteger)twentyFourHourNumberE, nil);
  minuteNumberA = [[components objectForKey:LjsDateHelperMinutesNumberKey] integerValue];
  minuteNumberE = 0;
  GHAssertEquals((NSInteger)minuteNumberA, (NSInteger)minuteNumberE, nil);
  
  
  timeString = @"11:00 a.m.";
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNotNil(components, nil);
  amPmA = [components objectForKey:LjsDateHelperAmPmKey];
  amPmE = @"AM";
  GHAssertEqualStrings(amPmA, amPmE, nil);
  
  timeString = @"11:00 p.m.";
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNotNil(components, nil);
  amPmA = [components objectForKey:LjsDateHelperAmPmKey];
  amPmE = @"PM";
  GHAssertEqualStrings(amPmA, amPmE, nil);

  
  timeString = @"13:00 PM";
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNotNil(components, nil);
  amPmA = [components objectForKey:LjsDateHelperAmPmKey];
  amPmE = @"PM";
  GHAssertEqualStrings(amPmA, amPmE, nil);
  twelveHourA = [components objectForKey:LjsDateHelper12HoursStringKey];
  twelveHourE = @"1";
  GHAssertEqualStrings(twelveHourA, twelveHourE, nil);
  twentyFourHoursA = [components objectForKey:LjsDateHelper24HoursStringKey];
  twentyFourHoursE = @"13";
  GHAssertEqualStrings(twentyFourHoursA, twentyFourHoursE, nil);
  minuteA = [components objectForKey:LjsDateHelperMinutesStringKey];
  minuteE = @"00";
  GHAssertEqualStrings(minuteA, minuteE, nil);
  twelveHourNumberA = [[components objectForKey:LjsDateHelper12HoursNumberKey] integerValue];
  twelveHourNumberE = 1;
  GHAssertEquals((NSInteger)twelveHourNumberA, (NSInteger)twelveHourNumberE, nil);
  twentyFourHourNumberA = [[components objectForKey:LjsDateHelper24HoursNumberKey] integerValue];
  twentyFourHourNumberE = 13;
  GHAssertEquals((NSInteger)twentyFourHourNumberA, (NSInteger)twentyFourHourNumberE, nil);
  minuteNumberA = [[components objectForKey:LjsDateHelperMinutesNumberKey] integerValue];
  minuteNumberE = 0;
  GHAssertEquals((NSInteger)minuteNumberA, (NSInteger)minuteNumberE, nil);

  
  timeString = @"0:30";
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNotNil(components, nil);
  amPmA = [components objectForKey:LjsDateHelperAmPmKey];
  amPmE = @"AM";
  GHAssertEqualStrings(amPmA, amPmE, nil);
  twelveHourA = [components objectForKey:LjsDateHelper12HoursStringKey];
  twelveHourE = @"12";
  GHAssertEqualStrings(twelveHourA, twelveHourE, nil);
  twentyFourHoursA = [components objectForKey:LjsDateHelper24HoursStringKey];
  twentyFourHoursE = @"0";
  GHAssertEqualStrings(twentyFourHoursA, twentyFourHoursE, nil);
  minuteA = [components objectForKey:LjsDateHelperMinutesStringKey];
  minuteE = @"30";
  GHAssertEqualStrings(minuteA, minuteE, nil);
  twelveHourNumberA = [[components objectForKey:LjsDateHelper12HoursNumberKey] integerValue];
  twelveHourNumberE = 12;
  GHAssertEquals((NSInteger)twelveHourNumberA, (NSInteger)twelveHourNumberE, nil);
  twentyFourHourNumberA = [[components objectForKey:LjsDateHelper24HoursNumberKey] integerValue];
  twentyFourHourNumberE = 0;
  GHAssertEquals((NSInteger)twentyFourHourNumberA, (NSInteger)twentyFourHourNumberE, nil);
  minuteNumberA = [[components objectForKey:LjsDateHelperMinutesNumberKey] integerValue];
  minuteNumberE = 30;
  GHAssertEquals((NSInteger)minuteNumberA, (NSInteger)minuteNumberE, nil);

  timeString = @"0:30 AM";
  components = [LjsDateHelper componentsWithTimeString:timeString];
  GHAssertNotNil(components, nil);
  amPmA = [components objectForKey:LjsDateHelperAmPmKey];
  amPmE = @"AM";
  GHAssertEqualStrings(amPmA, amPmE, nil);
  twelveHourA = [components objectForKey:LjsDateHelper12HoursStringKey];
  twelveHourE = @"12";
  GHAssertEqualStrings(twelveHourA, twelveHourE, nil);
  twentyFourHoursA = [components objectForKey:LjsDateHelper24HoursStringKey];
  twentyFourHoursE = @"0";
  GHAssertEqualStrings(twentyFourHoursA, twentyFourHoursE, nil);
  minuteA = [components objectForKey:LjsDateHelperMinutesStringKey];
  minuteE = @"30";
  GHAssertEqualStrings(minuteA, minuteE, nil);
  twelveHourNumberA = [[components objectForKey:LjsDateHelper12HoursNumberKey] integerValue];
  twelveHourNumberE = 12;
  GHAssertEquals((NSInteger)twelveHourNumberA, (NSInteger)twelveHourNumberE, nil);
  twentyFourHourNumberA = [[components objectForKey:LjsDateHelper24HoursNumberKey] integerValue];
  twentyFourHourNumberE = 0;
  GHAssertEquals((NSInteger)twentyFourHourNumberA, (NSInteger)twentyFourHourNumberE, nil);
  minuteNumberA = [[components objectForKey:LjsDateHelperMinutesNumberKey] integerValue];
  minuteNumberE = 30;
  GHAssertEquals((NSInteger)minuteNumberA, (NSInteger)minuteNumberE, nil);

  NSDateFormatter *formatter = [LjsDateHelper hoursMinutesAmPmFormatter];
  timeString = [formatter stringFromDate:[NSDate date]];
  components = [LjsDateHelper componentsWithTimeString:timeString];
  // fails DE_CH
  GHAssertNotNil(components, @"failure is ok here - I am trying to catch errors for different locales. Time was: %@", timeString); 

}

- (void) test_weekOfYearWithDate {
  NSDate *date;
  NSInteger actual, expected;
  
  date = [NSDate dateWithTimeIntervalSince1970:0];
  expected = 1;
  actual = [LjsDateHelper weekOfYearWithDate:date];
  GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil);
  

  NSTimeInterval secondsInYear = LjsSecondsInTropicalYear;

  date = [NSDate dateWithTimeIntervalSince1970:secondsInYear];
  expected = 53;
  actual = [LjsDateHelper weekOfYearWithDate:date];
  GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil);

  
  NSUInteger jan1st2012 = 2012 - 1970;
  
  date = [NSDate dateWithTimeIntervalSince1970:secondsInYear * jan1st2012];
  expected = 52;
  actual = [LjsDateHelper weekOfYearWithDate:date];
  GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil);

  NSTimeInterval secondsInWeek = LjsSecondsInWeek;
  date = [NSDate dateWithTimeIntervalSince1970:(secondsInYear * jan1st2012) + secondsInWeek + 1];
  expected = 1;
  actual = [LjsDateHelper weekOfYearWithDate:date];
  GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil);  

  date = [NSDate dateWithTimeIntervalSince1970:(secondsInYear * jan1st2012) + (secondsInWeek * 2)+ 1];
  expected = 2;
  actual = [LjsDateHelper weekOfYearWithDate:date];
  GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil);  

}

- (void) test_weekOfMonth {
  NSDate *date;
  NSInteger actual, expected;

  
  if ([self.gestalt isMacOs] == YES) {
    GHTestLog(@"WARNING: skipping week of month tests on MacOS");
  } else {
    // a sunday
    //  NSUInteger yearsBetween = 2012 - 1970;
    //  NSTimeInterval secondsInYear = LjsSecondsInTropicalYear;
    // a sunday
    
    NSDate *jan1st2012 = [NSDate dateWithYear:2012
                                        month:1
                                          day:1
                                         hour:12
                                       minute:1
                                       second:1];
    date = jan1st2012;
    expected = 1;
    actual = [LjsDateHelper weekOfMonthWithDate:date];
    
    GHTestLog(@"actual week = %d : %@", actual, date);
    GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil);  
    
    NSTimeInterval secondsInADay = LjsSecondsInDay;
    date = [jan1st2012 dateByAddingTimeInterval:secondsInADay];
    expected = 2;
    actual = [LjsDateHelper weekOfMonthWithDate:date];
    GHTestLog(@"actual week = %d : %@", actual, date);
    GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil);  
    
    date = [jan1st2012 dateByAddingTimeInterval:secondsInADay * 2];
    expected = 2;
    actual = [LjsDateHelper weekOfMonthWithDate:date];
    GHTestLog(@"actual week = %d : %@", actual, date);
    GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil); 
    
    date = [jan1st2012 dateByAddingTimeInterval:secondsInADay * 7];
    expected = 2;
    actual = [LjsDateHelper weekOfMonthWithDate:date];
    GHTestLog(@"actual week = %d : %@", actual, date);
    GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil); 
    
    date = [jan1st2012 dateByAddingTimeInterval:secondsInADay * 8];
    expected = 3;
    actual = [LjsDateHelper weekOfMonthWithDate:date];
    GHTestLog(@"actual week = %d : %@", actual, date);
    GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil); 
    
    
    date = [jan1st2012 dateByAddingTimeInterval:secondsInADay * 30];
    expected = 6;
    actual = [LjsDateHelper weekOfMonthWithDate:date];
    GHTestLog(@"actual week = %d : %@", actual, date);
    GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil); 
    
    date = [jan1st2012 dateByAddingTimeInterval:secondsInADay * 31];
    expected = 1;
    actual = [LjsDateHelper weekOfMonthWithDate:date];
    GHTestLog(@"actual week = %d : %@", actual, date);
    GHAssertEquals((NSInteger) actual, (NSInteger) expected, nil); 
    
  }
}
  
- (void) test_lastDayOfMonthWithDate {
  NSDate *date, *actual;
  
  date = [NSDate date];
  actual = [LjsDateHelper lastDayOfMonthWithDate:date];
  GHTestLog(@"last day of month = %@", [actual descriptionWithLocale:[NSLocale currentLocale]]);
}

- (void) test_firstDayOfMonthWithDate {
  NSDate *date, *actual;
  
  date = [NSDate date];
  actual = [LjsDateHelper firstDayOfMonthWithDate:date];
  GHTestLog(@"first day of month = %@", [actual descriptionWithLocale:[NSLocale currentLocale]]);
}


//+ (NSArray *) datesWithWeek:(NSUInteger) aWeek ofYear:(NSUInteger) aYear
- (void) test_dates_with_week_of_year {
  
  NSArray *array = [LjsDateHelper datesWithWeek:24 ofYear:2012];
  NSDate *start = [NSDate dateWithYear:2012 month:6 day:11 hour:0 minute:0 second:1];
  [array mapc:^(NSDate *actual, NSUInteger idx, BOOL *stop) {
    GHTestLog(@"actual: %@", [actual descriptionWithCurrentLocale]);
    NSDate *expected = [start dateByAddingDays:idx];
    GHAssertTrue([actual isSameDay:expected], 
                 @"date actual date: %@ should have the same day as %@. failed at index: %d", 
                 actual, expected, idx);
  }];
}



@end
