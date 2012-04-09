
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
#import "LjsKeychainManager.h"
#import "LjsTestCase.h"
#import "LjsVariates.h"
#import "Lumberjack.h"
#import <objc/runtime.h>

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface UIView (UIView_TESTING)

- (NSMutableDictionary *)fullDescription;

@end


@implementation UIView (UIView_TESTING)

- (NSMutableDictionary *)fullDescription {
  NSDictionary *frame =
  [NSDictionary dictionaryWithObjectsAndKeys:
   [NSNumber numberWithFloat:self.frame.origin.x], @"x",
   [NSNumber numberWithFloat:self.frame.origin.y], @"y",
   [NSNumber numberWithFloat:self.frame.size.width], @"width",
   [NSNumber numberWithFloat:self.frame.size.height], @"height",
   nil];
  NSMutableDictionary *description =
  [NSMutableDictionary dictionaryWithObjectsAndKeys:
   [NSNumber numberWithInteger:(NSInteger)self], @"address",
   NSStringFromClass([self class]), @"className",
   frame, @"frame",
   [NSNumber numberWithInteger:[self tag]], @"tag",
   [self valueForKeyPath:@"subviews.fullDescription"], @"subviews",
   nil];
  
  if ([self respondsToSelector:@selector(text)])
  {
    [description
     setValue:[self performSelector:@selector(text)]
     forKey:@"text"];
  }
  if ([self respondsToSelector:@selector(title)])
  {
    [description
     setValue:[self performSelector:@selector(title)]
     forKey:@"title"];
  }
  if ([self respondsToSelector:@selector(currentTitle)])
  {
    [description
     setValue:[self performSelector:@selector(currentTitle)]
     forKey:@"currentTitle"];
  }
  
  return description;
}

@end

static NSString *LjsKeychainTestsUsernameDefaultsKey = @"com.littlejoysoftware.Ljs Keychain Manager Tests Username Defaults Key";
static NSString *LjsKeychainTestsDefaultUsername = @"TestUsername";

static NSString *LjsKeychainTestsShouldUseKeychainDefaultsKey = @"com.littlejoysoftware.Ljs Keychain Manager Tests Should Use Keychain Defaults Key";
static NSString *LjsKeychainTestsPasswordKeychainServiceName = @"com.littlejoysoftware.Ljs Keychain Manager Tests Password Keychain Service Name";


static NSString *LjsKeychainTestsDefaultPassword = @"i have got a secret";

@interface LjsKeychainTests : LjsTestCase <UIAlertViewDelegate>

@property (nonatomic, strong) LjsKeychainManager *km;

- (id) nilOrEmptyString;

- (NSString *) swizzledSFHFgetPasswordForUsername:(NSString *) aIgnored0
                                   andServiceName:(NSString *) aIgnored1
                                            error:(NSError **) aError;


@end


@implementation LjsKeychainTests

@synthesize km;
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

- (id) nilOrEmptyString {
  NSString *result;
  if ([LjsVariates flip]) {
    result = nil;
  } else {
    result = @"";
  }
  return result;
}

- (NSString *) swizzledSFHFgetPasswordForUsername:(NSString *) aIgnored0
                                   andServiceName:(NSString *) aIgnored1
                                            error:(NSError **) aError {
  NSError __autoreleasing *error = nil;
  // known analyzer warning - not sure what to do here
  aError = &error;
    
  return LjsKeychainTestsDefaultPassword;
}


- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  // Run at start of all tests in the class
  self.km = [[LjsKeychainManager alloc] init];
}

- (void) tearDownClass {
  // Run at end of all tests in the class
  self.km = nil;
}

- (void) setUp {
  // Run before each test method
}

- (void) tearDown {
  // Run after each test method

  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removeObjectForKey:LjsKeychainTestsUsernameDefaultsKey];
  [defaults removeObjectForKey:LjsKeychainTestsShouldUseKeychainDefaultsKey];
  [defaults synchronize];
  
  NSError *error = nil;
  [SFHFKeychainUtils deleteItemForUsername:LjsKeychainTestsDefaultUsername
                            andServiceName:LjsKeychainTestsPasswordKeychainServiceName
                                     error:&error];
  if (error != nil) {
    DDLogNotice(@"noticed this error but there is nothing to do: %@", error);
  }
  
}  

- (void) test_isValidString {
  NSString *username;
  BOOL actual;

  username = LjsKeychainTestsDefaultUsername;
  actual = [self.km isValidUsername:username];
  GHAssertTrue(actual, nil);

  username = nil;
  actual = [self.km isValidUsername:username];
  GHAssertFalse(actual, nil);

  username = @"";
  actual = [self.km isValidUsername:username];
  GHAssertFalse(actual, nil);
}

- (void) test_usernameStoredInDefaultsForKey {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:LjsKeychainTestsDefaultUsername
               forKey:LjsKeychainTestsUsernameDefaultsKey];
  
  NSString *actual, *expected, *key;
  key = LjsKeychainTestsUsernameDefaultsKey;
  expected = LjsKeychainTestsDefaultUsername;
  actual = [self.km usernameStoredInDefaultsForKey:key];
  GHAssertEqualStrings(actual, expected, nil);

  
  [defaults removeObjectForKey:LjsKeychainTestsUsernameDefaultsKey];
  key = LjsKeychainTestsUsernameDefaultsKey;
  actual = [self.km usernameStoredInDefaultsForKey:key];
  GHAssertNil(actual, nil);
  
  key = [LjsVariates randomStringWithLength:5];
  actual = [self.km usernameStoredInDefaultsForKey:key];
  GHAssertNil(actual, nil);
}

- (void) test_deleteUsernameInDefaultsForKey {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *key;
  NSError *error;
  BOOL actual;
  
  error = nil;
  key = [self nilOrEmptyString];
  actual = [self.km deleteUsernameInDefaultsForKey:key error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
  GHTestLog(@"keychain error = %@", error);
  
  [defaults setObject:LjsKeychainTestsDefaultUsername
               forKey:LjsKeychainTestsUsernameDefaultsKey];
  error = nil;
  key = LjsKeychainTestsUsernameDefaultsKey;
  actual = [self.km deleteUsernameInDefaultsForKey:key error:&error];
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);
  GHAssertNil([defaults objectForKey:key], nil); 
}

- (void) test_setDefaultsUsername {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *key, *username, *fetched;
  NSError *error;
  BOOL actual;
  
  error = nil;
  key = [self nilOrEmptyString];
  username = LjsKeychainTestsDefaultUsername;
  actual = [self.km setDefaultsUsername:username
                                 forKey:key
                                  error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
  GHTestLog(@"keychain error = %@", error);


  error = nil;
  key = LjsKeychainTestsUsernameDefaultsKey;
  username = [self nilOrEmptyString];
  actual = [self.km setDefaultsUsername:username
                                 forKey:key
                                  error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
  GHTestLog(@"keychain error = %@", error);


  error = nil;
  key = LjsKeychainTestsUsernameDefaultsKey;
  username = LjsKeychainTestsDefaultUsername;
  actual = [self.km setDefaultsUsername:username
                                 forKey:key
                                  error:&error];
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);
  fetched = [defaults objectForKey:key];
  GHAssertEqualStrings(username, fetched, nil);
}

- (void) test_shouldUsekeychain  {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *key;
  BOOL actual;
  NSError *error;
  
  error = nil;
  key = [self nilOrEmptyString];
  actual = [self.km shouldUseKeychainWithKey:key error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
  GHTestLog(@"keychain error = %@", error);
  
  error = nil;
  key = LjsKeychainTestsShouldUseKeychainDefaultsKey;
  actual = [self.km shouldUseKeychainWithKey:key error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNil(error, nil);

  key = LjsKeychainTestsShouldUseKeychainDefaultsKey;
  [defaults setBool:YES forKey:key];
  error = nil;
  actual = [self.km shouldUseKeychainWithKey:key error:&error];
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);
  
}

- (void) test_deleteShouldUseKeycahinInDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *key;
  BOOL actual;
  NSError *error;

  error = nil;
  key = [self nilOrEmptyString];
  actual = [self.km deleteUsernameInDefaultsForKey:key error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
  GHTestLog(@"keychain error = %@", error);
  
  error = nil;
  key = LjsKeychainTestsShouldUseKeychainDefaultsKey;
  actual = [self.km deleteUsernameInDefaultsForKey:key error:&error];
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);
  

  error = nil;
  key = LjsKeychainTestsShouldUseKeychainDefaultsKey;
  [defaults setBool:YES forKey:key];
  actual = [self.km deleteUsernameInDefaultsForKey:key error:&error];
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);

  error = nil;
  key = [LjsVariates randomStringWithLength:9];
  actual = [self.km deleteUsernameInDefaultsForKey:key error:&error];
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);
  
}

- (void) test_setDefaultsShouldUseKeychain {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *key;
  BOOL actual;
  NSError *error;
  
  error = nil;
  key = [self nilOrEmptyString];
  actual = [self.km setDefaultsShouldUseKeychain:YES key:key error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
  GHTestLog(@"keychain error = %@", error);
  
  error = nil;
  key = LjsKeychainTestsShouldUseKeychainDefaultsKey;
  actual = [self.km setDefaultsShouldUseKeychain:YES key:key error:&error];
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);
  GHAssertTrue([defaults boolForKey:key], nil);
  
  [defaults removeObjectForKey:key];
  error = nil;
  key = LjsKeychainTestsShouldUseKeychainDefaultsKey;
  actual = [self.km setDefaultsShouldUseKeychain:NO key:key error:&error];
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);
  GHAssertFalse([defaults boolForKey:key], nil);

}


- (void) test_hasKeychainPasswordForUsername {
  NSString *username, *serviceName;
  NSError *error;
  BOOL actual;
  
  error = nil;
  username = [self nilOrEmptyString];
  serviceName = [self nilOrEmptyString];
  actual = [self.km hasKeychainPasswordForUsername:username
                                       serviceName:serviceName
                                             error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
  GHTestLog(@"keychain error = %@", error);
  

  error = nil;
  username = LjsKeychainTestsDefaultUsername;
  serviceName = [self nilOrEmptyString];
  actual = [self.km hasKeychainPasswordForUsername:username
                                       serviceName:serviceName
                                             error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
  GHTestLog(@"keychain error = %@", error);

  error = nil;
  username =  LjsKeychainTestsDefaultUsername;
  serviceName = LjsKeychainTestsPasswordKeychainServiceName;
  actual = [self.km hasKeychainPasswordForUsername:username
                                       serviceName:serviceName
                                             error:&error];
 
  DDLogNotice(@"@joshua - there is a problem here, but I do not know how to fix it yet");
#if !TARGET_OS_IPHONE
  GHAssertTrue(actual, nil);
#else
  GHAssertFalse(actual, nil);
#endif
  GHAssertNil(error, nil);
  

  Method originalMethod = 
  class_getClassMethod([SFHFKeychainUtils class], 
                       @selector(getPasswordForUsername:andServiceName:error:));                         

  Method mockMethod = 
  class_getInstanceMethod([self class], 
                          @selector(swizzledSFHFgetPasswordForUsername:andServiceName:error:));
  method_exchangeImplementations(originalMethod, mockMethod);
  
  error = nil;
  username = @"foo";
  serviceName = @"bar";
  NSString *pwd = [SFHFKeychainUtils getPasswordForUsername:username
                                             andServiceName:serviceName
                                                      error:&error];
  GHAssertEqualStrings(pwd, LjsKeychainTestsDefaultPassword, nil);
  GHAssertNil(error, nil);

  error = nil;
  username =  LjsKeychainTestsDefaultUsername;
  serviceName = LjsKeychainTestsPasswordKeychainServiceName;
  actual = [self.km hasKeychainPasswordForUsername:username
                                       serviceName:serviceName
                                             error:&error];
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);

  method_exchangeImplementations(mockMethod, originalMethod);
}


- (void) test_keychainPasswordForUsernameInDefaults {
  NSString *key, *serviceName, *actual, *expected;
  NSError *error;
  
  error = nil;
  key = [self nilOrEmptyString];
  serviceName = [self nilOrEmptyString];
  actual = [self.km keychainPasswordForUsernameInDefaults:key 
                                              serviceName:serviceName
                                                    error:&error];
  GHAssertNil(actual, nil);
  GHAssertNotNil(error, nil);
  GHTestLog(@"keychain error = %@", error);

  
  error = nil;
  key = LjsKeychainTestsUsernameDefaultsKey;
  serviceName = [self nilOrEmptyString];
  actual = [self.km keychainPasswordForUsernameInDefaults:key 
                                              serviceName:serviceName
                                                    error:&error];
  GHAssertNil(actual, nil);
  GHAssertNotNil(error, nil);
  GHTestLog(@"keychain error = %@", error);
  
  
  error = nil;
  key = LjsKeychainTestsUsernameDefaultsKey;
  serviceName = LjsKeychainTestsPasswordKeychainServiceName;
  actual = [self.km keychainPasswordForUsernameInDefaults:key 
                                              serviceName:serviceName
                                                    error:&error];
  GHAssertNil(actual, nil);
  GHAssertNil(error, nil);


  error = nil;
  key = LjsKeychainTestsUsernameDefaultsKey;
  id mock = [OCMockObject partialMockForObject:self.km];
  [[[mock stub] andReturn:LjsKeychainTestsDefaultUsername] 
   usernameStoredInDefaultsForKey:key];
  
  actual = [mock usernameStoredInDefaultsForKey:key];
  expected = LjsKeychainTestsDefaultUsername;
  GHAssertEqualStrings(actual, expected, nil);
  
  
  Method originalMethod = 
  class_getClassMethod([SFHFKeychainUtils class], 
                       @selector(getPasswordForUsername:andServiceName:error:));                         
  
  Method mockMethod = 
  class_getInstanceMethod([self class], 
                          @selector(swizzledSFHFgetPasswordForUsername:andServiceName:error:));
  method_exchangeImplementations(originalMethod, mockMethod);

  
  error = nil;
  NSString *username = @"foo";
  serviceName = @"bar";
  NSString *pwd = [SFHFKeychainUtils getPasswordForUsername:username
                                             andServiceName:serviceName
                                                      error:&error];
  
  GHAssertEqualStrings(pwd, LjsKeychainTestsDefaultPassword, nil);
  GHAssertNil(error, nil);
  
  serviceName = LjsKeychainTestsPasswordKeychainServiceName;
  actual = [self.km keychainPasswordForUsernameInDefaults:key 
                                              serviceName:serviceName
                                                    error:&error];
  expected = LjsKeychainTestsDefaultPassword;
  GHAssertEqualStrings(actual, expected, nil);
  GHAssertNil(error, nil);

  method_exchangeImplementations(mockMethod, originalMethod);
}

- (void) test_synchronizeKeychainAndDefaults0 {
  NSString *username, *usernameKey, *password, *shouldUseKeychainKey, *serviceName;
  NSError *error = nil;
  BOOL shouldUseKeychain, actual;
  
  username = [self nilOrEmptyString];
  usernameKey = [self nilOrEmptyString];
  password = [self nilOrEmptyString];
  shouldUseKeychainKey = [self nilOrEmptyString];
  serviceName = [self nilOrEmptyString];
  error = nil;
  shouldUseKeychain = NO;
  actual = [self.km synchronizeKeychainAndDefaultsWithUsername:username
                                           usernameDefaultsKey:usernameKey
                                                      password:password
                                  shouldUseKeychainDefaultsKey:shouldUseKeychainKey
                                             shouldUseKeyChain:shouldUseKeychain
                                                   serviceName:serviceName
                                                         error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
}

- (void) test_synchronizeKeychainAndDefaults1 {
  NSString *username, *usernameKey, *password, *shouldUseKeychainKey, *serviceName;
  NSError *error = nil;
  BOOL shouldUseKeychain, actual;
  
  
  
  username = LjsKeychainTestsDefaultUsername;
  usernameKey = [self nilOrEmptyString];
  password = [self nilOrEmptyString];
  shouldUseKeychainKey = [self nilOrEmptyString];
  serviceName = [self nilOrEmptyString];
  error = nil;
  shouldUseKeychain = NO;
  actual = [self.km synchronizeKeychainAndDefaultsWithUsername:username
                                           usernameDefaultsKey:usernameKey
                                                      password:password
                                  shouldUseKeychainDefaultsKey:shouldUseKeychainKey
                                             shouldUseKeyChain:shouldUseKeychain
                                                   serviceName:serviceName
                                                         error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
}

- (void) test_synchronizeKeychainAndDefaults2 {
  NSString *username, *usernameKey, *password, *shouldUseKeychainKey, *serviceName;
  NSError *error = nil;
  BOOL shouldUseKeychain, actual;
  
  
  
  username = LjsKeychainTestsDefaultUsername;
  usernameKey = LjsKeychainTestsUsernameDefaultsKey;
  password = [self nilOrEmptyString];
  shouldUseKeychainKey = [self nilOrEmptyString];
  serviceName = [self nilOrEmptyString];
  error = nil;
  shouldUseKeychain = NO;
  actual = [self.km synchronizeKeychainAndDefaultsWithUsername:username
                                           usernameDefaultsKey:usernameKey
                                                      password:password
                                  shouldUseKeychainDefaultsKey:shouldUseKeychainKey
                                             shouldUseKeyChain:shouldUseKeychain
                                                   serviceName:serviceName
                                                         error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
}

- (void) test_synchronizeKeychainAndDefaults3 {
  NSString *username, *usernameKey, *password, *shouldUseKeychainKey, *serviceName;
  NSError *error = nil;
  BOOL shouldUseKeychain, actual;
  
  username = LjsKeychainTestsDefaultUsername;
  usernameKey = LjsKeychainTestsUsernameDefaultsKey;
  password = LjsKeychainTestsDefaultPassword;
  shouldUseKeychainKey = [self nilOrEmptyString];
  serviceName = [self nilOrEmptyString];
  error = nil;
  shouldUseKeychain = NO;
  actual = [self.km synchronizeKeychainAndDefaultsWithUsername:username
                                           usernameDefaultsKey:usernameKey
                                                      password:password
                                  shouldUseKeychainDefaultsKey:shouldUseKeychainKey
                                             shouldUseKeyChain:shouldUseKeychain
                                                   serviceName:serviceName
                                                         error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
}

- (void) test_synchronizeKeychainAndDefaults4 {
  NSString *username, *usernameKey, *password, *shouldUseKeychainKey, *serviceName;
  NSError *error = nil;
  BOOL shouldUseKeychain, actual;
  
  username = LjsKeychainTestsDefaultUsername;
  usernameKey = LjsKeychainTestsUsernameDefaultsKey;
  password = LjsKeychainTestsDefaultPassword;
  shouldUseKeychainKey = LjsKeychainTestsShouldUseKeychainDefaultsKey;
  serviceName = [self nilOrEmptyString];
  error = nil;
  shouldUseKeychain = NO;
  actual = [self.km synchronizeKeychainAndDefaultsWithUsername:username
                                           usernameDefaultsKey:usernameKey
                                                      password:password
                                  shouldUseKeychainDefaultsKey:shouldUseKeychainKey
                                             shouldUseKeyChain:shouldUseKeychain
                                                   serviceName:serviceName
                                                         error:&error];
  GHAssertFalse(actual, nil);
  GHAssertNotNil(error, nil);
}

- (void) test_synchronizeKeychainAndDefaults5 {
  NSString *username, *usernameKey, *password, *shouldUseKeychainKey, *serviceName;
  NSError *error = nil;
  BOOL shouldUseKeychain, actual;
  
  username = LjsKeychainTestsDefaultUsername;
  usernameKey = LjsKeychainTestsUsernameDefaultsKey;
  password = LjsKeychainTestsDefaultPassword;
  shouldUseKeychainKey = LjsKeychainTestsShouldUseKeychainDefaultsKey;
  serviceName = LjsKeychainTestsPasswordKeychainServiceName;
  error = nil;
  shouldUseKeychain = NO;
  actual = [self.km synchronizeKeychainAndDefaultsWithUsername:username
                                           usernameDefaultsKey:usernameKey
                                                      password:password
                                  shouldUseKeychainDefaultsKey:shouldUseKeychainKey
                                             shouldUseKeyChain:shouldUseKeychain
                                                   serviceName:serviceName
                                                         error:&error];
  GHTestLog(@"synchronize error = %@", error);
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);
}

- (void) test_synchronizeKeychainAndDefaults6 {
  NSString *username, *usernameKey, *password, *shouldUseKeychainKey, *serviceName;
  NSError *error = nil;
  BOOL shouldUseKeychain, actual;
    
  username = LjsKeychainTestsDefaultUsername;
  usernameKey = LjsKeychainTestsUsernameDefaultsKey;
  password = LjsKeychainTestsDefaultPassword;
  shouldUseKeychainKey = LjsKeychainTestsShouldUseKeychainDefaultsKey;
  serviceName = LjsKeychainTestsPasswordKeychainServiceName;
  error = nil;
  shouldUseKeychain = YES;
  actual = [self.km synchronizeKeychainAndDefaultsWithUsername:username
                                           usernameDefaultsKey:usernameKey
                                                      password:password
                                  shouldUseKeychainDefaultsKey:shouldUseKeychainKey
                                             shouldUseKeyChain:shouldUseKeychain
                                                   serviceName:serviceName
                                                         error:&error];
//  UIAlertView *alert = [[UIAlertView alloc]
//                        initWithTitle:@"alert"
//                        message:@"message"
//                        delegate:self
//                        cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//  alert.accessibilityLabel = @"alert";
//  alert.tag = 999;
//  [alert show];
//  
//  UIControl *okButton = (UIControl *)[alert viewWithTag:2];
//  [okButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//
//  
//  GHTestLog(@"ok button = %@", okButton);
    
  NSDictionary *currentUserInterfaceState =
  [[[UIApplication sharedApplication] keyWindow] fullDescription];
  GHTestLog(@"current state = %@", currentUserInterfaceState);
  GHTestLog(@"synchronize error = %@", error);
  GHAssertTrue(actual, nil);
  GHAssertNil(error, nil);
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  GHTestLog(@"touched button at index: %d", buttonIndex);
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
  domain = @"com.littlejoysoftware.LJS Keychain Tests Domain";

  fetcehedPwd = [SFHFKeychainUtils getPasswordForUsername:name andServiceName:domain error:&error];
  
  if (error != nil) {
    [self printerror:error];
  } else {
    GHTestLog(@"fetched \"%@\" for %@ in %@", fetcehedPwd, name, domain);
  }

  error = nil;
  name = @"inform test username";
  domain = @"com.littlejoysoftware.LJS Keychain Tests Domain";
  [SFHFKeychainUtils deleteItemForUsername:name andServiceName:domain error:&error];
  
  if (error != nil) {
    [self printerror:error];
  } else {
    GHTestLog(@"deleted password for %@ in %@", fetcehedPwd, name, domain);
  }

  error = nil;
  name = @"inform test username";
  domain = @"com.littlejoysoftware.LJS Keychain Tests Domain";
  fetcehedPwd = [SFHFKeychainUtils getPasswordForUsername:name andServiceName:domain error:&error];
  
  if (error != nil) {
    [self printerror:error];
  } else {
    GHTestLog(@"attempted to fetch pwd for %@ in %@ - expecting nil, got: %@", name, domain, fetcehedPwd);
  }


}



@end
