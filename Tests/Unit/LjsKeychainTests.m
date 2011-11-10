
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

#import "SFHFKeychainUtils.h"
#import "LjsTestCase.h"

@interface LjsKeychainTests : LjsTestCase {}
@end


@implementation LjsKeychainTests

//- (id) init {
//  self = [super init];
//  if (self) {
//    // Initialization code here.
//  }
//  return self;
//}
//
//- (void) dealloc {
//  [super dealloc];
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

- (void) printerror:(NSError *) error {
  NSInteger code = [error code];
  NSString *message = [error localizedDescription];
  GHTestLog(@"%d: %@", code, message);
  NSString *reason = [error localizedFailureReason];
  GHTestLog(@"reason = %@", reason);
  NSString *recovery = [error localizedRecoverySuggestion];
  GHTestLog(@"recovery = %@", recovery);
  NSArray *options = [error localizedRecoveryOptions];
  GHTestLog(@"options = %@", options);
  NSDictionary *userInfo = [error userInfo];
  GHTestLog(@"userInfo = %@", userInfo);
}

- (void) test_keychain {
  NSString *name, *password, *domain, *fetcehedPwd;
  NSError *error;
  
  error = nil;
  name = @"inform test username";
  password = @"inform test password";
  domain = @"com.littlejoysoftware.LJS Keychain Tests Domain";
  
  [SFHFKeychainUtils storeUsername:name
                       andPassword:password
                    forServiceName:domain updateExisting:NO error:&error];
  
  if (error != nil) {
    [self printerror:error];
  } else {
    GHTestLog(@"saved %@/%@ in %@", name, password, domain);
  }
  
  error = nil;
  name = @"inform test username";
  password = @"inform test password";
  domain = @"com.littlejoysoftware.LJS Keychain Tests Domain";
  
  [SFHFKeychainUtils storeUsername:name
                       andPassword:password
                    forServiceName:domain updateExisting:YES error:&error];
  
  if (error != nil) {
    [self printerror:error];
  } else {
    GHTestLog(@"updating keychain with %@/%@ in %@", name, password, domain);
  }
  
  
  error = nil;
  name = @"inform test username";
  password = @"inform test password";
  domain = @"com.littlejoysoftware.LJS Keychain Tests Domain";
  
  [SFHFKeychainUtils storeUsername:name
                       andPassword:password
                    forServiceName:domain updateExisting:NO error:&error];
  
  if (error != nil) {
    [self printerror:error];
  } else {
    GHTestLog(@"updating keychain with %@/%@ in %@", name, password, domain);
  }

  
  error = nil;
  name = nil;
  password = @"inform test password";
  domain = @"com.littlejoysoftware.LJS Keychain Tests Domain";
  
  [SFHFKeychainUtils storeUsername:name
                       andPassword:password
                    forServiceName:domain updateExisting:NO error:&error];
  
  
  if (error != nil) {
    [self printerror:error];
  } else {
    GHTestLog(@"saved %@/%@ in %@", name, password, domain);
  }
  
  error = nil;
  name = @"inform test username";
  password = @"inform test password";
  domain = @"com.littlejoysoftware.LJS Keychain Tests Domain";

  fetcehedPwd = [SFHFKeychainUtils getPasswordForUsername:name andServiceName:domain error:&error];
  
  if (error != nil) {
    [self printerror:error];
  } else {
    GHTestLog(@"fetched \"%@\" for %@ in %@", fetcehedPwd, name, domain);
  }

  error = nil;
  name = @"inform test username";
  password = @"inform test password";
  domain = @"com.littlejoysoftware.LJS Keychain Tests Domain";
  [SFHFKeychainUtils deleteItemForUsername:name andServiceName:domain error:&error];
  
  if (error != nil) {
    [self printerror:error];
  } else {
    GHTestLog(@"deleted password for %@ in %@", fetcehedPwd, name, domain);
  }

  error = nil;
  name = @"inform test username";
  password = @"inform test password";
  domain = @"com.littlejoysoftware.LJS Keychain Tests Domain";
  fetcehedPwd = [SFHFKeychainUtils getPasswordForUsername:name andServiceName:domain error:&error];
  
  if (error != nil) {
    [self printerror:error];
  } else {
    GHTestLog(@"attempted to fetch pwd for %@ in %@ - expecting nil, got: %@", name, domain, fetcehedPwd);
  }


}



@end
