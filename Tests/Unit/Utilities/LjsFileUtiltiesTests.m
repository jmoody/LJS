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

#import "LjsTestCase.h"
#import "LjsFileUtilities.h"

@interface LjsFileUtiltiesTests : LjsTestCase {}
@end

@implementation LjsFileUtiltiesTests

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  [super setUpClass];
  // Run at start of all tests in the class
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

//- (void)testGHLog {
//  GHTestLog(@"GH test logging is working");
//}

#if !TARGET_OS_IPHONE

- (void) test_applicationFilesDirectory {
  NSString *result;
  result = [LjsFileUtilities findApplicationSupportDirectoryForUserp:YES];
  GHTestLog(@"application files directory: %@", result);
}

#endif


- (void) test_findCoreDataLibraryPath {
  NSString *result;
  result = [LjsFileUtilities findCoreDataStoreDirectoryForUserp:YES];
  GHTestLog(@"core data library path = %@", result);
}

//- (void) test_findLibraryPreferencesPath {
//  NSString *actual = [LjsFileUtilities findPreferencesPathForUserp:NO];
//}

- (void) test_read_lines_from_file_success {
  NSError *error = nil;
  NSBundle *main = [NSBundle mainBundle];
  NSString *path = [main pathForResource:@"readlines-test" ofType:@"txt"];
  NSArray *actual = [LjsFileUtilities readLinesFromFile:path error:&error];
  GHAssertNotNil(actual, @"array should not be nil");
  GHAssertNil(error, @"error should be nil");
  GHAssertEquals((NSUInteger)[actual count], (NSUInteger)3, 
                 @"should be exactly three items in the list: %@", 
                 actual);
}

- (void) test_read_lines_from_file_does_not_exist {
  NSError *error = nil;
  NSBundle *main = [NSBundle mainBundle];
  NSString *path = [main pathForResource:@"file-does-not-exist" ofType:@"txt"];
  NSArray *actual = [LjsFileUtilities readLinesFromFile:path error:&error];
  GHAssertNil(actual, @"array should be nil");
  GHAssertNotNil(error, @"error should not be nil");
}

- (void) test_read_lines_from_file_cannot_read_data {
  // ugh - need to swizzle class method
//  NSError *error = nil;
//  NSBundle *main = [NSBundle mainBundle];
//  NSString *path = [main pathForResource:@"readlines-test" ofType:@"txt"];
//  
//  
//  id mock = [OCMockObject mockForClass:[NSData class]];
//  id foo = [[[mock expect] andReturn:nil] initWithContentsOfFile:[OCMArg any]
//                                                         options:NSDataReadingUncached
//                                                           error:&error];
//  GHTestLog(@"foo = %@", foo);
//  NSArray *actual = [LjsFileUtilities readLinesFromFile:path error:&error];
//  GHAssertNil(actual, @"should return nil if file cannot be read");
//  GHTestLog(@"error = %@", error);
//  [mock verify];
  
}

@end
