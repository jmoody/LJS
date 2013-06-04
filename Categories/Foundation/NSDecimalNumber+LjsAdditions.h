// Copyright 2012 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
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


@interface LjsInterval : NSObject

@property (nonatomic, strong) NSDecimalNumber *min;
@property (nonatomic, strong) NSDecimalNumber *max;

- (id) initWithMin:(NSDecimalNumber *) aMin
               max:(NSDecimalNumber *) aMax;
- (BOOL) intervalContains:(NSDecimalNumber *) aNumber;

@end


@interface LjsDn : NSObject

/** @name NSDecimalNumber creation */
+ (NSDecimalNumber *) dnWithInteger:(NSInteger) aInteger;
+ (NSDecimalNumber *) dnWithUInteger:(NSUInteger) aUInteger;
+ (NSDecimalNumber *) dnWithDouble:(double) aDouble;
+ (NSDecimalNumber *) dnWithFloat:(CGFloat) aFloat;
+ (NSDecimalNumber *) dnWithString:(NSString *) aString;
+ (NSDecimalNumber *) dnWithNumber:(NSNumber *) aNumber;
+ (NSDecimalNumber *) nan;
+ (NSDecimalNumber *) one;
+ (NSDecimalNumber *) zero;
+ (NSDecimalNumber *) min;
+ (NSDecimalNumber *) max;

/** @name NSDecimalNumber comparison */
+ (BOOL) dn:(NSDecimalNumber *) a e:(NSDecimalNumber *) b;
+ (BOOL) dn:(NSDecimalNumber *) a lt:(NSDecimalNumber *) b;
+ (BOOL) dn:(NSDecimalNumber *) a gt:(NSDecimalNumber *) b;
+ (BOOL) dn:(NSDecimalNumber *) a lte:(NSDecimalNumber *) b;
+ (BOOL) dn:(NSDecimalNumber *) a gte:(NSDecimalNumber *) b;
+ (BOOL) dn:(NSDecimalNumber *) a 
    isOnMin:(NSDecimalNumber *) min
        max:(NSDecimalNumber *) max;

+ (BOOL) dn:(NSDecimalNumber *) a isOnInterval:(LjsInterval *) aInterval;

/** @name NSDecimalNumber rounding */
+ (NSDecimalNumber *) round:(NSDecimalNumber *) number 
                withHandler:(NSDecimalNumberHandler *) handler;

/** @name common NSDecimalNumberHandler */
+ (NSDecimalNumberHandler *) statisticsHandlerWithRoundMode:(NSRoundingMode) aMode
                                                      scale:(NSUInteger) aInteger;
+ (NSDecimalNumberHandler *) locationHandlerWithRoundMode:(NSRoundingMode) aMode
                                                    scale:(NSUInteger) aInteger;

@end



/**
 NSDecimalNumber on NSDecimalNumber_LjsAdditions category.
 */
@interface NSDecimalNumber (NSDecimalNumber_LjsAdditions)

/** @name Task Section */
- (BOOL) e:(NSDecimalNumber *) other;
- (BOOL) lt:(NSDecimalNumber *) other;
- (BOOL) gt:(NSDecimalNumber *) other;
- (BOOL) lte:(NSDecimalNumber *) other;
- (BOOL) gte:(NSDecimalNumber *) other;
- (BOOL) isOnIntervalWithMin:(NSDecimalNumber *) aMin
                         max:(NSDecimalNumber *) aMax;
- (BOOL) isNan;

- (NSDecimalNumber *) dnByRoundingWithHandler:(NSDecimalNumberHandler *) aHandler;
- (NSDecimalNumber *) dnByRoundingWithScale:(NSUInteger) aScale;
- (NSDecimalNumber *) dnByRoundingAsLocation;


@end
