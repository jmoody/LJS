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


#import <Foundation/Foundation.h>


extern NSString *LjsDateHelperCanonicalAM;
extern NSString *LjsDateHelperCanonicalPM;

extern NSString *LjsDateHelper12HoursStringKey;
extern NSString *LjsDateHelper24HoursStringKey;
extern NSString *LjsDateHelperMinutesStringKey;
extern NSString *LjsDateHelperAmPmKey;
extern NSString *LjsDateHelper12HoursNumberKey;
extern NSString *LjsDateHelper24HoursNumberKey;
extern NSString *LjsDateHelperMinutesNumberKey;

extern NSString *LjsHoursMinutesSecondsDateFormat;
extern NSString *LjsHoursMinutesSecondsMillisDateFormat;

extern NSTimeInterval const LjsSecondsInMinute;
extern NSTimeInterval const LjsSecondsInHour;
extern NSTimeInterval const LjsSecondsInDay;
extern NSTimeInterval const LjsSecondsInWeek;
extern NSTimeInterval const LjsSecondsInTropicalYear;
extern NSTimeInterval const LjsSecondsInYear;

/**
 Date handling is a pain, especially on iOS devices where user settings can 
 override explicit date formatting and locale conventions.  LjsDateHelper 
 wrangles dates into a predictable format.  It also provides methods for
 date comparison and deducing intervals.
 
 @warn It appears that some, if not all all, of the 12-hour and 24-hour
 conversion stuff could be handled by using formatters with their locales
 set appropriately.
 
 */

/*
 appledoc is bailing on this:
 
      NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
      [formatter setLocale:twelveHourLocale];
 
 */

/*
 Have a look at this:
 
 Managing AM and PM Symbols
 – AMSymbol
 – setAMSymbol:
 – PMSymbol
 – setPMSymbol:
 */
@interface LjsDateHelper : NSObject

/** @name Computing Time Intervals */
+ (NSTimeInterval) intervalBetweenPast:(NSDate *) past future:(NSDate *) future;
+ (NSTimeInterval) secondsSinceMidnightWithHHmmss:(NSString *) aHHmmSSString;

/** @name Date Comparison */
+ (BOOL) dateIsFuture:(NSDate *) date;
+ (BOOL) dateIsPast:(NSDate *) date;

/** @name AM and PM Handling */
+ (NSString *) upcaseAndRemovePeroidsFromAmPmString:(NSString *) amOrPm;
+ (BOOL) isCanonicalAmOrPm:(NSString *) amOrPm;
+ (NSString *) canonicalAmWithString:(NSString *) am;
+ (NSString *) canonicalPmWithString:(NSString *) pm;
+ (NSString *) canonicalAmPmWithString:(NSString *) amOrPm;

/** @name Consistency Checking for H:mm a and HH:mm Date Strings*/
+ (BOOL) minutesStringValid:(NSString *) minutesStr;
+ (BOOL) hourStringValid:(NSString *) hoursStr using24HourClock:(BOOL) use24HourClock; 
+ (BOOL) amPmStringValid:(NSString *) amOrPm;
+ (BOOL) timeStringHasCorrectLength:(NSString *) timeString using24HourClock:(BOOL) a24Clock;
+ (BOOL) amPmStringHasCorrectComponents:(NSString *) timeString;
+ (BOOL) twentyFourHourTimeStringHasCorrectComponents:(NSString *) timeString;
+ (BOOL) timeStringHasCorrectComponents:(NSString *) timeString using24HourClock:(BOOL) use24HourClock;
+ (BOOL) isValidAmPmTime:(NSString *) amPmTime;
+ (BOOL) isValid24HourTime:(NSString *) twentyFourHourTime;

/** @name Components for H:mm a and HH:mm Date Strings */
+ (NSDictionary *) componentsWithTimeString:(NSString *) timeString;
+ (NSDictionary *) componentsWith24HourTimeString:(NSString *) twentyFourHourTime;
+ (NSDictionary *) componentsWithAmPmTimeString:(NSString *) amPmTime;

/** @name H:mm a and HH:mm Date Strings Conversions */
+ (NSString *) convert24hourTimeToAmPmTime:(NSString *) twentyFourHourTime;
+ (NSString *) amPmTimeWithTimeString:(NSString *) amPmTime;
+ (NSString *) amPmTimeWithDate:(NSDate *) date;

/** @name Common Date Formatters */
+ (NSDateFormatter *) hoursMinutesAmPmFormatter;
+ (NSDateFormatter *) briefDateAndTimeFormatter;
+ (NSDateFormatter *) hoursMinutesSecondsDateFormatter;
+ (NSDateFormatter *) millisecondsFormatter;
+ (NSDateFormatter *) isoDateFormatter;
+ (NSDateFormatter *) isoDateWithMillisFormatter;
+ (NSDateFormatter *) orderedDateFormatter;
+ (NSDateFormatter *) orderedDateFormatterWithMillis;

/** @name Handy Locales for 12 and 24 hour formats */
+ (NSLocale *) twelveHourLocale;
+ (NSLocale *) twentyFourHourLocale;

/** @name Converting Intervals to Strings */
+ (NSString *) stringWithTimeInterval:(NSTimeInterval) interval;
+ (NSString *) stringWithTimeInterval:(NSTimeInterval)interval 
                            formatter:(NSDateFormatter *) formatter;

+ (NSUInteger) weekOfYearWithDate:(NSDate *) aDate;
+ (NSUInteger) weekOfMonthWithDate:(NSDate *) aDate;
+ (NSUInteger) dayOfMonthWithDate:(NSDate *) aDate;
+ (NSDate *) lastDayOfMonthWithDate:(NSDate *) aDate;
+ (NSDate *) firstDayOfMonthWithDate:(NSDate *) aDate;

+ (NSString *) audioTimeStringWithInterval:(NSTimeInterval) aInterval;



#pragma mark DEAD SEA

//+ (BOOL) shouldUse24HourClock;
//
//+ (NSString *) hourMinutesWithDate:(NSDate *) date;
//
//+ (NSDate *) dateWithHourMinutesString:(NSString *) hoursMinutes;
//+ (NSDate *) dateReplacingHoursMinutesSeconds:(NSString *) twentyFourHourTimeString;


@end
