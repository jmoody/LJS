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

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "NSDecimalNumber+LjsAdditions.h"
#import "Lumberjack.h"
#import "LjsDn.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation NSDecimalNumber (NSDecimalNumber_LjsAdditions)


/** @name Task Section */
- (BOOL) e:(NSDecimalNumber *) other {
  return [LjsDn dn:self e:other];
}

- (BOOL) lt:(NSDecimalNumber *) other {
  return [LjsDn dn:self lt:other];
}

- (BOOL) gt:(NSDecimalNumber *) other {
  return [LjsDn dn:self gt:other];
}

- (BOOL) lte:(NSDecimalNumber *) other {
  return [LjsDn dn:self lte:other];
}

- (BOOL) gte:(NSDecimalNumber *) other {
  return [LjsDn dn:self gte:other];
}

- (BOOL) isOnIntervalWithMin:(NSDecimalNumber *) aMin
                         max:(NSDecimalNumber *) aMax {
  return [LjsDn dn:self isOnMin:aMin max:aMax];
}

- (NSDecimalNumber *) dnByRoundingWithHandler:(NSDecimalNumberHandler *) aHandler {
  return [LjsDn round:self withHandler:aHandler];
}

- (NSDecimalNumber *) dnByRoundingWithScale:(NSUInteger) aScale {
  NSDecimalNumberHandler *handler = [LjsDn statisticsHandlerWithRoundMode:NSRoundPlain
                                                                    scale:aScale];
  return [self dnByRoundingWithHandler:handler];
}

- (NSDecimalNumber *) dnByRoundingAsLocation {
  NSDecimalNumberHandler *handler = [LjsDn locationHandlerWithRoundMode:NSRoundPlain
                                                                  scale:8];
  return [self dnByRoundingWithHandler:handler];
}



@end
