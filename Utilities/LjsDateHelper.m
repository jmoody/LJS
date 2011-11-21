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

#import "LjsDateHelper.h"
#import "LjsValidator.h"
#import "Lumberjack.h"
#import "Reporter.h"



#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *LjsDateHelperCanonicalAM = @"AM";
NSString *LjsDateHelperCanonicalPM = @"PM";

NSString *LjsDateHelper12HoursStringKey = @"com.littlejoysoftware.ljs.Date Helper 12 Hours String Key";
NSString *LjsDateHelper24HoursStringKey = @"com.littlejoysoftware.ljs.Date Helper 24 Hours String Key";
NSString *LjsDateHelperMinutesStringKey = @"com.littlejoysoftware.ljs.Date Helper Minutes String Key";
NSString *LjsDateHelperAmPmKey = @"com.littlejoysoftware.ljs.Data Helper AM/PM Key";
NSString *LjsDateHelper12HoursNumberKey = @"com.littlejoysoftware.ljs.Date Helper 12 Hours Number key";
NSString *LjsDateHelper24HoursNumberKey = @"com.littlejoysoftware.ljs.Date Helper 24 Hours Number key";
NSString *LjsDateHelperMinutesNumberKey = @"com.littlejoysoftware.ljs.Date Helper Minutes Number key";

@implementation LjsDateHelper

// Disallow the normal default initializer for instances
- (id)init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (void) dealloc {
  [super dealloc];
}

+ (NSTimeInterval) intervalBetweenPast:(NSDate *) past future:(NSDate *) future {
  //DDLogWarn(@"needs unit test");
  NSTimeInterval result = [future timeIntervalSinceDate:past];
  return result;
}

+ (NSTimeInterval) timeIntervalWithHmsString:(NSString *) timeString {
  //DDLogWarn(@"needs unit test");
  NSArray *tokens = [timeString componentsSeparatedByString:@":"];
  NSTimeInterval accumulator = 0.0;
  for (int index = 0; index < 3; index++) {
    double value = [[tokens objectAtIndex:index] doubleValue];
    if (index == 0) {
      accumulator = accumulator + (value * 3600.0);
    } else if (index == 1) {
      accumulator = accumulator + (value * 60.0);
    } else if (index == 2) {
      accumulator = accumulator + value;
    }
  }
  return accumulator;
}

/*
 The receiver and anotherDate are exactly equal to each other, NSOrderedSame
 The receiver is later in time than anotherDate, NSOrderedDescending
 The receiver is earlier in time than anotherDate, NSOrderedAscending.
 */
+ (BOOL) dateIsFuture:(NSDate *) date {
  BOOL result;
  if ([date compare:[NSDate date]] == NSOrderedDescending) {
    result = YES;
  } else {
    result = NO;
  }
  return result;
}

+ (BOOL) dateIsPast:(NSDate *) date {
  return ![LjsDateHelper dateIsFuture:date];
}

#pragma mark HH:mm a - AM/PM time methods

+ (NSString *) upcaseAndRemovePeroidsFromAmPmString:(NSString *) anAmOrPmString {
  NSString *result;
  if (anAmOrPmString == nil) {
    result = nil;
  } else {
    NSString *upcased = [anAmOrPmString uppercaseString];
    result = [upcased stringByReplacingOccurrencesOfString:@"." withString:@""];
  }
  return result;
}

+ (BOOL) isCanonicalAmOrPm:(NSString *) amOrPm {
  return 
  [amOrPm isEqualToString:LjsDateHelperCanonicalAM] ||
  [amOrPm isEqualToString:LjsDateHelperCanonicalPM];
}

+ (NSString *) canonicalAmWithString:(NSString *) am {
  NSString *result;
  NSString *converted = [LjsDateHelper upcaseAndRemovePeroidsFromAmPmString:am];
  if (converted == nil) {
    result = nil;
  } else {
    if ([converted isEqualToString:LjsDateHelperCanonicalAM]) {
      result = LjsDateHelperCanonicalAM;
    } else {
      result = nil;
    }
  }
  return result;
}

+ (NSString *) canonicalPmWithString:(NSString *) pm {
  NSString *result;
  NSString *converted = [LjsDateHelper upcaseAndRemovePeroidsFromAmPmString:pm];
  if (converted == nil) {
    result = nil;
  } else {
    if ([converted isEqualToString:LjsDateHelperCanonicalPM]) {
      result = LjsDateHelperCanonicalPM;
    } else {
      result = nil;
    }
  }
  return result;
}

+ (NSString *) canonicalAmPmWithString:(NSString *) amOrPm {
  NSString *am = [LjsDateHelper canonicalAmWithString:amOrPm];
  NSString *pm = [LjsDateHelper canonicalPmWithString:amOrPm];
  NSString *result;
  if (am == nil && pm == nil) {
    result = nil;
  } else if (am != nil && pm != nil) {
    DDLogError(@"am is < %@ > and pm is < %@ > - expected one to be nil, return nil",
               am, pm);
    result = nil;
  } else if (am != nil) {
    result = am;
  } else if (pm != nil) {
    result = pm;
  }
  return result;
}



+ (BOOL) minutesStringValid:(NSString *) minutesStr {
  BOOL result = NO;
  if (minutesStr != nil && [minutesStr length] == 2 && [LjsValidator stringContainsOnlyNumbers:minutesStr]) {
    NSInteger minutesInt = [minutesStr integerValue];
    result = minutesInt > -1 && minutesInt < 60;
  }
  return result;
}

+ (BOOL) hourStringValid:(NSString *) hoursStr using24HourClock:(BOOL) use24HourClock {
  BOOL result = NO;
  if (hoursStr != nil && [hoursStr length] > 0 && 
      [hoursStr length] < 3 && 
      [LjsValidator stringContainsOnlyNumbers:hoursStr]) {
    NSInteger hoursInt = [hoursStr integerValue];
    if (use24HourClock == YES) {
      result =  hoursInt > -1 && hoursInt < 24;
    } else {
      result = hoursInt > 0 && hoursInt < 13;
    }
  }
  return result;
}

+ (BOOL) amPmStringValid:(NSString *) amOrPm {
  return [LjsDateHelper canonicalAmWithString:amOrPm] ||
  [LjsDateHelper canonicalPmWithString:amOrPm];
}


+ (BOOL) timeStringHasCorrectLength:(NSString *) timeString using24HourClock:(BOOL) a24Clock {
  BOOL result;
  if (a24Clock == YES) {
    result = (timeString != nil && ([timeString length] > 3 && [timeString length] < 11));
  } else {
    result = (timeString != nil && ([timeString length] > 6 && [timeString length] < 11));
  }
  return result;
}

+ (BOOL) amPmStringHasCorrectComponents:(NSString *) timeString {
  BOOL result;
  NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@": "];
  NSArray *tokens = [timeString componentsSeparatedByCharactersInSet:set];
  if ([tokens count] == 3) {
    NSString *amPm = [tokens objectAtIndex:2];
    NSString *hours = [tokens objectAtIndex:0];
    NSString *minutes = [tokens objectAtIndex:1];
    result = [LjsDateHelper amPmStringValid:amPm] &&
    [LjsDateHelper hourStringValid:hours using24HourClock:NO] &&
    [LjsDateHelper minutesStringValid:minutes];
  } else {
    result = NO;
  }
  return result;
}   
    
+ (BOOL) twentyFourHourTimeStringHasCorrectComponents:(NSString *) timeString {
  
  BOOL result;
  NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@": "];
  NSArray *tokens = [timeString componentsSeparatedByCharactersInSet:set];
  if ([tokens count] == 2) {
    NSString *hours = [tokens objectAtIndex:0];
    NSString *minutes = [tokens objectAtIndex:1];
    result = [LjsDateHelper hourStringValid:hours using24HourClock:YES] &&
    [LjsDateHelper minutesStringValid:minutes];
    
  } else if ([tokens count] == 3) {
    NSString *amPm = [tokens objectAtIndex:2];
    NSString *hours = [tokens objectAtIndex:0];
    NSString *minutes = [tokens objectAtIndex:1];
    result = [LjsDateHelper amPmStringValid:amPm] &&
    [LjsDateHelper hourStringValid:hours using24HourClock:YES] &&
    [LjsDateHelper minutesStringValid:minutes];
  } else {
    result = NO;
  }
  return result;
}

+ (BOOL) timeStringHasCorrectComponents:(NSString *) timeString using24HourClock:(BOOL) use24HourClock {
  BOOL result;
  NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@": "];
  NSArray *tokens = [timeString componentsSeparatedByCharactersInSet:set];
  
  if (use24HourClock == YES) {
    if ([tokens count] == 2 || [tokens count] == 3) {
      result = [LjsDateHelper twentyFourHourTimeStringHasCorrectComponents:timeString];
    } else {
      result = NO;
    }
  } else {
    if ([tokens count] == 3) {
      result = [LjsDateHelper amPmStringHasCorrectComponents:timeString];
    } else {
      result = NO;
    }
  }
  
  return result;
}


+ (BOOL) isValidAmPmTime:(NSString *) amPmTime {
  NSMutableArray *reasons = [NSMutableArray arrayWithCapacity:4];
  if ([LjsDateHelper timeStringHasCorrectLength:amPmTime using24HourClock:NO]) {
    if ([LjsDateHelper timeStringHasCorrectComponents:amPmTime using24HourClock:NO]) {
      NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@": "];
      NSArray *tokens = [amPmTime componentsSeparatedByCharactersInSet:set];
      NSString *hoursStr = [tokens objectAtIndex:0];
      if ([LjsDateHelper hourStringValid:hoursStr using24HourClock:NO] == NO) {
        [reasons addObject:[NSString stringWithFormat:@"hours portion of time are not within 1 and 12: %@", hoursStr]];
      }
      NSString *minutesStr = [tokens objectAtIndex:1];
      if ([LjsDateHelper minutesStringValid:minutesStr] == NO) {
        [reasons addObject:[NSString stringWithFormat:@"minutes portion of time are not within 0 and 59: %@", minutesStr]];
      }
    } else {
      [reasons addObject:@"string does not have the correct HH:mm a components or has non-numeric characters"];
    }
  } else {
    [reasons addObject:[NSString stringWithFormat:@"time in args is nil or of the wrong length: %@", amPmTime]];
  }
  BOOL result = [reasons count] == 0;
  if (result == NO) {
    //DDLogDebug(@"time: <%@> is not valid for these reasons: %@", amPmTime, reasons);
  }
  return result;
}

+ (BOOL) isValid24HourTime:(NSString *) a24hourTime {
  NSMutableArray *reasons = [NSMutableArray arrayWithCapacity:6];
  if ([LjsDateHelper timeStringHasCorrectLength:a24hourTime using24HourClock:YES]) {
    if ([LjsDateHelper timeStringHasCorrectComponents:a24hourTime using24HourClock:YES]) {
      NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@": "];
      NSArray *tokens = [a24hourTime componentsSeparatedByCharactersInSet:set];
      NSString *hoursStr = [tokens objectAtIndex:0];
      if ([LjsDateHelper hourStringValid:hoursStr using24HourClock:YES] == NO) {
        [reasons addObject:[NSString stringWithFormat:@"hours portion of time are not within 0 and 23: %@", hoursStr]];
      }
      NSString *minutesStr = [tokens objectAtIndex:1];
      if ([LjsDateHelper minutesStringValid:minutesStr] == NO) {
        [reasons addObject:[NSString stringWithFormat:@"minutes portion of time are not within 0 and 59: %d", minutesStr]];
      }
      if ([tokens count] == 3) {
        NSString *amPm = [tokens objectAtIndex:2];
        if ([LjsDateHelper isValidAmPmTime:amPm]) {
          [reasons addObject:[NSString stringWithFormat:@"%@ is not AM/PM", amPm]];
        }
        
        NSInteger hoursInt = [hoursStr integerValue];
        if (hoursInt > 11) {
          NSString *canonicalAmPm = [LjsDateHelper canonicalAmPmWithString:amPm];
          if (canonicalAmPm != nil && ![canonicalAmPm isEqualToString:LjsDateHelperCanonicalPM]) {
            [reasons addObject:[NSString stringWithFormat:@"hours string is %@, but AM/PM is %@",
                                hoursStr, amPm]];
          }
        } else if (hoursInt < 13) {
          NSString *canonicalAmPm = [LjsDateHelper canonicalAmPmWithString:amPm];
          if (canonicalAmPm != nil && ![canonicalAmPm isEqualToString:LjsDateHelperCanonicalAM]) {
            [reasons addObject:[NSString stringWithFormat:@"hours string is %@, but AM/PM is %@",
                                hoursStr, amPm]];
          }
        }
      }
      
    } else {
      [reasons addObject:@"string does not have the correct HH:mm components or has non-numeric characters"];
    }
  } else {
    
    [reasons addObject:[NSString stringWithFormat:@"time in args is nil or of the wrong length: %@", a24hourTime]];
  }
  BOOL result = [reasons count] == 0;
  if (result == NO) {
    //DDLogDebug(@"time: %@ is not valid for these reasons: %@", a24hourTime, reasons);
  }
  return result;
}

+ (NSDictionary *) componentsWithTimeString:(NSString *) timeString {
  NSDictionary *result = nil;
  if ([LjsDateHelper isValidAmPmTime:timeString]) {
    result = [LjsDateHelper componentsWithAmPmTimeString:timeString]; 
  } else if ([LjsDateHelper isValid24HourTime:timeString]) {
    result = [LjsDateHelper componentsWith24HourTimeString:timeString];
  }
  return result;
}


+ (NSDictionary *) componentsWith24HourTimeString:(NSString *) twentyFourHourTime {
  NSDictionary *result = nil;
  if ([LjsDateHelper isValid24HourTime:twentyFourHourTime]) {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@": "];
    NSArray *tokens = [twentyFourHourTime componentsSeparatedByCharactersInSet:set];    
    NSString *amPmString, *twelveHourString, *twentyFourHoursString, *minuteString;
    NSInteger twelveHourInt, twentyFourHourInt, minuteInt;
    NSNumber *twelveHourNumber, *twentyFourHourNumber, *minuteNumber;
    
    twentyFourHoursString = [tokens objectAtIndex:0];
    twentyFourHourInt = [twentyFourHoursString integerValue];
    twentyFourHourNumber = [NSNumber numberWithInteger:twentyFourHourInt];
    
    minuteString = [tokens objectAtIndex:1];
    minuteInt = [minuteString integerValue];
    minuteNumber = [NSNumber numberWithInteger:minuteInt];
    
    if (twentyFourHourInt == 0) {
      twelveHourString = @"12";
      twelveHourInt = 12;
      twelveHourNumber = [NSNumber numberWithInteger:twelveHourInt];
      amPmString = LjsDateHelperCanonicalAM;
    } else if (twentyFourHourInt > 12) {
      twelveHourInt = twentyFourHourInt - 12;
      twelveHourString = [NSString stringWithFormat:@"%d", twelveHourInt];
      twelveHourNumber = [NSNumber numberWithInteger:twelveHourInt];
      amPmString = LjsDateHelperCanonicalPM;
    } else {
      twelveHourString = twentyFourHoursString;
      twelveHourNumber = twentyFourHourNumber;
      amPmString = LjsDateHelperCanonicalAM;
    }

    result = [NSDictionary dictionaryWithObjectsAndKeys:
              twelveHourString, LjsDateHelper12HoursStringKey,
              twelveHourNumber, LjsDateHelper12HoursNumberKey,
              twentyFourHoursString, LjsDateHelper24HoursStringKey,
              twentyFourHourNumber, LjsDateHelper24HoursNumberKey,
              minuteString, LjsDateHelperMinutesStringKey,
              minuteNumber, LjsDateHelperMinutesNumberKey, 
              amPmString, LjsDateHelperAmPmKey, nil];

  } 
  return result;
}


+ (NSDictionary *) componentsWithAmPmTimeString:(NSString *) amPmTime {
  NSDictionary *result = nil;
  if ([LjsDateHelper isValidAmPmTime:amPmTime]) {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@": "];
    NSArray *tokens = [amPmTime componentsSeparatedByCharactersInSet:set];    
    NSString *amPmString, *twelveHourString, *twentyFourHourString, *minuteString;
    NSInteger twelveHourInt, twentyFourHourInt, minuteInt;
    NSNumber *twelveHourNumber, *twentyFourHourNumber, *minuteNumber;
    
    twelveHourString = [tokens objectAtIndex:0];
    twelveHourInt = [twelveHourString integerValue];
    twelveHourNumber = [NSNumber numberWithInteger:twelveHourInt];
    
    minuteString = [tokens objectAtIndex:1];
    minuteInt = [minuteString integerValue];
    minuteNumber = [NSNumber numberWithInteger:minuteInt];
    
    NSString *rawAmPm = [tokens objectAtIndex:2];
    amPmString = [LjsDateHelper canonicalAmPmWithString:rawAmPm];
    
    
    if ([amPmString isEqualToString:LjsDateHelperCanonicalAM]) {
      if (twelveHourInt == 12) {
        twentyFourHourString = @"00";
        twentyFourHourInt = 0;
        twentyFourHourNumber = [NSNumber numberWithInteger:twentyFourHourInt];
      } else {
        twentyFourHourInt = twelveHourInt;
        twentyFourHourString = [NSString stringWithFormat:@"%d", twentyFourHourInt];
        twentyFourHourNumber = [NSNumber numberWithInteger:twentyFourHourInt];
      }
    } else {
      if (twelveHourInt == 12) {
        twentyFourHourInt = twelveHourInt;
        twentyFourHourString = [NSString stringWithFormat:@"%d", twentyFourHourInt];
        twentyFourHourNumber = [NSNumber numberWithInteger:twentyFourHourInt];
      } else {
        twentyFourHourInt = twelveHourInt + 12;
        twentyFourHourString = [NSString stringWithFormat:@"%d", twentyFourHourInt];
        twentyFourHourNumber = [NSNumber numberWithInteger:twentyFourHourInt];
      }
    }
    
    result = [NSDictionary dictionaryWithObjectsAndKeys:
              twelveHourString, LjsDateHelper12HoursStringKey,
              twelveHourNumber, LjsDateHelper12HoursNumberKey,
              twentyFourHourString, LjsDateHelper24HoursStringKey,
              twentyFourHourNumber, LjsDateHelper24HoursNumberKey,
              minuteString, LjsDateHelperMinutesStringKey,
              minuteNumber, LjsDateHelperMinutesNumberKey, 
              amPmString, LjsDateHelperAmPmKey, nil];
    
  }
  return result;
}

+ (NSString *) amPmTimeWithTimeString:(NSString *) amPmTime {
  NSString *result = nil;
  NSDictionary *dictionary = [LjsDateHelper componentsWithAmPmTimeString:amPmTime];
  if (dictionary != nil) {
    result = [NSString stringWithFormat:@"%@:%@ %@",
              [dictionary objectForKey:LjsDateHelper12HoursStringKey],
              [dictionary objectForKey:LjsDateHelperMinutesStringKey],
              [dictionary objectForKey:LjsDateHelperAmPmKey]];
  }
  return result;
}


+ (NSString *) amPmTimeWithDate:(NSDate *) date {
  NSString *result = nil;
  if (date != nil) {
    NSDateFormatter *formatter = [LjsDateHelper hoursMinutesAmPmFormatter];
    return [formatter stringFromDate:date];
  }
  return result;
}


+ (NSDateFormatter *) hoursMinutesAmPmFormatter {
  NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
  [formatter setDateFormat:@"H:mm a"];
  return formatter;
}


+ (NSDateFormatter *) briefDateAndTimeFormatter {
  NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
  [formatter setDateFormat:@"ccc MMM d HH:mm a"];
  return formatter;
}

+ (NSString *) convert24hourTimeToAmPmTime:(NSString *) twentyFourHourTime {
  NSString *result = nil;
  if ([LjsDateHelper isValid24HourTime:twentyFourHourTime]) {
    NSDictionary *dictionary = [LjsDateHelper componentsWith24HourTimeString:twentyFourHourTime];
    NSString *amPm = [dictionary objectForKey:LjsDateHelperAmPmKey];
    NSString *hours = [dictionary objectForKey:LjsDateHelper12HoursStringKey];
    NSString *minutes = [dictionary objectForKey:LjsDateHelperMinutesStringKey];
    result = [NSString stringWithFormat:@"%@:%@ %@", hours, minutes, amPm];
  }
  return result;
}




#pragma mark DEAD SEA

//
//+ (NSDate *) dateWithHourMinutesString:(NSString *) hoursMinutes {
//  NSDate *result;
//   
//  NSArray *tokens = [hoursMinutes componentsSeparatedByString:@" "];
//  NSString *hoursMinutesPortion = [tokens objectAtIndex:0];
//  NSArray *hoursMinutesTokens = [hoursMinutesPortion componentsSeparatedByString:@":"];
//  NSString *hoursStr = [hoursMinutesTokens objectAtIndex:0];
//  NSString *minutesStr = [hoursMinutesTokens objectAtIndex:1];
//  NSInteger hours, minutes;
//  
//  hours = [hoursStr integerValue];
//  minutes = [minutesStr integerValue];
//
//  if ([tokens count] == 1) {
//    // nop
//  } else if ([tokens count] == 2) {
//    NSString *ampm = [tokens objectAtIndex:1];
//    if ([ampm isEqualToString:@"AM"]) {
//       // nop
//    } else {
//      hours = hours + 12;
//    }
//  } else {
//    DDLogError(@"%@ is not in the expected format of HH:mm or HH:mm a");
//  }
//  
//  //DDLogDebug(@"found %d hours and %d minutes", hours, minutes);
//  
//  NSCalendar *calendar = [NSCalendar currentCalendar];
//  NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
//  [components setTimeZone:[NSTimeZone localTimeZone]];
//  [components setHour:hours];
//  [components setMinute:minutes];
//  [components setYear:1970];
//  [components setDay:1];
//  [components setMonth:1];
//  
//  result = [calendar dateFromComponents:components];
//  NSString *formatString = @"yyyy-MM-dd HH:mm a z Z";
//  NSDateFormatter *formatter = [[[NSDateFormatter alloc]
//                                 init] autorelease];
//  [formatter setDateFormat:formatString];
//  NSString *dateString = [formatter stringFromDate:result];
////  result = [formatter dateFromString:dateString];
//  DDLogDebug(@"date string = %@, date = %@", dateString, result);
//  return result;
//}

/*
 + (NSDate *) dateReplacingHoursMinutesSeconds:(NSString *) twentyFourHourTimeString {
 NSDate *result = nil;
 if (twentyFourHourTimeString != nil && [LjsDateHelper isValid24HourTime:twentyFourHourTimeString]) {
 NSDate *now = [NSDate date];
 NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
 NSString *ISO8601_DateFormat = @"yyyy-MM-dd HH:mm:ss";
 [formatter setDateFormat:ISO8601_DateFormat];
 NSString *isoDateStr = [formatter stringFromDate:now];
 NSArray *tokens = [isoDateStr componentsSeparatedByString:@" "];
 NSString *yearMonthDay = [tokens objectAtIndex:0];
 
 NSDictionary *components = [LjsDateHelper componentsWithTimeString:twentyFourHourTimeString];
 NSString *hours = [components objectForKey:LjsDateHelper24HoursStringKey];
 NSString *minutes = [components objectForKey:LjsDateHelperMinutesStringKey];
 NSString *seconds = @"00";
 NSString *newHourMinSec = [NSString stringWithFormat:@"%@:%@:%@",
 hours, minutes, seconds];
 
 NSString *newDateStr  = [NSString stringWithFormat:@"%@ %@",
 yearMonthDay, newHourMinSec];
 result = [formatter dateFromString:newDateStr];
 
 }
 return result;
 }
*/

@end
