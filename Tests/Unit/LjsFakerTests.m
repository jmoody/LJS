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
#import "LjsFaker.h"
#import "LjsCategories.h"
#import "LjsFileUtilities.h"

@interface LjsFaker (TEST)


@end

@interface LjsFakerTests : LjsTestCase {}

@property (nonatomic, strong) LjsFaker *faker;
@property (nonatomic, strong) NSFileManager *fm;
@end


@implementation LjsFakerTests
@synthesize faker;
@synthesize fm;

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
  [super setUpClass];
  // Run at start of all tests in the class
  self.faker = [[LjsFaker alloc] init];
}

- (void) tearDownClass {
  // Run at end of all tests in the class
  [super tearDownClass];
}

- (void) setUp {
  [super setUp];
  // Run before each test method
}

- (void) tearDown {
  // Run after each test method
  [super tearDown];
}  

- (void) test_firstName {
  GHAssertNotNil([self.faker firstName], nil);
}

- (void) test_lastName {
  GHAssertNotNil([self.faker lastName], nil);
}

- (void) test_name {
  GHAssertNotNil([self.faker name], nil);
}

- (void) test_companyName {
  GHAssertNotNil([self.faker company], nil);
}

- (void) test_cityName {
  GHAssertNotNil([self.faker city], nil);
}

- (void) test_streetAddress {
  GHAssertNotNil([self.faker streetAddress], nil);
}

- (void) test_state {
  GHAssertNotNil([self.faker state:YES], nil);
  GHAssertNotNil([self.faker state:NO], nil);
}

- (void) test_domainName {
  GHAssertNotNil([self.faker websiteWithHttp:YES escaped:YES], nil);
}

//- (void) test_writeDomainNames {
//  NSArray *array = [LjsFaker domainNamesArray];
//  NSString *dir = [LjsFileUtilities findDocumentDirectoryPath];
//  NSString *filename = @"com.littlejoysoftware.faker.domain-names.plist";
//  NSString *path = [dir stringByAppendingPathComponent:filename];
//  [LjsFileUtilities writeArray:array
//                        toFile:path
//                         error:nil];
//  GHAssertTrue([fm fileExistsAtPath:path], nil);
//}

//- (void) test_writeCensusSurnamesNames {
//  NSArray *array = [LjsFaker lastNamesArray];
//  NSString *dir = [LjsFileUtilities findDocumentDirectoryPath];
//  NSString *filename = @"com.littlejoysoftware.faker.us-census-surnames.plist";
//  NSString *path = [dir stringByAppendingPathComponent:filename];
//  [LjsFileUtilities writeArray:array
//                        toFile:path
//                         error:nil];
//  GHAssertTrue([fm fileExistsAtPath:path], nil);
//
//}


//- (void) test_writeCensusFirstNames {
//  NSArray *array = [LjsFaker firstNamesArray];
//  NSString *dir = [LjsFileUtilities findDocumentDirectoryPath];
//  NSString *filename = @"com.littlejoysoftware.faker.us-census-firstnames.plist";
//  NSString *path = [dir stringByAppendingPathComponent:filename];
//  [LjsFileUtilities writeArray:array
//                        toFile:path
//                         error:nil];
//  GHAssertTrue([fm fileExistsAtPath:path], nil);
//
//}

//- (void)testGHLog {
//  GHTestLog(@"GH test logging is working");
//}

//- (void) test_import {
//  NSFileManager *fm = [NSFileManager defaultManager];
//  NSData *data = [fm contentsAtPath:@"/Users/moody/tmp/FakeNameGenerator.com_cbffb37f.csv"];
//  NSString *string = [[NSString alloc]
//                      initWithData:data encoding:NSUTF8StringEncoding];
//  //    0         1           2         3          4     5    6       7
//  //GivenName,MiddleInitial,Surname,StreetAddress,City,State,ZipCode,Country
//  //   8             9        10              11        12      13
//  //,EmailAddress,Password,TelephoneNumber,Occupation,Company,Domain
//  NSArray *lines = [[[[string componentsSeparatedByString:@"\n"] rest] reverse] rest];
//  NSUInteger capacity = [lines count];
//  NSMutableArray *givenNames = [NSMutableArray arrayWithCapacity:capacity];
//  NSMutableArray *surnames = [NSMutableArray arrayWithCapacity:capacity];
//  NSMutableArray *streetAddress = [NSMutableArray arrayWithCapacity:capacity];
//  NSMutableArray *cities = [NSMutableArray arrayWithCapacity:capacity];
//  NSMutableArray *states = [NSMutableArray arrayWithCapacity:capacity];
//  NSMutableArray *countries = [NSMutableArray arrayWithCapacity:capacity];
//  NSMutableArray *zips = [NSMutableArray arrayWithCapacity:capacity];
//  NSMutableArray *phones = [NSMutableArray arrayWithCapacity:capacity];
//  NSMutableArray *occupations = [NSMutableArray arrayWithCapacity:capacity];
//  NSMutableArray *companies = [NSMutableArray arrayWithCapacity:capacity];
//  
//  NSArray *indexes = [NSArray arrayWithObjects:
//                      @"0",
//                      @"2",
//                      @"3",
//                      @"4",
//                      @"5",
//                      @"6",
//                      @"7",
//                      @"10",
//                      @"11",
//                      @"12"
//                      , nil];
//  NSArray *values = [NSArray arrayWithObjects:
//                     givenNames,
//                     surnames,
//                     streetAddress ,
//                     cities,
//                     states,
//                     zips,
//                     countries,
//                     phones,
//                     occupations,
//                     companies, nil];
//  
//  NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:indexes];
//  for (NSString *line in lines) {
//    NSArray *columns = [line componentsSeparatedByString:@","];
//    for (NSUInteger index = 0; index < [columns count]; index ++) {
//      NSString *key = [NSString stringWithFormat:@"%d", index];
//      NSMutableArray *marray = [dict objectForKey:key];
//      [marray append:[columns nth:index]];
//    }
//  }
//  
//  NSMutableArray *addresses = [NSMutableArray arrayWithCapacity:capacity];
//  for (NSUInteger index = 0; index < capacity ; index++) {
//    NSArray *array = [NSArray arrayWithObjects:
//                      [streetAddress nth:index],
//                      [cities nth:index],
//                      [states nth:index],
//                      [zips nth:index],
//                      [countries nth:index]
//                      , nil];
//    [addresses push:[array componentsJoinedByString:@","]];
//  }
//  
//  NSString *path = @"/Users/moody/tmp";
//  [LjsFileUtilities writeArray:givenNames 
//                        toFile:[path stringByAppendingPathComponent:@"com.littlejoysoftware.faker.given-names.us.plist"]
//                         error:nil];
//
//  [LjsFileUtilities writeArray:surnames
//                        toFile:[path stringByAppendingPathComponent:@"com.littlejoysoftware.faker.surnames-names.us.plist"]
//                         error:nil];
//    
//  [LjsFileUtilities writeArray:cities
//                        toFile:[path stringByAppendingPathComponent:@"com.littlejoysoftware.faker.cities.us.plist"]
//                         error:nil];
//  
//  [LjsFileUtilities writeArray:zips 
//                        toFile:[path stringByAppendingPathComponent:@"com.littlejoysoftware.faker.postal-codes.us.plist"]
//                         error:nil];
//
//  [LjsFileUtilities writeArray:phones
//                        toFile:[path stringByAppendingPathComponent:@"com.littlejoysoftware.faker.phone-numbers.us.plist"]
//                         error:nil];
//  
//  [LjsFileUtilities writeArray:occupations
//                        toFile:[path stringByAppendingPathComponent:@"com.littlejoysoftware.faker.occupations.us.plist"]
//                         error:nil];
//
//  [LjsFileUtilities writeArray:companies
//                        toFile:[path stringByAppendingPathComponent:@"com.littlejoysoftware.faker.companies.us.plist"]
//                         error:nil];
//
//  [LjsFileUtilities writeArray:streetAddress
//                        toFile:[path stringByAppendingPathComponent:@"com.littlejoysoftware.faker.street-addresses.us.plist"]
//                         error:nil];
//  
//  [LjsFileUtilities writeArray:addresses
//                        toFile:[path stringByAppendingPathComponent:@"com.littlejoysoftware.faker.addresses.us.plist"]
//                         error:nil];
//
//}



@end
