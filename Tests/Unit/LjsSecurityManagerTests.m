
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
#import "LjsKeychainManager.h"
#import "SFHFKeychainUtils.h"


static NSString *LjsSecurityManagerTestsUsernameDefaultsKey = @"com.littlejoysoftware.ljs LjsSecurityManagerTests UserName Defaults Key TEST";

static NSString *LjsSecurityManagerTestsUseKeychainDefaultsKey = @"com.littlejoysoftware.ljs LjsSecurityManagerTests Use Keychain Defaults Key TEST";

static NSString *LjsSecurityManagerTestsKeychainServiceName = @"com.littlejoysoftware.ljs LjsSecurityManagerTests.AgChoice TEST";

static NSString *LjsSecurityManagerTestsUsername = @"testuser";

static NSString *LjsSecurityManagerTestsPassword = @"testpass";

@interface LjsSecurityManagerTests : LjsTestCase {}
@end


@implementation LjsSecurityManagerTests

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
  [SFHFKeychainUtils deleteItemForUsername:LjsSecurityManagerTestsUsername andServiceName:LjsSecurityManagerTestsKeychainServiceName error:nil];
  NSUserDefaults *current = [NSUserDefaults standardUserDefaults];
  if ([current objectForKey:LjsSecurityManagerTestsUsernameDefaultsKey] != nil) {
    [current setNilValueForKey:LjsSecurityManagerTestsUsernameDefaultsKey];
  }
  
  if ([current objectForKey:LjsSecurityManagerTestsUseKeychainDefaultsKey] != nil) {
    [current setNilValueForKey:LjsSecurityManagerTestsUseKeychainDefaultsKey];
  }
}  


- (void) test_isValidUserName {
  LjsKeychainManager *manager = [[[LjsKeychainManager alloc] init] autorelease];
  
  GHAssertTrue([manager isValidPassword:LjsSecurityManagerTestsUsername], nil);
  
  GHAssertFalse([manager isValidPassword:nil], nil);
  GHAssertFalse([manager isValidPassword:@""], nil);
}

- (void) test_isValidPassword {
  LjsKeychainManager *manager = [[[LjsKeychainManager alloc] init] autorelease];
  
  GHAssertTrue([manager isValidPassword:LjsSecurityManagerTestsPassword], nil);
  
  GHAssertFalse([manager isValidPassword:nil], nil);
  GHAssertFalse([manager isValidPassword:@""], nil);
}

- (void) test_usernameStoredInDefaults {
  LjsKeychainManager *manager = [[[LjsKeychainManager alloc] init] autorelease];

  //NSString *expected;
  NSString *actual;

  actual = [manager usernameStoredInDefaults];
  
  GHAssertNil(actual, nil);
  
  /*
  //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  id defaultsMock = [OCMockObject mockForClass:[NSUserDefaults class]];
  //id defaultsMock = [OCMockObject partialMockForObject:defaults];
  [[[defaultsMock expect] andReturn:username] objectForKey:AgChoiceUsernameDefaultsKey];
  
  expected = username;
  actual = [manager usernameStoredInDefaults];
  GHAssertEqualStrings(actual, expected, nil);
  */
  
}


@end
