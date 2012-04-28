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

- (void) test_isZeroRect_true {
  BOOL actual = [LjsValidator isZeroRect:CGRectZero];
  GHAssertTrue(actual, @"should be true");
}

- (void) test_isZeroRect_false {
  BOOL actual = [LjsValidator isZeroRect:CGRectMake(0,1,0,1)];
  GHAssertFalse(actual, @"should be false");
}


#pragma mark LjsReasons Tests 

- (void) test_ljsReasonsInit {
  LjsReasons *reasons = [[LjsReasons alloc] init];
  GHAssertNotNil(reasons, @"reasons should not be nil");
   GHAssertFalse([reasons hasReasons], @"reasons array should be empty");
}

- (void) test_ljsReasonsAddReason {
  LjsReasons *reasons = [[LjsReasons alloc] init];
  [reasons addReason:@"foo"];
  GHAssertTrue([reasons hasReasons], @"reasons array should have one reason after adding a reason");
}

- (void) test_ljsReasonsAddReasonIfNil {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"foo" ifNil:@"bar"];
  GHAssertFalse([reasons hasReasons], @"reasons array should be empty");
  [reasons addReasonWithVarName:@"niller" ifNil:nil];
  GHAssertTrue([reasons hasReasons], @"reasons array should have one reason after adding a reason");
}

- (void) test_explanation {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReason:@"foo"];
  
  NSString *actual = [reasons explanation:@"could not make foo"
                          withConsequence:nil];
  GHTestLog(@"explanation = %@", actual);
  NSString *expected = @"could not make foo for these reasons:\n(\n    foo\n)";
  GHAssertEqualStrings(actual, expected, nil);
}

- (void) test_explanationWithNoConsequence {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReason:@"foo"];

  NSString *actual = [reasons explanation:@"could not make foo"
                          withConsequence:nil];
  GHTestLog(@"explanation = %@", actual);
  NSString *expected = @"could not make foo for these reasons:\n(\n    foo\n)";
  GHAssertEqualStrings(actual, expected, nil);
}

- (void) test_explanationWithConsequence {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReason:@"foo"];
  
  NSString *actual = [reasons explanation:@"could not make foo"
                          withConsequence:@"nil"];
  GHTestLog(@"explanation = %@", actual);
  NSString *expected = @"could not make foo for these reasons:\n(\n    foo\n)\nreturning nil";
  GHAssertEqualStrings(actual, expected, nil);
}


//- (void) addReason:(NSString *)aReason ifNilOrEmptyString:(NSString *) aString;
- (void) test_addReasonIfNilOrEmptyString {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"foo" ifNilOrEmptyString:[self emptyStringOrNil]];
  GHAssertTrue([reasons hasReasons], @"should have reasons");  
}

//- (void) addReason:(NSString *)aReason ifElement:(id) aObject notInList:(id) aFirst, ... {

- (void) test_addReasonIfElementNotInList_ElementInList {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"foo" ifElement:@"a" notInList:@"a", @"b", @"c", nil];
  GHAssertFalse([reasons hasReasons], @"should not have reasons");
}


- (void) test_addReasonIfElementNotInList_ElementNotInList {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"foo" ifElement:@"q" notInList:@"a", @"b", @"c", nil];
  GHAssertTrue([reasons hasReasons], @"should have reasons");
  GHTestLog(@"explanation: %@", [reasons explanation:@"i will give a reason"]);
}

- (void) test_addReasonIfElementNotInArray_element_in_list {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"foo" 
                      ifElement:@"a"
                     notInArray:[NSArray arrayWithObjects:@"a", @"b", @"c", nil]];
  GHAssertFalse([reasons hasReasons], @"should not have reasons");
}

- (void) test_addReasonIfElementNotInArray_element_not_in_list {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"foo" 
                      ifElement:@"q"
                     notInArray:[NSArray arrayWithObjects:@"a", @"b", @"c", nil]];
  GHAssertTrue([reasons hasReasons], @"should have reasons");  
}

- (void) test_addReasonIfElementInList_elementInList {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"foo"
                      ifElement:@"a"
                         inList:@"a", @"b", @"c", nil];
  GHAssertTrue([reasons hasReasons], @"should have reasons");  
}

- (void) test_addReasonIfElementInList_elementNotInList {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"foo"
                      ifElement:@"q"
                         inList:@"a", @"b", @"c", nil];
  GHAssertFalse([reasons hasReasons], @"should not have reasons");
}

- (void) test_addReasonIfElementInArray_elementInArray {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"foo"
                      ifElement:@"a"
                        inArray:[NSArray arrayWithObjects:@"a", @"b", @"c", nil]];
  GHAssertTrue([reasons hasReasons], @"should have reasons");  
}

- (void) test_addReasonIfElementInArray_elementNotInArray {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"foo"
                      ifElement:@"q"
                        inArray:[NSArray arrayWithObjects:@"a", @"b", @"c", nil]];
  GHAssertFalse([reasons hasReasons], @"should not have reasons");  
}



@end
