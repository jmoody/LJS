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

#import "LjsCaesarCipher.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif
@interface LjsCaesarCipher ()

@property (nonatomic, strong) NSDictionary *encode;
@property (nonatomic, strong) NSDictionary *decode;

@end

@implementation LjsCaesarCipher

@synthesize encode, decode;

#pragma mark Memory Management

- (id) initWithRotate:(NSUInteger)aRotate {
  self = [super init];
  if (self) {
    static unsigned short int const LjsCipherAsciiMaximum = 126;
    static unsigned short int const LjsCipherAsciiMinimum = 32;
    NSUInteger rotate = aRotate;
    
    NSMutableDictionary *encodeDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *decodeDict = [NSMutableDictionary dictionary];
    for (unsigned short int index = 32; index <= LjsCipherAsciiMaximum; index++) {
      NSString *key = [NSString stringWithFormat:@"%c", index];
      unsigned short int shift = index + rotate;
      // NSUInteger foo = shift;
      while (shift > LjsCipherAsciiMaximum) {
        shift = LjsCipherAsciiMinimum + (shift - LjsCipherAsciiMaximum) - 1;
      }
      NSString *value = [NSString stringWithFormat:@"%c", shift];
   
      [encodeDict setObject:value forKey:key];
      [decodeDict setObject:key forKey:value];
    }
    self.encode = [NSDictionary dictionaryWithDictionary:encodeDict];
    self.decode = [NSDictionary dictionaryWithDictionary:decodeDict];
    //DDLogDebug(@"encode = %@", self.encode);
    //DDLogDebug(@"decode = %@", self.decode);
  }
  return self;
}

- (NSString *) stringByEncodingString:(NSString *) aString {
  NSUInteger count = [aString length];
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
  for (NSUInteger index = 0; index < count; index ++) {
    unsigned char charAt = [aString characterAtIndex:index];
    NSString *key = [NSString stringWithFormat:@"%c", charAt];
    NSString *encoded = [self.encode objectForKey:key];
    if (encoded == nil) {
      encoded = key;
    }
    [array addObject:encoded];
  }
  return [array componentsJoinedByString:@""];
}

- (NSString *) stringByDecodingString:(NSString *) aString {
  NSUInteger count = [aString length];
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
  for (NSUInteger index = 0; index < count; index ++) {
    unsigned char charAt = [aString characterAtIndex:index];
    NSString *key = [NSString stringWithFormat:@"%c", charAt];
    NSString *decoded = [self.decode objectForKey:key];
    if (decoded == nil) {
      decoded = key;
    }
    [array addObject:decoded];
  }
  return [array componentsJoinedByString:@""];
}


@end
