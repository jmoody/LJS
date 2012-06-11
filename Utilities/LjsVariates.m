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
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsVariates.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


static const NSString *_alphanumeric = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
static const NSUInteger _max_index = 26 + 26 + 10 - 1;

static const float ARC4RANDOM_MAX = 0x100000000;
static double const LjsE = 2.71828;

@implementation LjsVariates

+ (NSUInteger) factorial:(NSUInteger) n {
  return [LjsVariates _factorialHelperWithN:n accumulator:1];
}

+ (NSUInteger) _factorialHelperWithN:(NSUInteger) n
                         accumulator:(NSUInteger) accumulator {
  return n < 1 ? accumulator : [LjsVariates _factorialHelperWithN:n - 1 accumulator:accumulator * n];
}


+ (BOOL) flip {
  return [LjsVariates randomIntegerWithMin:0 max:1];
}

+ (BOOL) flipWithProbilityOfYes:(double) aProbability {
  return [LjsVariates randomDoubleWithMin:0.0 max:1.0] <= aProbability;
}



/*
 e is the base of the natural logarithm (e = 2.71828...)
 k is the number of occurrences of an event — the probability of which is given by the function
 k! is the factorial of k
 λ is a positive real number, equal to the expected number of occurrences during the given interval. For instance, if the events occur on average 4 times per minute, and one is interested in the probability of an event occurring k times in a 10 minute interval, one would use a Poisson distribution as the model with λ = 10×4 = 40.
 As a function of k, this is the probability mass function. The Poisson distribution can be derived as a limiting case of the binomial distribution.
 */

+ (double) possionWithK:(NSUInteger) aK
                 lambda:(double) aLambda {
  NSUInteger denomiator = [LjsVariates factorial:aK];
  double lambdaToK = pow(aLambda, aK);
  double eToNegLambda = pow(LjsE, -1.0 * aLambda);
  double numerator = lambdaToK * eToNegLambda;
  return (numerator/denomiator) * 1.0;
}



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

+ (NSInteger) randomInteger {
  return arc4random();
}

+ (NSDecimalNumber *) randomDecimalInteger {
  NSInteger random = [LjsVariates randomInteger];
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInteger:random] decimalValue]];
}

+ (NSInteger) randomIntegerWithMin:(NSInteger) min max:(NSInteger) max {
  
  NSInteger result;
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
  
  NSInteger random = [LjsVariates randomIntegerWithMin:[min intValue]
                                                   max:[max intValue]];
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInteger:random] decimalValue]];  
}

+ (NSArray *) sampleWithReplacement:(NSArray *) array number:(NSUInteger) number {
  NSMutableArray *sampled = [NSMutableArray new];
  NSInteger loopVar;
  NSInteger randomIndex;
  NSInteger maxArrayIndex = [array count] - 1;
  for (loopVar = 0; loopVar < number; loopVar++) {
    randomIndex = [LjsVariates randomIntegerWithMin:0 max:maxArrayIndex];
    [sampled addObject:[array objectAtIndex:randomIndex]];
  }
  
  NSArray *result = [NSArray arrayWithArray:sampled];
  return result;
}

+ (NSArray *) sampleWithoutReplacement:(NSArray *) array number:(NSUInteger) number {
  NSMutableArray *sampled = [NSMutableArray arrayWithArray:array];
  NSArray *result;
  NSInteger arraySize = [array count];
  if (arraySize < number) {
    // not possible to generate enough samples with out replacement
    result = nil;
  } else {
    NSUInteger remainingCount, index, randomIndex;
    
    for (index = 0; index < arraySize; index++) {
      remainingCount = arraySize - index;
      randomIndex = ([LjsVariates randomInteger] % remainingCount) + index;
      [sampled exchangeObjectAtIndex:index withObjectAtIndex:randomIndex];
    }
    result = [sampled subarrayWithRange:NSMakeRange(0, number)];
  }
  return result;
}

+ (id) randomElement:(NSArray *) array {
  if (array == nil || [array count] == 0) {
    return nil;
  }
  
  NSUInteger count = [array count];
  if (count == 1) {
    return [array objectAtIndex:0];
  }
  
  NSInteger max = count - 1;
  NSInteger index = [LjsVariates randomIntegerWithMin:0 max:max];
  return [array objectAtIndex:index];
}

+ (NSArray *) shuffle:(NSArray *) array {
  NSUInteger count = [array count];
  NSArray *shuffled = [self sampleWithoutReplacement:array number:count];
  return shuffled;
}


+ (NSString *) randomStringWithLength:(NSUInteger) length {
  
  NSString *result = @"";
  NSInteger random;
  
  for(NSInteger finger = 0; finger < length; finger++) {
    random = [LjsVariates randomIntegerWithMin:0 max:_max_index];
    char character = [_alphanumeric characterAtIndex:random];
    result = [result stringByAppendingFormat:@"%c", character];
  }
  return result;
}


+ (NSString *) randomAsciiWithLengthMin:(NSUInteger) aMin
                              lenghtMax:(NSUInteger) aMax {
  NSUInteger count = [LjsVariates randomIntegerWithMin:aMin max:aMax];
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
  for (NSUInteger index = 0; index < count; index++) {
    NSUInteger code = [LjsVariates randomIntegerWithMin:32 max:126];
    [array addObject:[NSString stringWithFormat:@"%c", code]];
  }
  return [array componentsJoinedByString:@""];
}

+ (NSDate *) randomDateBetweenStart:(NSDate *) aStart end:(NSDate *) aEnd {
  if ([aStart comesBeforeDate:aEnd] == NO) {
    DDLogError(@"end date must be after start date:\nstart: %@\n  end:%@",
               aStart, aEnd);
    return nil;
  }
  
  NSUInteger daysBtw = [aStart daysBetweenDate:aEnd];
  LjsDateComps fromComps = [aStart dateComponents];
  
  fromComps.hour = [LjsVariates randomIntegerWithMin:fromComps.hour max:23];
  fromComps.minute = [LjsVariates randomIntegerWithMin:0 max:59];
  fromComps.second = [LjsVariates randomIntegerWithMin:0 max:59];
  
  NSDate *date = [NSDate dateWithComponents:fromComps];
  
  date = [date dateByAddingDays:[LjsVariates randomIntegerWithMin:0 max:daysBtw]];
  
  if ([date compare:aEnd] != NSOrderedAscending) {
    LjsDateComps endComps = [aEnd dateComponents];
    endComps.hour = [LjsVariates randomIntegerWithMin:0 max:endComps.hour - 1];
    endComps.minute = [LjsVariates randomIntegerWithMin:0 max:endComps.minute];
    endComps.second = [LjsVariates randomIntegerWithMin:0 max:endComps.second];
    
    date = [NSDate dateWithComponents:endComps];
  }
  
  if ([date compare:aEnd] != NSOrderedAscending) {
    DDLogDebug(@"start: %@", [aStart descriptionWithCurrentLocale]);
    DDLogDebug(@"date:  %@", [date descriptionWithCurrentLocale]);
    DDLogDebug(@"end:   %@", [aEnd descriptionWithCurrentLocale]);
  }
  return date;
}


@end
