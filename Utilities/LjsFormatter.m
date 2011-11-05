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

#import "LjsFormatter.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


NSString *HoursMinutesSecondsDateFormat = @"H:mm:ss";
NSString *HoursMinutesSecondsMillisDateFormat = @"H:mm:ss:SSS";
static NSString *ISO8601_DateFormatWithMillis = @"yyyy-MM-dd HH:mm:ss.SSS";
static NSString *ISO8601_DateFormat = @"yyyy-MM-dd HH:mm:ss";
static NSString *OrderedDateFormat = @"yyyy_MM_dd_HH_mm";
static NSString *OrderedDateFormatWithMillis = @"yyyy_MM_dd_HH_mm_SSS";


@implementation LjsFormatter

// Disallow the normal default initializer for instances
//- (id)init {
//  [self doesNotRecognizeSelector:_cmd];
//  return nil;
//}

- (id) init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (NSString *) description {
  NSString *result = [NSString stringWithFormat:@"<#%@ >", [self class]];
  return result;
}

+ (NSString *) stringWithTimeInterval:(NSTimeInterval) interval {
  NSDateFormatter *formatter = [LjsFormatter hoursMinutesSecondsDateFormatter];
  NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
  NSString *result = [formatter stringFromDate:date];
  formatter = nil;
  return result;
}

+ (NSDateFormatter *) hoursMinutesSecondsDateFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:HoursMinutesSecondsDateFormat];
  [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  return [formatter autorelease];
}

+ (NSDateFormatter *) millisecondsFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:HoursMinutesSecondsMillisDateFormat];
  [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  return [formatter autorelease];
}

+ (NSDateFormatter *) isoDateFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:ISO8601_DateFormat];
  //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  return [formatter autorelease];  
}

+ (NSDateFormatter *) isoDateWithMillisFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:ISO8601_DateFormatWithMillis];
  //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  return [formatter autorelease];  
}


+ (NSDateFormatter *) orderedDateFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:OrderedDateFormat];
  return [formatter autorelease];  
}

+ (NSDateFormatter *) orderedDateFormatterWithMillis {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:OrderedDateFormatWithMillis];
  return [formatter autorelease];  
}

+ (NSString *) stringWithTimeInterval:(NSTimeInterval)interval 
                            formatter:(NSDateFormatter *) formatter {
  NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
  NSString *result = [formatter stringFromDate:date];
  return result;
}



@end
