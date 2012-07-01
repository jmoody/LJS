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
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsDateHelper.h"
#import "LjsLocaleUtils.h"
#import "Lumberjack.h"
#import "LjsValidator.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSTimeInterval const LjsSecondsInMinute = 60;
NSTimeInterval const LjsSecondsInHour = 3600;
NSTimeInterval const LjsSecondsInDay = 86400;
NSTimeInterval const LjsSecondsInWeek = 604800;
NSTimeInterval const LjsSecondsInTropicalYear = 31556925.9936;
NSTimeInterval const LjsSecondsInYear = 31556926;


NSString *LjsDateHelperCanonicalAM = @"AM";
NSString *LjsDateHelperCanonicalPM = @"PM";

NSString *LjsDateHelper12HoursStringKey = @"com.littlejoysoftware.ljs.Date Helper 12 Hours String Key";
NSString *LjsDateHelper24HoursStringKey = @"com.littlejoysoftware.ljs.Date Helper 24 Hours String Key";
NSString *LjsDateHelperMinutesStringKey = @"com.littlejoysoftware.ljs.Date Helper Minutes String Key";
NSString *LjsDateHelperAmPmKey = @"com.littlejoysoftware.ljs.Data Helper AM/PM Key";
NSString *LjsDateHelper12HoursNumberKey = @"com.littlejoysoftware.ljs.Date Helper 12 Hours Number key";
NSString *LjsDateHelper24HoursNumberKey = @"com.littlejoysoftware.ljs.Date Helper 24 Hours Number key";
NSString *LjsDateHelperMinutesNumberKey = @"com.littlejoysoftware.ljs.Date Helper Minutes Number key";


NSString *LjsHoursMinutesSecondsDateFormat = @"H:mm:ss";
NSString *LjsHoursMinutesSecondsMillisDateFormat = @"H:mm:ss:SSS";
NSString *LjsISO8601_DateFormatWithMillis = @"yyyy-MM-dd HH:mm:ss.SSS";

NSString *LjsISO8601_DateFormat = @"yyyy-MM-dd HH:mm:ss";
NSString *LjsOrderedDateFormat = @"yyyy_MM_dd_HH_mm";
NSString *LjsOrderedDateFormatWithMillis = @"yyyy_MM_dd_HH_mm_SSS";

@implementation LjsDateHelper

// Disallow the normal default initializer for instances
- (id)init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

/**
 @return the interval in milliseconds between the two dates
 
 @warning will return negative interval if past parameter is later than future
 paramter.
 
 @param past date in the past
 @param future date in the past
 */
+ (NSTimeInterval) intervalBetweenPast:(NSDate *) past future:(NSDate *) future {
  NSTimeInterval result = [future timeIntervalSinceDate:past];
  return result;
}

/**
 returns the number of seconds since midnight for a HH:mm:SS string
 
 @param aHHmmssString a string in HH:mm:ss format
 @return the number of seconds since 12:00a
 */
+ (NSTimeInterval) secondsSinceMidnightWithHHmmss:(NSString *) aHHmmssString {
  //DDLogWarn(@"needs unit test");
  NSArray *tokens = [aHHmmssString componentsSeparatedByString:@":"];
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

/**
 @return true iff the date is in the future
 @param date the date to compare to
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

/**
 @return true iff the date is in the past
 @param date the date to compare to
 */
+ (BOOL) dateIsPast:(NSDate *) date {
  return ![LjsDateHelper dateIsFuture:date];
}

#pragma mark HH:mm a - AM/PM time methods

/**
 some locales print AM/PM like this: a.m./p.m. - this method returns a string
 with no periods and uppercase
 
 @return a.m./p.m. ==> AM/PM or nil if anAmOrPmString is nil
 @param anAmOrPmString a string
 */
+ (NSString *) upcaseAndRemovePeroidsFromAmPmString:(NSString *) anAmOrPmString {
  NSString *result;
  if (anAmOrPmString == nil) {
    result = nil;
  } else {
    NSString *upcased = [anAmOrPmString uppercaseString];
    if ([@"VORM." isEqualToString:upcased]) {
      result = LjsDateHelperCanonicalAM;
    } else if ([@"NACHM." isEqualToString:upcased]) {
      result = LjsDateHelperCanonicalPM;
    } else {
      result = [upcased stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
  }
  return result;
}

/**
 @return true iff amOrPm matches AM or PM
 @param amOrPm a string
 */
+ (BOOL) isCanonicalAmOrPm:(NSString *) amOrPm {
  return 
  [amOrPm isEqualToString:LjsDateHelperCanonicalAM] ||
  [amOrPm isEqualToString:LjsDateHelperCanonicalPM];
}

/**
 @return AM or nil if am parameter cannot be converted
 @param am a string
 */
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

/**
 @return PM or nil if am parameter cannot be converted
 @param pm a string
 */
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

/**
 @return AM or PM or nil if parameter cannot be converted
 @param amOrPm a string representation of am or pm
 */
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


/**
 @return true iff parameter is non-nil and on (0, 59)
 @param minutesStr a string
 */
+ (BOOL) minutesStringValid:(NSString *) minutesStr {
  BOOL result = NO;
  if (minutesStr != nil && [minutesStr length] == 2 && [LjsValidator stringContainsOnlyNumbers:minutesStr]) {
    NSInteger minutesInt = [minutesStr integerValue];
    result = minutesInt > -1 && minutesInt < 60;
  }
  return result;
}

/**
 @return true iff hourStr is non-nil and on (1, 12) for 12-hour clock and (0, 23)
 for 24-hour clock
 @param hoursStr a string
 @param use24HourClock should validity be checked against 24-hour clock
 */
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

/**
 @return true iff amOrPm is AM/PM
 @param amOrPm a string
 */
+ (BOOL) amPmStringValid:(NSString *) amOrPm {
  return [LjsDateHelper canonicalAmWithString:amOrPm] ||
  [LjsDateHelper canonicalPmWithString:amOrPm];
}

/**
 checks to see if timeString has correct length (number of characters) for
 either a `H:mm a` string for 12-hour clocks and `HH:mm` for 24-hour clocks.
 
 handles the (annoying) case there a 24-hour time string contains AM/PM.

 @param timeString a string
 @param a24Clock should use a 24-hour clock if YES, 12-hour otherwise
 @return true iff the time string has a valid length for a 12-hour or 24-hour
 clock
 */
+ (BOOL) timeStringHasCorrectLength:(NSString *) timeString using24HourClock:(BOOL) a24Clock {
  BOOL result;
  if (a24Clock == YES) {
    result = (timeString != nil && ([timeString length] > 3 && [timeString length] < 11));
  } else {
    result = (timeString != nil && ([timeString length] > 6 && [timeString length] < 11));
  }
  return result;
}

/**
 checks to see if timeString has correct components i.e. hours, minutes and 
 optionally AM/PM
 
 @param timeString a time string
 @return true iff timeString can be parsed into hours, minutes and 
 optionally AM/PM
 */
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
    
/**
 checks to see if timeString has correct components i.e. hours, minutes, and
 optionally AM/PM
 
 @param timeString a string
 @return true iff timeString can be parsed into hours, minutes, and optionally
 AM/PM
 */
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

/**
 checks to see if timeString has correct components i.e. hours, minutes, and
 optionally AM/PM
 
 @param timeString a string
 @param use24HourClock should validity be checked against 24-hour clock
 @return true iff timeString can be parsed into hours, minutes, and optionally
 AM/PM
 */
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

/**
 @return true if amPmTime is valid 12-hour format 
 @param amPmTime a string
 */
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


/**
 @return true if a24hourTime is valid 24-hour format
 @param a24hourTime string
 */

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

/**
 parses timeString and creates a dictionary of components with the following keys:

 - LjsDateHelper12HoursStringKey
 - LjsDateHelper24HoursStringKey
 - LjsDateHelperMinutesStringKey
 - LjsDateHelperAmPmKey
 - LjsDateHelper12HoursNumberKey
 - LjsDateHelper24HoursNumberKey
 - LjsDateHelperMinutesNumberKey
 
 this method is a wrapper around `componentsWith24HourTimeString:` and
 `componentsWithAmPmTimeString:`
 
 @param timeString a string
 @return a dictionary of time components or nil if components can be parsed
 from timeString
 */
+ (NSDictionary *) componentsWithTimeString:(NSString *) timeString {
  NSDictionary *result = nil;
  if ([LjsDateHelper isValidAmPmTime:timeString]) {
    result = [LjsDateHelper componentsWithAmPmTimeString:timeString]; 
  } else if ([LjsDateHelper isValid24HourTime:timeString]) {
    result = [LjsDateHelper componentsWith24HourTimeString:timeString];
  }
  return result;
}


/**
 parses twentyFourHourTime and creates a dictionary of components with the 
 following keys:
 
 - LjsDateHelper12HoursStringKey
 - LjsDateHelper24HoursStringKey
 - LjsDateHelperMinutesStringKey
 - LjsDateHelperAmPmKey
 - LjsDateHelper12HoursNumberKey
 - LjsDateHelper24HoursNumberKey
 - LjsDateHelperMinutesNumberKey
 

 consider calling `componentsWithTimeString:` instead
 
 @param twentyFourHourTime a string
 @return a dictionary of time components or nil if components can be parsed
 from twentyFourHourTime
 */
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


/**
 parses amPmTime and creates a dictionary of components with the 
 following keys:
 
 - LjsDateHelper12HoursStringKey
 - LjsDateHelper24HoursStringKey
 - LjsDateHelperMinutesStringKey
 - LjsDateHelperAmPmKey
 - LjsDateHelper12HoursNumberKey
 - LjsDateHelper24HoursNumberKey
 - LjsDateHelperMinutesNumberKey
 
 
 consider calling `componentsWithTimeString:` instead
 
 @param amPmTime a string
 @return a dictionary of time components or nil if components can be parsed
 from amPmTime
 */
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


/**
 uses the `componentsWithAmPmTimeString:` to parse the amPmTime and attempts
 to parse a `H:mm a` string from the returned components.
 
 @param amPmTime a string
 @return a string with `H:mm a` format or nil if amPmTime cannot be parsed
 */
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


/**
 uses the `componentsWithAmPmTimeString:` to parse the date and attempts
 to parse a `H:mm a` string from the returned components.
 
 @param date a date
 @return a string with `H:mm a` format or nil if date cannot be parsed
 */
+ (NSString *) amPmTimeWithDate:(NSDate *) date {
  NSString *result = nil;
  if (date != nil) {
    NSDateFormatter *formatter = [LjsDateHelper hoursMinutesAmPmFormatter];
    return [formatter stringFromDate:date];
  }
  return result;
}

/**
 attempts to convert a 24-hour time string to a 12-hour time string
 @param twentyFourHourTime a string
 @return a 24-hour time string in 12-hour format
 */
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


/**
 @return a date formatter for `H:mm a` format
 */
+ (NSDateFormatter *) hoursMinutesAmPmFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  
  [formatter setDateFormat:@"H:mm a"];
  return formatter;
}

/**
 @return a date formatter for `ccc MMM d HH:mm a` or Wed Sep 7 1:30 PM
 */
+ (NSDateFormatter *) briefDateAndTimeFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"ccc MMM d HH:mm a"];
  return formatter;
}

/**
 @return a date formatter for `H:mm:ss`
 */
+ (NSDateFormatter *) hoursMinutesSecondsDateFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:LjsHoursMinutesSecondsDateFormat];
  [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  return formatter;
}

/**
 @return a date formatter for `H:mm:ss:SSS`
 */
+ (NSDateFormatter *) millisecondsFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:LjsHoursMinutesSecondsMillisDateFormat];
  [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  return formatter;
}

/**
 @return a date formatter for `yyyy-MM-dd HH:mm:ss`
 */
+ (NSDateFormatter *) isoDateFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:LjsISO8601_DateFormat];
  //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  return formatter;  
}

/**
 @return a date formatter for `yyyy-MM-dd HH:mm:ss.SSS`
 */
+ (NSDateFormatter *) isoDateWithMillisFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:LjsISO8601_DateFormatWithMillis];
  //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  return formatter;  
}

+ (NSDateFormatter *) isoDateWithMillisAnd_GMT_Formatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:LjsISO8601_DateFormatWithMillis];
  NSCalendar *calendar = [NSCalendar gregorianCalendar];
  NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:0];
  calendar.timeZone = tz;
  formatter.calendar = calendar;
  formatter.timeZone = tz;
  return formatter;  
}



/**
 @return a date formatter for `yyyy_MM_dd_HH_mm`
 */
+ (NSDateFormatter *) orderedDateFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:LjsOrderedDateFormat];
  return formatter;  
}

/**
 @return a date formatter for `yyyy_MM_dd_HH_mm.SSS`
 */
+ (NSDateFormatter *) orderedDateFormatterWithMillis {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:LjsOrderedDateFormatWithMillis];
  return formatter;  
}


/** 
 @return a string representation of the date created by the interval - the date 
 formatter is `yyyy-MM-dd HH:mm:ss.SSS`
 @param interval a time inteval
 @warning not test extensively
 */
+ (NSString *) stringWithTimeInterval:(NSTimeInterval) interval {
  NSDateFormatter *formatter = [LjsDateHelper isoDateWithMillisFormatter];
  NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
  NSString *result = [formatter stringFromDate:date];
  formatter = nil;
  return result;
}


/** 
 @return a string representation of the date created by the interval
 @param interval a time inteval
 @param formatter a date formatter that will be used to generate the the string
 @warning not test extensively
 */
+ (NSString *) stringWithTimeInterval:(NSTimeInterval)interval 
                            formatter:(NSDateFormatter *) formatter {
  NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
  NSString *result = [formatter stringFromDate:date];
  return result;
}


/**
 @return a locale based on en_US_POSIX which uses a 12-hour clock
 */
+ (NSLocale *) twelveHourLocale {
  return [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]; 
}

/**
 @return a locale based on en_GB which uses a 24-hour clock
 */
+ (NSLocale *) twentyFourHourLocale {
  return [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
}

/*
 http://stackoverflow.com/questions/8037897/how-to-get-a-week-number-from-nsdate-consistently-in-all-ios-versions
 */
+ (NSUInteger) weekOfYearWithDate:(NSDate *)aDate {
  // indicates something is amiss
  NSUInteger result = 0;
  
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  // iOS 5 and 10.7
  [calendar setMinimumDaysInFirstWeek:4];
  // monday
  [calendar setFirstWeekday:2];
  
  NSUInteger flags;
  NSDateComponents *components = [[NSDateComponents alloc] init];
  // iOS 5.0 and 10.7 - strangely weekOfYear did not work here
  if ([components respondsToSelector:@selector(setWeekOfYear:)]) {
       flags = NSWeekOfYearCalendarUnit;
  } else {
    flags = NSWeekCalendarUnit;
  }
  
  components = [calendar components:flags fromDate:aDate];
  // iOS 5.0 and 10.7
  if ([components respondsToSelector:@selector(weekOfYear)]) {
    result = (NSUInteger) [components weekOfYear];
  } else {
    result = (NSUInteger) [components week];
  }  
  return result;
}


+ (NSArray *) datesWithWeek:(NSUInteger) aWeek ofYear:(NSUInteger) aYear {
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  // iOS 5 and 10.7
  [calendar setMinimumDaysInFirstWeek:4];
  // monday
  [calendar setFirstWeekday:2];
  
  NSDate *date = [[NSDate date] midnight];
  LjsDateComps comps = [date dateComponentsWithCalendar:calendar];
  
  NSUInteger flags = NSYearForWeekOfYearCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
  comps.year = aYear;
  NSDate *ref = [NSDate dateWithComponents:comps calendar:calendar];
  NSDateComponents *dc = [calendar components:flags fromDate:ref];
  if ([dc respondsToSelector:@selector(setWeekOfYear:)]) {  
    [dc setWeekOfYear:aWeek];
  } else {
    [dc setWeek:aWeek];
  }
  
  [dc setWeekday:2];
  NSDate *start = [calendar dateFromComponents:dc];
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:7];
  for (NSUInteger index = 0; index < 7; index++) {
    [result nappend:[start dateByAddingDays:index withCalendar:calendar]];
  }
    
  return [NSArray arrayWithArray:result];
}


+ (NSUInteger) weekOfMonthWithDate:(NSDate *) aDate {
  // indicates something is amiss
  NSUInteger result = 0;

  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [[NSDateComponents alloc] init];

  if ([components respondsToSelector:@selector(setWeekOfMonth:)]) {
    // setting this causes Sun Jan 1 2012 to return 0
    // [calendar setMinimumDaysInFirstWeek:4];
    // Monday
    [calendar setFirstWeekday:2];
    components = [calendar components:NSWeekOfMonthCalendarUnit fromDate:aDate];
    result = (NSUInteger) [components weekOfMonth];
    
  } else {
    [calendar setFirstWeekday:2];
    [calendar setMinimumDaysInFirstWeek:1];
 
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:calendar];
    [formatter setLocale:[LjsLocaleUtils localeWithMondayAsFirstDayOfWeek]];
    [formatter setDateFormat:@"W"];
    NSString *dateStr = [formatter stringFromDate:aDate];
    result = (NSUInteger) [dateStr integerValue];
  }
  return result;
}

+ (NSUInteger) dayOfMonthWithDate:(NSDate *) aDate {
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSUInteger dayOfMonth = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                              inUnit:NSMonthCalendarUnit
                                             forDate:aDate];
  return dayOfMonth;
}

+ (NSDate *) lastDayOfMonthWithDate:(NSDate *) aDate {
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  [calendar setTimeZone:[NSTimeZone localTimeZone]];
  NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit 
  | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  
	NSDateComponents *components;
  components = [calendar components:flags fromDate:aDate];
	NSInteger month = [components month] + 1;
  [components setMonth:month];
  [components setDay:0];
  [components setHour:0];
  [components setMinute:0];
  [components setSecond:0];
  NSDate *result = [calendar dateFromComponents:components];
  result = [result dateByAddingTimeInterval:LjsSecondsInDay - 1];
  return result;
}

+ (NSDate *) firstDayOfMonthWithDate:(NSDate *) aDate {
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  [calendar setTimeZone:[NSTimeZone localTimeZone]];
  NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
  | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  
	NSDateComponents *components;
  components = [calendar components:flags fromDate:aDate];
  [components setDay:1];
  [components setHour:0];
  [components setMinute:0];
  [components setSecond:0];
  NSDate *result = [calendar dateFromComponents:components];
  return result;

}


+ (NSString *) audioTimeStringWithInterval:(NSTimeInterval) aInterval {
  NSUInteger hours = aInterval / LjsSecondsInHour;
  NSTimeInterval minutesLessHours = aInterval - (hours * LjsSecondsInHour);
  NSUInteger minutes = minutesLessHours / LjsSecondsInMinute;
  NSTimeInterval secondsLessMinutes = minutesLessHours - (minutes * LjsSecondsInMinute);
  NSUInteger seconds = secondsLessMinutes / 1;
  NSString *result = @"";
  if (hours > 0) {
    result = [result stringByAppendingFormat:@"%d:%02d:", hours, minutes];
  } else {
    result = [result stringByAppendingFormat:@"%d:", minutes];
  } 
  result = [result stringByAppendingFormat:@"%02d", seconds];
  return result;
}


#pragma mark DEAD SEA


@end
