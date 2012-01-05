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

#import "LjsDecimalAide.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


/**
 NSDecimalNumber is a powerful tool for handling currency, statistics, and other
 floating point data.  The class name and the methods are, in my opinion, overly
 verbose and tend to clutter code at the worse times - when you are doing 
 sensitive currency calculations or implementing a complex confusing statistical
 algorithm.  And who can remember how to compare two NSDecimalNumbers?  
 
 Enter LjsDecimalAide - which provides methods for creating NSDecimalNumbers
 from various numeric values, logical comparisons and rounding.
 
 */
@implementation LjsDecimalAide

// Disallow the normal default initializer for instances
- (id)init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}


/**
 @return a decimal number with the integer value
 @param aInteger an integer
 */
+ (NSDecimalNumber *) dnWithInteger:(NSUInteger) aInteger {
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInteger:aInteger] decimalValue]];
}

/**
 @return a decimal number with the double value
 @param aDouble a double
 */ 
+ (NSDecimalNumber *) dnWithDouble:(double) aDouble {
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:aDouble] decimalValue]];
}

/**
 @return a decimal number with the string value
 @param aString a string
 */
+ (NSDecimalNumber *) dnWithString:(NSString *) aString {
  return [NSDecimalNumber decimalNumberWithString:aString];
}


/**
 @return true iff a = b
 @param a left hand side
 @param b right hand side
 */
+ (BOOL) dn:(NSDecimalNumber *) a e:(NSDecimalNumber *) b {
  return [a compare:b] == NSOrderedSame;
}

/**
 @return true iff a < b
 @param a left hand side
 @param b right hand side
 */
+ (BOOL) dn:(NSDecimalNumber *) a lt:(NSDecimalNumber *) b {
  return [a compare:b] == NSOrderedAscending;
}

/**
 @return true iff a > b
 @param a left hand side
 @param b right hand side
 */
+ (BOOL) dn:(NSDecimalNumber *) a gt:(NSDecimalNumber *) b {
  return [a compare:b] == NSOrderedDescending;
}

/**
 @return true iff a <= b
 @param a left hand side
 @param b right hand side
 */
+ (BOOL) dn:(NSDecimalNumber *) a lte:(NSDecimalNumber *) b {
  return [a compare:b] != NSOrderedDescending;
}

/**
 @return true iff a >= b
 @param a left hand side
 @param b right hand side
 */
+ (BOOL) dn:(NSDecimalNumber *) a gte:(NSDecimalNumber *) b {
  return [a compare:b] != NSOrderedAscending;
}

/**
 @return return true iff a is on (min, max) 
 @param a number to test
 @param min lower bound of range
 @param max upper bound or range
 */
+ (BOOL) dn:(NSDecimalNumber *) a 
    isOnMin:(NSDecimalNumber *) min
        max:(NSDecimalNumber *) max {
  return [LjsDecimalAide dn:a gte:min] && [LjsDecimalAide dn:a lte:max];
}

/**
 @return rounded decimal number with handler
 @param number the number to round
 @param handler the handler to use
 */
+ (NSDecimalNumber *) round:(NSDecimalNumber *) number withHandler:(NSDecimalNumberHandler *) handler {
  return [number decimalNumberByMultiplyingBy:[NSDecimalNumber one]
                                 withBehavior:handler];
}


/**
 NB: typically you will want to use NSRoundPlain for statistics
 
 @return a handler with mode and scale
 @param aMode a rounding mode
 @param aInteger a scale (precision)
 */
+ (NSDecimalNumberHandler *) statisticsHandlerWithRoundMode:(NSRoundingMode) aMode
                                                      scale:(NSUInteger) aInteger {
  return [NSDecimalNumberHandler 
          decimalNumberHandlerWithRoundingMode:aMode
          scale:aInteger
          raiseOnExactness:NO
          raiseOnOverflow:NO
          raiseOnUnderflow:NO
          raiseOnDivideByZero:YES];
}

/**
 NB: typically you will want to use NSRoundPlain for location
 
 @return a handler with mode and scale
 @param aMode a rounding mode
 @param aInteger a scale (precision)
 */
+ (NSDecimalNumberHandler *) locationHandlerWithRoundMode:(NSRoundingMode) aMode
                                                    scale:(NSUInteger) aInteger {
  return  [NSDecimalNumberHandler 
           decimalNumberHandlerWithRoundingMode:aMode
           scale:aInteger
           raiseOnExactness:NO
           raiseOnOverflow:NO
           raiseOnUnderflow:NO
           raiseOnDivideByZero:YES];
}


@end
