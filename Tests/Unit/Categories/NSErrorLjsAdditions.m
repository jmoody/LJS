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

#import "LjsTestCase.h"

@interface NSErrorLjsAdditions : LjsTestCase {}
@end


@implementation NSErrorLjsAdditions

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

- (void) test_error_domain_with_nil_user_info {
  NSError *error = [NSError errorWithDomain:@"my domain"
                                       code:0
                       localizedDescription:@"localized description" 
                              otherUserInfo:nil];
  GHAssertNotNil(error, @"error should not be nil");
  GHTestLog(@"error = %@", error);
}

- (void) test_error_domain_with_user_info {
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"val 0", @"key 0",
                            @"val 1", @"key 1",
                            @"val 2", @"key 2",
                            nil];
  
  NSError *error = [NSError errorWithDomain:@"my domain"
                                       code:0
                       localizedDescription:@"localized description" 
                              otherUserInfo:userInfo];
  GHAssertNotNil(error, @"error should not be nil");
  GHTestLog(@"error = %@", error);
}

@end
