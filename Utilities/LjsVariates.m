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

//  Variates.m
//  iJson
//
//  Created by Joshua Moody on 12/27/10.

#import "LjsVariates.h"
#import "Lumberjack.h"
#include <stdlib.h>

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static const NSString *_alphanumeric = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
static const int _max_index = 26 + 26 + 10 - 1;

static const float ARC4RANDOM_MAX = 0x100000000;


@implementation LjsVariates


+ (double) randomDouble {
  // why floorf?
  double result = (double) arc4random() / ARC4RANDOM_MAX;
  return result;
}

+ (NSDecimalNumber *) randomDecimalDouble {
  double random = [LjsVariates randomDouble];
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:random] decimalValue]];
}

+ (double) randomDoubleWithMin:(double) min max:(double) max {
  double result;
  if (max <= min) {
    result = max;
  } else {
    
    result = ((max - min) * [LjsVariates randomDouble]) + min;
  }
  return result;
}


+ (NSDecimalNumber *) randomDecimalDoubleWithMin:(NSDecimalNumber *) min
                                             max:(NSDecimalNumber *) max {
  double random = [LjsVariates randomDoubleWithMin:[min doubleValue]
                                               max:[max doubleValue]];
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:random] decimalValue]];
}

+ (int) randomInteger {
  return arc4random();
}

+ (NSDecimalNumber *) randomDecimalInteger {
  int random = [LjsVariates randomInteger];
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:random] decimalValue]];
}

+ (int) randomIntegerWithMin:(int) min max:(int) max {
  
  int result;
  if (max <= min) {
    result = max;
  } else {
    result = ((max - min + 1) * [LjsVariates randomDouble]) + min;
    while (result > max) {
      DDLogInfo(@"regenerating integer because RNG algorithm produced max + 1 - this is expected.");
      result = ((max - min + 1) * [LjsVariates randomDouble]) + min;
    }
  }
  return result;
}

+ (NSDecimalNumber *) randomDecimalIntegerWithMin:(NSDecimalNumber *) min
                                              max:(NSDecimalNumber *) max {

  int random = [LjsVariates randomIntegerWithMin:[min intValue]
                                             max:[max intValue]];
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:random] decimalValue]];  
}

+ (NSArray *) sampleWithReplacement:(NSArray *) array number:(int) number {
  NSMutableArray *sampled = [NSMutableArray new];
  int loopVar;
  int randomIndex;
  int maxArrayIndex = [array count] - 1;
  for (loopVar = 0; loopVar < number; loopVar++) {
    randomIndex = [LjsVariates randomIntegerWithMin:0 max:maxArrayIndex];
    [sampled addObject:[array objectAtIndex:randomIndex]];
  }

  NSArray *result = [NSArray arrayWithArray:sampled];
  [sampled release];
  return result;
}

+ (NSArray *) sampleWithoutReplacement:(NSArray *) array number:(int) number {
  NSMutableArray *sampled = [NSMutableArray new];
  NSArray *result;
  int arraySize = [array count];
  if (arraySize < number) {
    // not possible to generate enough samples with out replacement
    result = nil;
  } else {
    int loopVar;
    int randomIndex;
    int maxArrayIndex = arraySize - 1;
    NSMutableArray *indexes = [NSMutableArray arrayWithCapacity:number];
    
    for (loopVar = 0; loopVar < number; loopVar++) {
      
      randomIndex = [LjsVariates randomIntegerWithMin:0 max:maxArrayIndex];
      //DDLogVerbose(@"randomIndex == %d", randomIndex);
      while ([LjsVariates _arrayOfNSNumbers:indexes containsInt:randomIndex]) {
        //DDLogVerbose(@"randomIndex %d was found in %@ - regenerating", randomIndex, indexes);
        randomIndex = [LjsVariates randomIntegerWithMin:0 max:maxArrayIndex];
      }
      //DDLogVerbose(@"adding randomIndex %d to indexes - %@", randomIndex, indexes);
      [indexes addObject:[NSNumber numberWithInt:randomIndex]];
    }
    
    for (NSNumber *index in indexes) {
      id object = [array objectAtIndex:[index intValue]];
      [sampled addObject:object];
    }
    result = [NSArray arrayWithArray:sampled];
  }
  return result;
}

+ (BOOL) _arrayOfNSNumbers:(NSArray *) array containsInt:(int) number {
  
  for (NSNumber *num in array) {
    if ([num intValue] == number) {
      return YES;
    }
  }
  return NO;
}

+ (NSString *) randomStringWithLength:(int) length {
  
  NSString *result = @"";
  int random;
  
  for(int finger = 0; finger < length; finger++) {
    random = [LjsVariates randomIntegerWithMin:0 max:_max_index];
    char character = [_alphanumeric characterAtIndex:random];
    result = [result stringByAppendingFormat:@"%c", character];
  }
  return result;
}


@end
