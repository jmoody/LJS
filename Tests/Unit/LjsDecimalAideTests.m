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


#import "LjsDecimalAide.h"
#import "LjsTestCase.h"

@interface LjsDecimalAideTests : LjsTestCase {}

@property (nonatomic, strong) NSDecimalNumber *zero;
@property (nonatomic, strong) NSDecimalNumber *one;
@property (nonatomic, strong) NSDecimalNumber *minusOne;

@end


@implementation LjsDecimalAideTests

@synthesize zero, one, minusOne;

//- (id) init {
//  self = [super init];
//  if (self) {
//    // Initialization code here.
//  }
//  return self;
//}
//

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  // Run at start of all tests in the class
  self.zero = [NSDecimalNumber zero];
  self.one = [NSDecimalNumber one];
  self.minusOne = [LjsDecimalAide dnWithDouble:-1.0];
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


- (void) test_dne {
  NSDecimalNumber *a;
  NSDecimalNumber *b;
  BOOL actual;
  
  a = zero;
  b = zero;
  actual = [LjsDecimalAide dn:a e:b];
  GHAssertTrue(actual, nil);

  a = zero;
  b = one;
  actual = [LjsDecimalAide dn:a e:b];
  GHAssertFalse(actual, nil);

}
- (void) test_dnLt {

  NSDecimalNumber *a;
  NSDecimalNumber *b;
  BOOL actual;
  
  a = zero;
  b = zero;
  actual = [LjsDecimalAide dn:a lt:b];
  GHAssertFalse(actual, nil);
  
  a = minusOne;
  b = zero;
  actual = [LjsDecimalAide dn:a lt:b];
  GHAssertTrue(actual, nil);

  a = one;
  b = zero;
  actual = [LjsDecimalAide dn:a lt:b];
  GHAssertFalse(actual, nil);
}

- (void) test_dnGt {
  NSDecimalNumber *a;
  NSDecimalNumber *b;
  BOOL actual;
  
  a = zero;
  b = zero;
  actual = [LjsDecimalAide dn:a gt:b];
  GHAssertFalse(actual, nil);
  
  a = minusOne;
  b = zero;
  actual = [LjsDecimalAide dn:a gt:b];
  GHAssertFalse(actual, nil);
  
  a = one;
  b = zero;
  actual = [LjsDecimalAide dn:a gt:b];
  GHAssertTrue(actual, nil);
}

- (void) test_dnLte {
  NSDecimalNumber *a;
  NSDecimalNumber *b;
  BOOL actual;
  
  a = zero;
  b = zero;
  actual = [LjsDecimalAide dn:a lte:b];
  GHAssertTrue(actual, nil);
  
  a = minusOne;
  b = zero;
  actual = [LjsDecimalAide dn:a lte:b];
  GHAssertTrue(actual, nil);
  
  a = one;
  b = zero;
  actual = [LjsDecimalAide dn:a lte:b];
  GHAssertFalse(actual, nil);
}

- (void) test_dnGte {
  NSDecimalNumber *a;
  NSDecimalNumber *b;
  BOOL actual;
  
  a = zero;
  b = zero;
  actual = [LjsDecimalAide dn:a gte:b];
  GHAssertTrue(actual, nil);
  
  a = minusOne;
  b = zero;
  actual = [LjsDecimalAide dn:a gte:b];
  GHAssertFalse(actual, nil);
  
  a = one;
  b = zero;
  actual = [LjsDecimalAide dn:a gte:b];
  GHAssertTrue(actual, nil);
}

- (void) test_dnOnInterval {
  NSDecimalNumber *a, *min, *max;
  BOOL actual;
  
  a = zero;
  min = minusOne;
  max = one;
  actual = [LjsDecimalAide dn:a isOnMin:min max:max];
  GHAssertTrue(actual, nil);
  
  a = minusOne;
  min = minusOne;
  max = one;
  actual = [LjsDecimalAide dn:a isOnMin:min max:max];
  GHAssertTrue(actual, nil);
  
  a = one;
  min = minusOne;
  max = one;
  actual = [LjsDecimalAide dn:a isOnMin:min max:max];
  GHAssertTrue(actual, nil);
  
  a = minusOne;
  min = zero;
  max = one;
  actual = [LjsDecimalAide dn:a isOnMin:min max:max];
  GHAssertFalse(actual, nil);
  
  a = one;
  min = minusOne;
  max = zero;
  actual = [LjsDecimalAide dn:a isOnMin:min max:max];
  GHAssertFalse(actual, nil);

}
@end
