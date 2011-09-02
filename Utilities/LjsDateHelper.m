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
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsDateHelper

// Disallow the normal default initializer for instances
- (id)init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

//- (id) init {
//  self = [super init];
//  if (self) {
//    // Initialization code here.
//  }
//  return self;
//}

- (void) dealloc {
  [super dealloc];
}

- (NSString *) description {
  NSString *result = [NSString stringWithFormat:@"<#%@ >", [self class]];
  return result;
}

+ (NSTimeInterval) intervalBetweenPast:(NSDate *) past future:(NSDate *) future {
  NSTimeInterval result = [future timeIntervalSinceDate:past];
  return result;
}

+ (NSTimeInterval) timeIntervalWithHmsString:(NSString *) timeString {
  DDLogWarn(@"needs unit test");
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


@end
