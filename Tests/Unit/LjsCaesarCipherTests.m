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

// a1 is always the RECEIVED value
// a2 is always the EXPECTED value
// GHAssertNoErr(a1, description, ...)
// GHAssertErr(a1, a2, description, ...)
// GHAssertNotNULL(a1, description, ...)
// GHAssertNULL(a1, description, ...)
// GHAssertNotEquals(a1, a2, description, ...)
// GHAssertNotEqualObjects(a1, a2, desc, ...)
// GHAssertOperation(a1, a2, op, description, ...)
// GHAssertGreaterThan(a1, a2, description, ...)
// GHAssertGreaterThanOrEqual(a1, a2, description, ...)
// GHAssertLessThan(a1, a2, description, ...)
// GHAssertLessThanOrEqual(a1, a2, description, ...)
// GHAssertEqualStrings(a1, a2, description, ...)
// GHAssertNotEqualStrings(a1, a2, description, ...)
// GHAssertEqualCStrings(a1, a2, description, ...)
// GHAssertNotEqualCStrings(a1, a2, description, ...)
// GHAssertEqualObjects(a1, a2, description, ...)
// GHAssertEquals(a1, a2, description, ...)
// GHAbsoluteDifference(left,right) (MAX(left,right)-MIN(left,right))
// GHAssertEqualsWithAccuracy(a1, a2, accuracy, description, ...)
// GHFail(description, ...)
// GHAssertNil(a1, description, ...)
// GHAssertNotNil(a1, description, ...)
// GHAssertTrue(expr, description, ...)
// GHAssertTrueNoThrow(expr, description, ...)
// GHAssertFalse(expr, description, ...)
// GHAssertFalseNoThrow(expr, description, ...)
// GHAssertThrows(expr, description, ...)
// GHAssertThrowsSpecific(expr, specificException, description, ...)
// GHAssertThrowsSpecificNamed(expr, specificException, aName, description, ...)
// GHAssertNoThrow(expr, description, ...)
// GHAssertNoThrowSpecific(expr, specificException, description, ...)
// GHAssertNoThrowSpecificNamed(expr, specificException, aName, description, ...)

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsTestCase.h"
#import "NSArray+LjsAdditions.h"
#import "LjsVariates.h"
#import "LjsCaesarCipher.h"

@interface LjsCaesarCipherTests : LjsTestCase {}
@end

@implementation LjsCaesarCipherTests

//- (id) init {
//  self = [super init];
//  if (self) {
//    // Initialization code here.
//  }
//  return self;
//}
//
//- (void) dealloc {
//}

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  // Run at start of all tests in the class
}

- (void) tearDownClass {
  // Run at end of all tests in the class
}

- (void) setUp {
  // Run before each test method
}

- (void) tearDown {
  // Run after each test method
}  


- (void) test_EncodeDecode {

  NSUInteger rotate;
  LjsCaesarCipher *cipher;
  NSString *original, *encoded, *decoded;
  
  rotate = 0;
  cipher = [[LjsCaesarCipher alloc] initWithRotate:rotate];
  original = [LjsVariates randomAsciiWithLengthMin:5 lenghtMax:55];;
  encoded = [cipher stringByEncodingString:original];
  GHAssertEqualStrings(original, encoded, nil);
  decoded = [cipher stringByDecodingString:encoded];
  GHAssertEqualStrings(original, decoded, nil);

  rotate = 95;
  cipher = [[LjsCaesarCipher alloc] initWithRotate:rotate];
  original = [LjsVariates randomAsciiWithLengthMin:5 lenghtMax:55];;
  encoded = [cipher stringByEncodingString:original];
  GHAssertEqualStrings(original, encoded, nil);
  decoded = [cipher stringByDecodingString:encoded];
  GHAssertEqualStrings(original, decoded, nil);
  
  
  for (NSUInteger index = 0; index < 100; index++) {
    rotate = [LjsVariates randomIntegerWithMin:1 max:NSUIntegerMax];
    if (rotate == 0 || rotate == 95) {
      continue;
    } else {
      cipher = [[LjsCaesarCipher alloc] initWithRotate:rotate];
      original = [LjsVariates randomAsciiWithLengthMin:5 lenghtMax:55];;
      encoded = [cipher stringByEncodingString:original];
      GHAssertNotEqualStrings(original, encoded, @"rotate is: %d", rotate);
      
      decoded = [cipher stringByDecodingString:encoded];
      GHAssertEqualStrings(original, decoded, nil);
    }
  }
}



@end
