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
 
 tapku.com  http://github.com/devinross/tapkulibrary
 
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

#import <Foundation/Foundation.h>

/**
 NSDate on NSDate_LjsAdditions category.
 */
@interface NSDate (NSDate_LjsAdditions)

struct LjsDateComps {
	NSInteger day;
	NSInteger month;
	NSInteger year;
	NSInteger weekday;
	NSInteger minute;
	NSInteger hour;
	NSInteger second;
};

typedef struct LjsDateComps LjsDateComps;

/** @name Task Section */
- (NSString *) descriptionWithCurrentLocale;
- (NSString *) descriptionWithISO8601;

+ (NSDate *) LjsDateNotFound;
- (BOOL) isNotFound;

+ (NSDate *) yesterday;
+ (NSDate *) tomorrow;
- (BOOL) isToday;


- (NSDate *) firstOfMonth;
- (NSDate *) nextMonth;
- (NSDate *) previousMonth;

- (BOOL) isSameAsDate:(NSDate *) aDate;
- (BOOL) comesBeforeDate:(NSDate *) aDate;
- (BOOL) comesAfterDate:(NSDate *) aDate;
- (BOOL) isSameDay:(NSDate *) aDate;

- (BOOL) isWithinSeconds:(NSTimeInterval) aSeconds
                      ofDate:(NSDate *) aDate;

- (BOOL) isAlmostNow;

/*
 ui date pickers often want intervals of 5,15, or 30
 setting the date of the picker will do this automatically if the interval
 is set.  however, sometimes the other ui elements need to be synced to the
 date on the picker, but you dont want to make a change to the model until
 you have to.
 */
- (NSDate *) dateByAddingMinutesUntilInterval:(NSUInteger) aInterval
                                        error:(NSError **) aError;

- (NSUInteger) daysBetweenDate:(NSDate *) aDate;
- (NSUInteger) daysBetweenDate:(NSDate *) aDate 
                      calendar:(NSCalendar *) aCalendar;

- (NSDate *) dateByAddingDays:(NSInteger) aNumberOfDays;
- (NSDate *) dateByAddingDays:(NSInteger)aNumberOfDays
                 withTimeZone:(NSTimeZone *) aTimeZone;
- (NSDate *) dateByAddingDays:(NSInteger) aNumberOfDays 
                 withCalendar:(NSCalendar *) aCalendar;
- (NSDate *) dateByAddingDays:(NSInteger)aNumberOfDays
                 withTimeZone:(NSTimeZone *) aTimeZone
                     calendar:(NSCalendar *) aCalendar;


- (LjsDateComps) dateComponents;
- (LjsDateComps) dateComponentsWithTimeZone:(NSTimeZone *) aTimeZone;
- (LjsDateComps) dateComponentsWithTimeZone:(NSTimeZone *) aTimeZone 
                                   calendar:(NSCalendar *) aCalendar;
- (LjsDateComps) dateComponentsWithCalendar:(NSCalendar *) aCalendar;

- (NSInteger) dayOfYear;
- (NSInteger) dayOfYearWithTimeZone:(NSTimeZone *) aTimeZone;
- (NSInteger) dayOfYearWithCalendar:(NSCalendar *) aCalendar;
- (NSInteger) dayOfYearWithTimeZone:(NSTimeZone *) aTimeZone
                           calendar:(NSCalendar *) aCalendar;


+ (NSDate *) dateWithComponents:(LjsDateComps) aComponents;
+ (NSDate *) dateWithComponents:(LjsDateComps) aComponents
                       timeZone:(NSTimeZone *) aTimeZone;
+ (NSDate *) dateWithComponents:(LjsDateComps) aComponents
                       timeZone:(NSTimeZone *) aTimeZone
                       calendar:(NSCalendar *) aCalendar;
+ (NSDate *) dateWithComponents:(LjsDateComps) aComponents
                       calendar:(NSCalendar *) aCalendar;

+ (NSDate *) dateWithYear:(NSUInteger) aYear
                    month:(NSUInteger) aMonth
                      day:(NSUInteger) aDay
                     hour:(NSUInteger) aHour
                   minute:(NSUInteger) aMinute
                   second:(NSUInteger) aSecond;

+ (NSDate *) dateWithYear:(NSUInteger) aYear
                    month:(NSUInteger) aMonth
                      day:(NSUInteger) aDay
                     hour:(NSUInteger) aHour
                   minute:(NSUInteger) aMinute
                   second:(NSUInteger) aSecond
                 timeZone:(NSTimeZone *) aTimeZone;

+ (NSDate *) dateWithYear:(NSUInteger) aYear
                    month:(NSUInteger) aMonth
                      day:(NSUInteger) aDay
                     hour:(NSUInteger) aHour
                   minute:(NSUInteger) aMinute
                   second:(NSUInteger) aSecond
                 calendar:(NSCalendar *) aCalendar;


+ (NSDate *) dateWithYear:(NSUInteger) aYear
                    month:(NSUInteger) aMonth
                      day:(NSUInteger) aDay
                     hour:(NSUInteger) aHour
                   minute:(NSUInteger) aMinute
                   second:(NSUInteger) aSecond
                 timeZone:(NSTimeZone *) aTimeZone
                 calendar:(NSCalendar *) aCalendar;

- (NSDate *) midnight;
- (NSDate *) midnightWithTimeZone:(NSTimeZone *) aTimeZone;
- (NSDate *) midnightWithCalendar:(NSCalendar *) aCalendar;
- (NSDate *) midnightWithTimeZone:(NSTimeZone *)aTimeZone
                         calendar:(NSCalendar *) aCalendar;


- (NSDate *) lastSecond;
- (NSDate *) lastSecondWithTimeZone:(NSTimeZone *) aTimeZone;
- (NSDate *) lastSecondWithCalendar:(NSCalendar *) aCalendar;
- (NSDate *) lastSecondWithTimeZone:(NSTimeZone *)aTimeZone
                           calendar:(NSCalendar *) aCalendar;

+ (NSDate *) randomDateBetweenStart:(NSDate *) aStart end:(NSDate *) aEnd;


@end
