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

// cribbed from here
// the problem with devin's code is that it is super buggy
//
//  NSDateAdditions.m
//  Created by Devin Ross on 7/28/09.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "NSDate+LjsAdditions.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSInteger NSDateLjsAdditionsComponentFlags = 
(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | 
NSSecondCalendarUnit);

@implementation NSDate (NSDate_LjsAdditions)

- (NSString *) descriptionWithCurrentLocale {
  return [self descriptionWithLocale:[NSLocale currentLocale]];
}

+ (NSDate *) yesterday {
  LjsDateComps comps = [[NSDate date] dateComponents];
  comps.day--;
  return [NSDate dateWithComponents:comps];
}

+ (NSDate *) tomorrow {
  LjsDateComps comps = [[NSDate date] dateComponents];
  comps.day++;
  return [NSDate dateWithComponents:comps];
}

- (BOOL) isToday {
  return [self isSameDay:[NSDate date]];
}

- (BOOL) isSameDay:(NSDate *) aDate {
  LjsDateComps selfComps = [self dateComponents];
  LjsDateComps aDateComps = [aDate dateComponents];
  
  return 
  selfComps.year == aDateComps.year &&
  selfComps.month == aDateComps.month &&
  selfComps.day == aDateComps.day;
}

- (NSUInteger) daysBetweenDate:(NSDate*) aDate {
  return [self daysBetweenDate:aDate calendar:[NSCalendar currentCalendar]];
}

- (NSUInteger) daysBetweenDate:(NSDate *) aDate calendar:(NSCalendar *) aCalendar {
  NSDate *fromDate, *toDate = nil;
  
  [aCalendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                interval:NULL forDate:self];
  [aCalendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                interval:NULL forDate:aDate];
  
  NSDateComponents *difference = [aCalendar components:NSDayCalendarUnit
                                              fromDate:fromDate toDate:toDate options:0];
  return abs(difference.day);
}

- (NSDate *) dateByAddingDays:(NSInteger) aNumberOfDays {
  return [self dateByAddingDays:aNumberOfDays
                   withTimeZone:[NSTimeZone localTimeZone]
                       calendar:[NSCalendar currentCalendar]];
}

- (NSDate *) dateByAddingDays:(NSInteger)aNumberOfDays
                 withTimeZone:(NSTimeZone *) aTimeZone {
  return [self dateByAddingDays:aNumberOfDays
                   withTimeZone:aTimeZone
                       calendar:[NSCalendar currentCalendar]];
}

- (NSDate *) dateByAddingDays:(NSInteger) aNumberOfDays 
                 withCalendar:(NSCalendar *) aCalendar {
  return [self dateByAddingDays:aNumberOfDays
                   withTimeZone:aCalendar.timeZone
                       calendar:aCalendar];
}

- (NSDate *) dateByAddingDays:(NSInteger)aNumberOfDays
                 withTimeZone:(NSTimeZone *) aTimeZone
                     calendar:(NSCalendar *) aCalendar {
  NSDate *result;
  NSTimeZone *oldTimeZone = [aCalendar timeZone];
  aCalendar.timeZone = aTimeZone;
  
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  comps.day = aNumberOfDays;
  result =[aCalendar dateByAddingComponents:comps toDate:self options:0];
  aCalendar.timeZone = oldTimeZone;
  return result;
}


- (LjsDateComps) dateComponents {
  return [self dateComponentsWithTimeZone:[NSTimeZone localTimeZone]
                                 calendar:[NSCalendar currentCalendar]];
}

- (LjsDateComps) dateComponentsWithTimeZone:(NSTimeZone *) aTimeZone {
  return [self dateComponentsWithTimeZone:aTimeZone
                                 calendar:[NSCalendar currentCalendar]];
}

- (LjsDateComps) dateComponentsWithCalendar:(NSCalendar *) aCalendar {
  return [self dateComponentsWithTimeZone:[aCalendar timeZone]
                                 calendar:aCalendar];
}

- (LjsDateComps) dateComponentsWithTimeZone:(NSTimeZone *) aTimeZone 
                                   calendar:(NSCalendar *) aCalendar {
  LjsDateComps result;
  NSTimeZone *oldTimeZone = aCalendar.timeZone;
  aCalendar.timeZone = aTimeZone;
  NSInteger flags = NSDateLjsAdditionsComponentFlags;
  NSDateComponents *comps = [aCalendar components:flags fromDate:self];
  result.day = comps.day;
  result.month = comps.month;
  result.year = comps.year;
  result.hour = comps.hour;
  result.minute = comps.minute;
  result.second = comps.second;
  result.weekday = comps.weekday;
  
  aCalendar.timeZone = oldTimeZone;
  return result;
}


- (NSInteger) dayOfYear {
  return [self dayOfYearWithTimeZone:[NSTimeZone localTimeZone]
                            calendar:[NSCalendar currentCalendar]];
}

- (NSInteger) dayOfYearWithTimeZone:(NSTimeZone *) aTimeZone {
  return [self dayOfYearWithTimeZone:aTimeZone
                            calendar:[NSCalendar currentCalendar]];
}

- (NSInteger) dayOfYearWithCalendar:(NSCalendar *) aCalendar {
  return [self dayOfYearWithTimeZone:[aCalendar timeZone]
                            calendar:aCalendar];
}

- (NSInteger) dayOfYearWithTimeZone:(NSTimeZone *) aTimeZone
                           calendar:(NSCalendar *) aCalendar {
  NSTimeZone *oldTimeZone = [aCalendar timeZone];
  [aCalendar setTimeZone:aTimeZone];
  NSInteger dayOfYear =  [aCalendar ordinalityOfUnit:NSDayCalendarUnit
                                              inUnit:NSYearCalendarUnit 
                                             forDate:self];
  [aCalendar setTimeZone:oldTimeZone];
  return dayOfYear;
}


+ (NSDate *) dateWithComponents:(LjsDateComps) aComponents {
  return [self dateWithComponents:aComponents
                         timeZone:[NSTimeZone localTimeZone]
                         calendar:[NSCalendar currentCalendar]];
}

+ (NSDate *) dateWithComponents:(LjsDateComps) aComponents
                       timeZone:(NSTimeZone *) aTimeZone {
  return [self dateWithComponents:aComponents
                         timeZone:aTimeZone
                         calendar:[NSCalendar currentCalendar]];
}

+ (NSDate *) dateWithComponents:(LjsDateComps) aComponents
                       calendar:(NSCalendar *) aCalendar {
  return [self dateWithComponents:aComponents
                         timeZone:[aCalendar timeZone]
                         calendar:aCalendar];
}


+ (NSDate *) dateWithComponents:(LjsDateComps) aComponents
                       timeZone:(NSTimeZone *) aTimeZone
                       calendar:(NSCalendar *) aCalendar {
  NSTimeZone *oldTimeZone = aCalendar.timeZone;
  aCalendar.timeZone = aTimeZone;
  
  NSInteger flags = NSDateLjsAdditionsComponentFlags;
  NSDate *date = [NSDate date];
  NSDateComponents *comps = [aCalendar components:flags fromDate:date];
  comps.day = aComponents.day;
  comps.month = aComponents.month;
  comps.year = aComponents.year;
  comps.hour = aComponents.hour;
  comps.minute = aComponents.minute;
  comps.second = aComponents.second;
  // declining to set weekday
  //comps.weekday = aComponents.weekday;
  comps.timeZone = aTimeZone;
  comps.calendar = aCalendar;
  
  aCalendar.timeZone = oldTimeZone;
  return [aCalendar dateFromComponents:comps];
}

+ (NSDate *) dateWithYear:(NSUInteger) aYear
                    month:(NSUInteger) aMonth
                      day:(NSUInteger) aDay
                     hour:(NSUInteger) aHour
                   minute:(NSUInteger) aMinute
                   second:(NSUInteger) aSecond {
  return [self dateWithYear:aYear month:aMonth 
                        day:aDay hour:aHour
                     minute:aMonth second:aSecond
                   timeZone:[NSTimeZone localTimeZone]
                   calendar:[NSCalendar currentCalendar]];
}

+ (NSDate *) dateWithYear:(NSUInteger) aYear
                    month:(NSUInteger) aMonth
                      day:(NSUInteger) aDay
                     hour:(NSUInteger) aHour
                   minute:(NSUInteger) aMinute
                   second:(NSUInteger) aSecond
                 timeZone:(NSTimeZone *) aTimeZone {
  return [self dateWithYear:aYear month:aMonth 
                        day:aDay hour:aHour
                     minute:aMonth second:aSecond
                   timeZone:aTimeZone
                   calendar:[NSCalendar currentCalendar]];
}

+ (NSDate *) dateWithYear:(NSUInteger) aYear
                    month:(NSUInteger) aMonth
                      day:(NSUInteger) aDay
                     hour:(NSUInteger) aHour
                   minute:(NSUInteger) aMinute
                   second:(NSUInteger) aSecond
                 calendar:(NSCalendar *) aCalendar {
  return [self dateWithYear:aYear month:aMonth 
                        day:aDay hour:aHour
                     minute:aMonth second:aSecond
                   timeZone:[aCalendar timeZone]
                   calendar:[NSCalendar currentCalendar]];
}


+ (NSDate *) dateWithYear:(NSUInteger) aYear
                    month:(NSUInteger) aMonth
                      day:(NSUInteger) aDay
                     hour:(NSUInteger) aHour
                   minute:(NSUInteger) aMinute
                   second:(NSUInteger) aSecond
                 timeZone:(NSTimeZone *) aTimeZone
                 calendar:(NSCalendar *) aCalendar {
  NSDate *date = [NSDate date];
  LjsDateComps comps = [date dateComponents];
  comps.year = aYear;
  comps.month = aMonth;
  comps.day = aDay;
  comps.hour = aHour;
  comps.minute = aMinute;
  comps.second = aSecond;
  
  date = [self dateWithComponents:comps timeZone:aTimeZone calendar:aCalendar];
  return date;
}


@end
