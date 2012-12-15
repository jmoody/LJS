

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
