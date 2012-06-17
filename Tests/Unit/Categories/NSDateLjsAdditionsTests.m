// Copyright 2012 Little Joy Software. All rights reserved.
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

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsTestCase.h"
#import "NSDate+LjsAdditions.h"
#import "LjsDateHelper.h"

@interface NSDateLjsAdditionsTests : LjsTestCase {}
@end

@implementation NSDateLjsAdditionsTests

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

- (void) test_dateByAddingDays {
  NSInteger daysToAdd;
  NSDate *date, *newDate;
  LjsDateComps newComps, expectedComps;
  NSInteger actualDay, expectedDay;
  
  newComps = [[NSDate date] dateComponents];
  newComps.year = 2012;
  newComps.month = 2;
  newComps.day = 8;
  newComps.hour = 12;
  newComps.minute = 30;
  newComps.second = 0;
  date = [NSDate dateWithComponents:newComps];
  
  
  daysToAdd = 3;
  newDate = [date dateByAddingDays:daysToAdd];
  expectedComps = [newDate dateComponents];
  actualDay = expectedComps.day;
  expectedDay = 11;
  GHAssertEquals((NSInteger)actualDay, (NSInteger)expectedDay, nil);
  

  daysToAdd = -3;
  newDate = [date dateByAddingDays:daysToAdd];
  expectedComps = [newDate dateComponents];
  actualDay = expectedComps.day;
  expectedDay = 5;
  GHAssertEquals((NSInteger)actualDay, (NSInteger)expectedDay, nil);


  daysToAdd = -8;
  newDate = [date dateByAddingDays:daysToAdd];
  expectedComps = [newDate dateComponents];
  actualDay = expectedComps.day;
  expectedDay = 31;
  GHAssertEquals((NSInteger)actualDay, (NSInteger)expectedDay, nil);

  daysToAdd = 21;
  newDate = [date dateByAddingDays:daysToAdd];
  expectedComps = [newDate dateComponents];
  actualDay = expectedComps.day;
  expectedDay = 29;
  GHAssertEquals((NSInteger)actualDay, (NSInteger)expectedDay, nil);
  

  daysToAdd = 22;
  newDate = [date dateByAddingDays:daysToAdd];
  expectedComps = [newDate dateComponents];
  actualDay = expectedComps.day;
  expectedDay = 1;
  GHAssertEquals((NSInteger)actualDay, (NSInteger)expectedDay, nil);
  
}

- (void) test_midnight {
  NSDate *date, *midnight;
  
  date = [NSDate date];
  midnight = [date midnight];
  GHTestLog(@"midnight = %@", [midnight descriptionWithCurrentLocale]);
  
  date = [date midnightWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600]];
  midnight = [date midnight];
  GHTestLog(@"midnight = %@", [midnight descriptionWithCurrentLocale]);

  date = [date midnightWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600 * 2]];
  midnight = [date midnight];
  GHTestLog(@"midnight = %@", [midnight descriptionWithCurrentLocale]);
}


- (void) test_dateComesBeforeDate_YES {
  NSDate *today = [NSDate date];
  NSDate *tomorrow = [NSDate tomorrow];
  GHAssertTrue([today comesBeforeDate:tomorrow], 
               @"date < %@ > should come before < %@ >",
               [today descriptionWithCurrentLocale], 
               [tomorrow descriptionWithCurrentLocale]);
}

- (void) test_dateComesBeforeDate_NO {
  NSDate *today = [NSDate date];
  NSDate *tomorrow = [NSDate tomorrow];
  GHAssertFalse([tomorrow comesBeforeDate:today], 
                @"date < %@ > should not come before < %@ >",
                [tomorrow descriptionWithCurrentLocale], 
                [today  descriptionWithCurrentLocale]);
}

- (void) test_date_comes_before_date_not_found {
  NSDate *a = [NSDate LjsDateNotFound];
  NSDate *b = [NSDate date];
  GHAssertFalse([a comesBeforeDate:b], @"LjsDateNotFound never comes before a date");
  GHAssertFalse([b comesBeforeDate:a], @"a date can never come before LjsDateNotFound");
}

- (void) test_dateComesAfterDate_YES {
  NSDate *today = [NSDate date];
  NSDate *tomorrow = [NSDate tomorrow];
  GHAssertTrue([tomorrow comesAfterDate:today],
                @"date < %@ > should come after < %@ >",
                [tomorrow descriptionWithCurrentLocale], 
                [today  descriptionWithCurrentLocale]);
}

- (void) test_dateComesAfterDate_NO {
  NSDate *today = [NSDate date];
  NSDate *tomorrow = [NSDate tomorrow];
  GHAssertFalse([today comesAfterDate:tomorrow],
               @"date < %@ > should not come after < %@ >",
               [today descriptionWithCurrentLocale], 
               [tomorrow  descriptionWithCurrentLocale]);
}

- (void) test_date_comes_after_date_not_found {
  NSDate *a = [NSDate LjsDateNotFound];
  NSDate *b = [NSDate date];
  GHAssertFalse([a comesAfterDate:b], @"LjsDateNotFound never comes after a date");
  GHAssertFalse([b comesAfterDate:a], @"a date can never come after LjsDateNotFound");
}


//- (BOOL) dateIsWithinSeconds:(NSTimeInterval) aSeconds
- (void) test_date_is_within_seconds_date_future {
  NSDateFormatter *df = [LjsDateHelper isoDateWithMillisFormatter];
  NSDate *receiver = [NSDate date];
  NSDate *other = [receiver dateByAddingTimeInterval:10];
  BOOL actual = [receiver isWithinSeconds:9
                                   ofDate:other];
  GHAssertTrue(actual, @"other date %@ is within 9 seconds of receiver %@ : %.5f",
               [df stringFromDate:other],
               [df stringFromDate:receiver],
               [receiver timeIntervalSinceDate:other]);

  actual = [receiver isWithinSeconds:10
                              ofDate:other];
  GHAssertFalse(actual, @"other date %@ not within 10 seconds of receiver %@ : %.5f",
               [df stringFromDate:other],
               [df stringFromDate:receiver],
               [receiver timeIntervalSinceDate:other]);

}

- (void) test_date_is_within_seconds_date_past {
  NSDateFormatter *df = [LjsDateHelper isoDateWithMillisFormatter];
  NSDate *receiver = [NSDate date];
  NSDate *other = [receiver dateByAddingTimeInterval:-10];
  BOOL actual = [receiver isWithinSeconds:9
                                   ofDate:other];
  GHAssertTrue(actual, @"other date %@ is within 9 seconds of receiver %@ : %.5f",
               [df stringFromDate:other],
               [df stringFromDate:receiver],
               [receiver timeIntervalSinceDate:other]);
  
  actual = [receiver isWithinSeconds:10
                              ofDate:other];
  GHAssertFalse(actual, @"other date %@ not within 10 seconds of receiver %@ : %.5f",
                [df stringFromDate:other],
                [df stringFromDate:receiver],
                [receiver timeIntervalSinceDate:other]);
  
}

- (void) test_date_is_almost_now {
//  NSDate *receiver = [NSDate date];
  BOOL actual = [[NSDate date] isAlmostNow];
//  NSDateFormatter *df = [LjsDateHelper isoDateWithMillisFormatter];
  GHAssertTrue(actual, @"now should be with 0.5 of now");
  actual = [[[NSDate date] dateByAddingTimeInterval:-10.0] isAlmostNow];
  GHAssertFalse(actual, @"now is not within 0.0 of now");
}

//- (NSString *) descriptionWithISO8601 {
- (void) test_description_with_iso_8601 {
  NSDate *date = [NSDate LjsDateNotFound];
  GHTestLog(@"date = %@", [date descriptionWithISO8601]);
  NSString *expected;
  
  // ios 4
  NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:0];
  if ([[tz abbreviation] length] > 3) {
    expected = @"40272-01-01 00:00:01.000 GMT+00:00";
  } else {
    expected = @"40272-01-01 00:00:01.000 GMT";
  }
  
  GHAssertEqualStrings([date descriptionWithISO8601], expected, 
                       @"date not found should always print the same way");
}

- (void) test_isSameAsDate_LjsNotFound {
  NSDate *a = [NSDate LjsDateNotFound];
  NSDate *b = [NSDate LjsDateNotFound];
  GHAssertTrue([a isSameAsDate:b], @"LjsDateNotFound should be sameAs");
}

- (void) test_isSameAsDate_NO {
  NSDate *a = [NSDate date];
  NSDate *b = [NSDate tomorrow];
  GHAssertFalse([a isSameAsDate:b], @"today and tomorrow should not be the same");
  
  a = [NSDate date];
  b = [NSDate date];
  GHAssertFalse([a isSameAsDate:b], @"now and a moment from now should not be the same");
}

- (void) test_isSameAsDate_YES {
  NSDate *date = [NSDate date];
  NSDate *a = [date dateByAddingTimeInterval:0];
  NSDate *b = [date dateByAddingTimeInterval:0];
  GHAssertTrue([a isSameAsDate:b], @"the two dates should be the same");
}

- (void) test_ljs_date_not_found {
  NSDate *a = [NSDate LjsDateNotFound];
  NSDate *b = [NSDate LjsDateNotFound];
  GHAssertEqualObjects(a, b, @"the two dates should be the same object");
  GHAssertTrue([a isNotFound], @"a should be LjsDateNotFound");
  GHAssertTrue([b isNotFound], @"b should be LjsDateNotFound");
}

@end