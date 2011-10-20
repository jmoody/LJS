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

//  VariatesTest.m
//  ProjectTemplate
//
//  Created by Joshua Moody on 12/27/10.

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


#import "LjsVariates.h"
#import "math.h"

@interface LjsVariatesTests : GHTestCase {}
@end

@implementation LjsVariatesTests

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void)setUpClass {
  // Run at start of all tests in the class
}

- (void)tearDownClass {
  // Run at end of all tests in the class
}

- (void)setUp {
  // Run before each test method
}

- (void)tearDown {
  // Run after each test method
}  

- (void) testRandomDouble {
  int passes = 1000000;
  int index = 0;
  for (index = 0; index < passes; index++) {
    double result = [LjsVariates randomDouble];
    GHAssertTrue(result >= 0, @"expected result >= 0, but found %f after %d runs", result, index);
    GHAssertTrue(result <= 1.0, @"expected result <= 1.0, but found %f after %d runs", result, index);
  }
}

- (void) testRandomDoubleWithRange {
  double max = 10.0;
  double min = 1.0;
  int passes = 10000000;
  int index = 0;
  double maxGenerated = min;
  double minGenerated = max;
  double result;
  for (index = 0; index < passes; index++) {
    result = [LjsVariates randomDoubleWithMin:min max:max];
    GHAssertTrue(result >= min, @"expected result >= %f, but found %f after %i runs", min, result, index);
    GHAssertTrue(result <= max, @"expected result <= %f, but found %f after %i runs", max, result, index);
    
    if (result > maxGenerated) {
      maxGenerated = result;
    }
    
    if (result < minGenerated) {
      minGenerated = result;
    }
  }
//  GHAssertEqualsWithAccuracy(minGenerated, min, 0.0001, @"expected that minGenerated would be == %f, but found %f over %i runs", min, minGenerated, passes);
//  GHAssertEqualsWithAccuracy(maxGenerated, max, 0.0001, @"expected that maxGenerated would be == %f, but found %f over %i runs", max, maxGenerated, passes);
}


- (void) testRandomInteger {
//  int max = pow(2,32) - 1;
//  int min = -max;
  int passes = 1000;
  int index = 0;
  for (index = 0; index < passes; index++) {
    [LjsVariates randomInteger];
//    GHAssertTrue(result >= min, @"expected result >= %qi, but found %qi after %i runs", min, result, index);
//    GHAssertTrue(result <= max, @"expected result <= %qi, but found %qi after %i runs", max, result, index);
  }
  
}

- (void) testRandomIntegerWithRange {
  int max = 10;
  int min = 1;
  int passes = 1000;
  int index = 0;
  int maxGenerated = min;
  int minGenerated = max;
  int result;
  for (index = 0; index < passes; index++) {
    result = [LjsVariates randomIntegerWithMin:min max:max];
    GHAssertTrue(result >= min, @"expected result >= %qi, but found %qi after %i runs", min, result, index);
    GHAssertTrue(result <= max, @"expected result <= %qi, but found %qi after %i runs", max, result, index);
  
    if (result > maxGenerated) {
      maxGenerated = result;
    }
    
    if (result < minGenerated) {
      minGenerated = result;
    }
  }
  GHAssertTrue(minGenerated == min, @"expected that minGenerated would be == %i, but found %i over %i runs", min, minGenerated, passes);
  GHAssertTrue(maxGenerated == max, @"expected that maxGenerated would be == %i, but found %i over %i runs", max, maxGenerated, passes);
}


- (void) testSampleWithReplacement {
  // + (NSArray *) sampleWithReplacement:(NSArray *) array number:(int) number;
  NSMutableArray *toSample = [NSMutableArray new];
  
  for (int index = 0; index < 50; index++) {
    [toSample addObject:[NSNumber numberWithInt:index]];
  }
  
  NSArray *sampled = [LjsVariates sampleWithReplacement:toSample number:10];
  GHAssertNotNil(sampled, nil);
  GHAssertEquals([[NSNumber numberWithInt:[sampled count]] intValue],
                 [[NSNumber numberWithInt:10] intValue], nil);
  // GHTestLog(@"%@", sampled);
  
  sampled = [LjsVariates sampleWithReplacement:toSample number:100];
  GHAssertNotNil(sampled, nil);
  GHAssertEquals([[NSNumber numberWithInt:[sampled count]] intValue],
                 [[NSNumber numberWithInt:100] intValue], nil);
  // GHTestLog(@"%@", sampled);
  [toSample release];
}


- (void) testSampleWithoutReplacement {
  NSMutableArray *toSample = [NSMutableArray new];
  
  for (int index = 0; index < 10; index++) {
    [toSample addObject:[NSNumber numberWithInt:index]];
  }
  
  NSArray *sampled = [LjsVariates sampleWithoutReplacement:toSample number:11];
  GHAssertNil(sampled, nil);
  
  sampled = [LjsVariates sampleWithoutReplacement:toSample number:2];
  GHAssertNotNil(sampled, nil);
  GHAssertEquals([[NSNumber numberWithInt:[sampled count]] intValue],
                 [[NSNumber numberWithInt:2] intValue], nil);

  
  sampled = [LjsVariates sampleWithoutReplacement:toSample number:10];
  GHAssertNotNil(sampled, nil);
  GHAssertEquals([[NSNumber numberWithInt:[sampled count]] intValue],
                 [[NSNumber numberWithInt:10] intValue], nil);
  
  
  
}


- (void) test_ArrayOfNSNumberContainsInt {
  // + (BOOL) _arrayOfNSNumbers:(NSArray *) array containsInt:(int) number;
  NSArray *indexes = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],
                      [NSNumber numberWithInt:1], [NSNumber numberWithInt:2],
                      [NSNumber numberWithInt:3], nil];
  GHAssertTrue([LjsVariates _arrayOfNSNumbers:indexes containsInt:0], nil);
  GHAssertTrue([LjsVariates _arrayOfNSNumbers:indexes containsInt:1], nil);
  GHAssertTrue([LjsVariates _arrayOfNSNumbers:indexes containsInt:2], nil);
  GHAssertTrue([LjsVariates _arrayOfNSNumbers:indexes containsInt:3], nil);
  GHAssertFalse([LjsVariates _arrayOfNSNumbers:indexes containsInt:4], nil);
}


- (void) testRandomStringWithLength {
  NSString *random = [LjsVariates randomStringWithLength:5];
  GHAssertEquals([[NSNumber numberWithInt:[random length]] intValue], 
                 [[NSNumber numberWithInt:5] intValue], nil);
}

@end
