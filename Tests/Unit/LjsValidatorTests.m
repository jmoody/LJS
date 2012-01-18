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
#import "LjsValidator.h"
#import "LjsVariates.h"

@interface LjsValidatorTests : LjsTestCase {}
@end


@implementation LjsValidatorTests

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

//- (void)testGHLog {
//  GHTestLog(@"GH test logging is working");
//}

- (void) test_stringContiansOnlyMembersOfCharacterSet {
  NSString *string;
  BOOL actual;
  NSCharacterSet *set;
  
  string = nil;
  set = nil;
  actual = [LjsValidator string:string containsOnlyMembersOfCharacterSet:set];
  GHAssertFalse(actual, nil);
  
  string = nil;
  set = [NSCharacterSet alphanumericCharacterSet];
  actual = [LjsValidator string:string containsOnlyMembersOfCharacterSet:set];
  GHAssertFalse(actual, nil);
  
  string = @"";
  set = [NSCharacterSet alphanumericCharacterSet];
  actual = [LjsValidator string:string containsOnlyMembersOfCharacterSet:set];
  GHAssertFalse(actual, nil);

  string = @"abcde1234";
  set = [NSCharacterSet alphanumericCharacterSet];
  actual = [LjsValidator string:string containsOnlyMembersOfCharacterSet:set];
  GHAssertTrue(actual, nil);

  string = @"abc de1234";
  set = [NSCharacterSet alphanumericCharacterSet];
  actual = [LjsValidator string:string containsOnlyMembersOfCharacterSet:set];
  GHAssertFalse(actual, nil);

  string = @"abcde1234";
  set = [NSCharacterSet decimalDigitCharacterSet];
  actual = [LjsValidator string:string containsOnlyMembersOfCharacterSet:set];
  GHAssertFalse(actual, nil);
  
}


- (void) test_isAlphaNumeric {
  NSString *test;
  BOOL actual;
  
  test = nil;
  actual = [LjsValidator stringContainsOnlyAlphaNumeric:test];
  GHAssertFalse(actual, nil);
  
  test = @"";
  actual = [LjsValidator stringContainsOnlyAlphaNumeric:test];
  GHAssertFalse(actual, nil);
  
  test = @"530";
  actual = [LjsValidator stringContainsOnlyAlphaNumeric:test];
  GHAssertTrue(actual, nil);
  
  test = @"5--";
  actual = [LjsValidator stringContainsOnlyAlphaNumeric:test];
  GHAssertFalse(actual, nil);
  
  test = @"5adf";
  actual = [LjsValidator stringContainsOnlyAlphaNumeric:test];
  GHAssertTrue(actual, nil);
  
}


- (void) test_isNumeric {
  NSString *test;
  BOOL actual;

  test = nil;
  actual = [LjsValidator stringContainsOnlyNumbers:test];
  GHAssertFalse(actual, nil);

  test = @"";
  actual = [LjsValidator stringContainsOnlyNumbers:test];
  GHAssertFalse(actual, nil);

  test = @"530";
  actual = [LjsValidator stringContainsOnlyNumbers:test];
  GHAssertTrue(actual, nil);
  
  test = @"5--";
  actual = [LjsValidator stringContainsOnlyNumbers:test];
  GHAssertFalse(actual, nil);
  
  test = @"5adf";
  actual = [LjsValidator stringContainsOnlyNumbers:test];
  GHAssertFalse(actual, nil);
  
}

- (void) test_isDictionary {
  
  BOOL actual;
  id value;
  
  value = @"some string";
  actual = [LjsValidator isDictionary:value];
  GHAssertFalse(actual, nil);
  
  value = [NSArray array];
  actual = [LjsValidator isDictionary:value];
  GHAssertFalse(actual, nil);
  
  value = nil;
  actual = [LjsValidator isDictionary:value];
  GHAssertFalse(actual, nil);
  
  value = [NSDictionary dictionary];
  actual = [LjsValidator isDictionary:value];
  GHAssertTrue(actual, nil);
  
}

- (void) test_isArray {
  BOOL actual;
  id value;
  
  value = @"some string";
  actual = [LjsValidator isArray:value];
  GHAssertFalse(actual, nil);
  
  value = [NSArray array];
  actual = [LjsValidator isArray:value];
  GHAssertTrue(actual, nil);
  
  value = nil;
  actual = [LjsValidator isArray:value];
  GHAssertFalse(actual, nil);
  
  value = [NSDictionary dictionary];
  actual = [LjsValidator isArray:value];
  GHAssertFalse(actual, nil);
  
}

- (void) test_isString {
  BOOL actual;
  id value;
  
  value = @"some string";
  actual = [LjsValidator isString:value];
  GHAssertTrue(actual, nil);
  
  value = [NSArray array];
  actual = [LjsValidator isString:value];
  GHAssertFalse(actual, nil);
  
  value = nil;
  actual = [LjsValidator isString:value];
  GHAssertFalse(actual, nil);
  
  value = [NSDictionary dictionary];
  actual = [LjsValidator isString:value];
  GHAssertFalse(actual, nil);
}

- (void) test_payloadContainsKey {
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"1", @"a", @"2", @"b", nil];
  
  NSString *key;
  BOOL actual;
  
  key = @"a";
  actual = [LjsValidator dictionary:dictionary containsKey:key];
  GHAssertTrue(actual, nil);
  
  key = @"C";
  actual = [LjsValidator dictionary:dictionary containsKey:key];
  GHAssertFalse(actual, nil);
}

- (void) test_arrayHasCount {
  NSArray *array = nil;
  BOOL actual;
  
  actual = [LjsValidator array:array hasCount:0];
  GHAssertTrue(actual, nil);
  
  array = [NSArray arrayWithObject:@"foo"];
  actual = [LjsValidator array:array hasCount:1];
  GHAssertTrue(actual, nil);
  actual = [LjsValidator array:array hasCount:2];
  GHAssertFalse(actual, nil);
}

- (void) test_arrayContainsString {
  NSArray *array = nil;
  NSString *search = nil;
  BOOL actual;
  
  actual = [LjsValidator array:array containsString:search];
  GHAssertFalse(actual, nil);
  
  array = nil;
  search = @"foo";
  actual = [LjsValidator array:array containsString:search];
  GHAssertFalse(actual, nil);

  array = [NSArray arrayWithObject:@"foo"];
  search = nil;
  actual = [LjsValidator array:array containsString:search];
  GHAssertFalse(actual, nil);

  array = [NSArray arrayWithObject:@"foo"];
  search = @"bar";
  actual = [LjsValidator array:array containsString:search];
  GHAssertFalse(actual, nil);

  array = [NSArray arrayWithObject:@"foo"];
  search = @"foo";
  actual = [LjsValidator array:array containsString:search];
  GHAssertTrue(actual, nil);
}

- (void) test_arrayContainsStringInSetAllowsOthers {
  NSArray *array = nil;
  NSSet *set = nil;
  BOOL actual, allowsOthers;
  
  allowsOthers = YES;
  actual = [LjsValidator array:array containsStrings:set allowsOthers:allowsOthers];
  GHAssertFalse(actual, nil);
  
  allowsOthers = YES;
  array = [NSArray arrayWithObjects:@"foo", @"bar", @"foobar", nil];
  set = nil;
    actual = [LjsValidator array:array containsStrings:set allowsOthers:allowsOthers];
  GHAssertFalse(actual, nil);
  
  allowsOthers = YES;
  array = [NSArray arrayWithObjects:@"foo", @"bar", @"foobar", nil];
  set = [NSSet setWithObjects:@"no", nil];
  actual = [LjsValidator array:array containsStrings:set allowsOthers:allowsOthers];
  GHAssertFalse(actual, nil);
  
  allowsOthers = YES;
  array = [NSArray arrayWithObjects:@"foo", @"bar", @"foobar", nil];
  set = [NSSet setWithObjects:@"foo", nil];
  actual = [LjsValidator array:array containsStrings:set allowsOthers:allowsOthers];
  GHAssertTrue(actual, nil);

  allowsOthers = NO;
  array = [NSArray arrayWithObjects:@"foo", @"bar", @"foobar", nil];
  set = [NSSet setWithObjects:@"foo", nil];
  actual = [LjsValidator array:array containsStrings:set allowsOthers:allowsOthers];
  GHAssertFalse(actual, nil);

  allowsOthers = NO;
  array = [NSArray arrayWithObjects:@"foo", @"bar", @"foobar", nil];
  set = [NSSet setWithObjects:@"foo", @"bar", @"foobar", nil];
  actual = [LjsValidator array:array containsStrings:set allowsOthers:allowsOthers];
  GHAssertTrue(actual, nil);

  allowsOthers = NO;
  array = [NSArray arrayWithObjects:@"foo", @"bar", @"foo", @"bar", @"foobar", nil];
  set = [NSSet setWithObjects:@"foo", @"bar", @"foobar", nil];
  actual = [LjsValidator array:array containsStrings:set allowsOthers:allowsOthers];
  GHAssertTrue(actual, nil);
}

- (void) test_stringNonNilOrEmpty {
  NSString *string;
  BOOL actual;
  
  string = nil;
  actual = [LjsValidator stringIsNonNilOrEmpty:string];
  GHAssertFalse(actual, nil);
  
  string = @"";
  actual = [LjsValidator stringIsNonNilOrEmpty:string];
  GHAssertFalse(actual, nil);

  string = [LjsVariates randomStringWithLength:3];
  actual = [LjsValidator stringIsNonNilOrEmpty:string];
  GHAssertTrue(actual, nil);
  
}

@end
