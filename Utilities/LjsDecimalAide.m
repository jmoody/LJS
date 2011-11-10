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

#import "LjsDecimalAide.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


@implementation LjsDecimalAide

// Disallow the normal default initializer for instances
- (id)init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (void) dealloc {
  [super dealloc];
}

- (NSString *) description {
  NSString *result = [NSString stringWithFormat:@"<#%@ >", [self class]];
  return result;
}

+ (NSDecimalNumber *) dnWithInt:(NSUInteger) aInt {
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInteger:aInt] decimalValue]];
}

+ (NSDecimalNumber *) dnWithDouble:(double) aDouble {
  return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:aDouble] decimalValue]];
}

+ (NSDecimalNumber *) dnWithString:(NSString *) aString {
  return [NSDecimalNumber decimalNumberWithString:aString];
}

+ (BOOL) dn:(NSDecimalNumber *) a lt:(NSDecimalNumber *) b {
  return [a compare:b] == NSOrderedAscending;
}

+ (BOOL) dn:(NSDecimalNumber *) a gt:(NSDecimalNumber *) b {
  return [a compare:b] == NSOrderedDescending;
}

+ (BOOL) dn:(NSDecimalNumber *) a lte:(NSDecimalNumber *) b {
  return [a compare:b] != NSOrderedDescending;
}

+ (BOOL) dn:(NSDecimalNumber *) a gte:(NSDecimalNumber *) b {
  return [a compare:b] != NSOrderedAscending;
}

+ (BOOL) dn:(NSDecimalNumber *) a 
    isOnMin:(NSDecimalNumber *) min
        max:(NSDecimalNumber *) max {
  return [LjsDecimalAide dn:a gte:min] && [LjsDecimalAide dn:a lte:max];
}


+ (NSDecimalNumber *) round:(NSDecimalNumber *) number withHandler:(NSDecimalNumberHandler *) handler {
  return [number decimalNumberByMultiplyingBy:[NSDecimalNumber one]
                                 withBehavior:handler];
}

@end
