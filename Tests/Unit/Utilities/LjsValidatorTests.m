

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

#if TARGET_OS_IPHONE
- (void) test_isZeroRect_true {
  BOOL actual = [LjsValidator isZeroRect:CGRectZero];
  GHAssertTrue(actual, @"should be true");
}

- (void) test_isZeroRect_false {
  BOOL actual = [LjsValidator isZeroRect:CGRectMake(0,1,0,1)];
  GHAssertFalse(actual, @"should be false");
}
#endif

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
  
  reasons = [LjsReasons new];
  [reasons ifNil:@"bar" addReasonWithVarName:@"foo"];
  GHAssertFalse([reasons hasReasons], @"reasons array should be empty");
  [reasons ifNil:nil addReasonWithVarName:@"niller"];
  GHAssertTrue([reasons hasReasons], @"reasons array should have one reason after adding a reason");
}

- (void) test_explanation {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReason:@"foo"];
  
  NSString *actual = [reasons explanation:@"could not make foo"
                              consequence:nil];
  GHTestLog(@"explanation = %@", actual);
  NSString *expected = @"could not make foo for these reasons:\n(\n    foo\n)";
  GHAssertEqualStrings(actual, expected, nil);
}

- (void) test_explanationWithNoConsequence {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReason:@"foo"];

  NSString *actual = [reasons explanation:@"could not make foo"
                              consequence:nil];
  GHTestLog(@"explanation = %@", actual);
  NSString *expected = @"could not make foo for these reasons:\n(\n    foo\n)";
  GHAssertEqualStrings(actual, expected, nil);
}

- (void) test_explanationWithConsequence {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReason:@"foo"];
  
  NSString *actual = [reasons explanation:@"could not make foo"
                              consequence:@"nil"];
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

- (void) test_addReasonIfSelectorIsNil {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"selector"
                  ifNilSelector:nil];
  GHAssertTrue([reasons hasReasons], @"should have reasons");  
}


- (void) test_addReasonIfSelectorIsNotNil {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"selector"
                  ifNilSelector:@selector(dummySelector)];
  GHAssertFalse([reasons hasReasons], @"should not have reasons if selector is non-nil");
}

- (void) test_addReasonIfIntegerIsOnRange_on_range {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"integer" ifInteger:1 isNotOnInterval:NSMakeRange(0, 2)];
  GHAssertFalse([reasons hasReasons], @"should not have reasons if integer is on interval");
}

- (void) test_addReasonIfIntegerIsOnRange_on_lhs {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"integer" ifInteger:0 isNotOnInterval:NSMakeRange(0, 2)];
  GHAssertFalse([reasons hasReasons], @"should not have reasons if integer is on interval");
}

- (void) test_addReasonIfIntegerIsOnRange_on_rhs {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"integer" ifInteger:2 isNotOnInterval:NSMakeRange(0, 2)];
  GHAssertFalse([reasons hasReasons], @"should not have reasons if integer is on interval");
}

- (void) test_addReasonIfIntegerIsOnRange_lt_lhs {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"integer" ifInteger:-1 isNotOnInterval:NSMakeRange(0, 2)];
  GHAssertTrue([reasons hasReasons], @"should have reasons if integer is not on interval");
}

- (void) test_addReasonIfIntegerIsOnRange_gt_rhs {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"integer" ifInteger:3 isNotOnInterval:NSMakeRange(0, 2)];
  GHAssertTrue([reasons hasReasons], @"should have reasons if integer is not on interval");
}


#pragma mark - Empty String Testing

- (void) test_addReasonIfEmptyString_nil {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"string" ifEmptyString:nil];
  GHAssertFalse([reasons hasReasons], @"should not have reasons if the string is nil");
  
  reasons = [LjsReasons new];
  [reasons ifEmptyString:nil addReasonWithVarName:@"string"];
  GHAssertFalse([reasons hasReasons], @"should not have reasons if the string is nil");

}

- (void) test_addReasonIfEmptyString_not_empty {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"string" ifEmptyString:@"foo"];
  GHAssertFalse([reasons hasReasons], @"should not have reasons if the string is not empty");
  
  reasons = [LjsReasons new];
  [reasons ifEmptyString:@"foo" addReasonWithVarName:@"string"];
  GHAssertFalse([reasons hasReasons], @"should not have reasons if the string is not empty");
}

- (void) test_addReasonIfEmptyString_empty {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"string" ifEmptyString:@""];
  GHAssertTrue([reasons hasReasons], @"should have reasons if the string is empty");
  
  reasons = [LjsReasons new];
  [reasons ifEmptyString:@"" addReasonWithVarName:@"string"];
  GHAssertTrue([reasons hasReasons], @"should have reasons if the string is empty");
}

#pragma mark - Empty or Nil String Testing

- (void) test_if_empty_or_nil_string_nil_or_empty {
  LjsReasons *reasons = [LjsReasons new];
  [reasons ifNilOrEmptyString:[self emptyStringOrNil] addReasonWithVarName:@"string"];
  GHAssertTrue([reasons hasReasons], @"should have reasons if the string is nil or empty");
}

- (void) test_if_empty_or_nil_string_not_nil_not_empty {
  LjsReasons *reasons = [LjsReasons new];
  [reasons ifNilOrEmptyString:@"foo" addReasonWithVarName:@"string"];
  GHAssertFalse([reasons hasReasons], @"should not have reasons if the string is not empty or nil");
}

#pragma mark - Interval Testing

- (void) test_add_reason_if_not_on_interval_or_equal_to_value_not_on_lhs {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"integer"
                      ifInteger:-1
                isNotOnInterval:NSMakeRange(0, 2)
                      orEqualTo:NSNotFound];
  GHAssertTrue([reasons hasReasons], @"should have reasons if integer is not on interval or equal to outlier");
}

- (void) test_add_reason_if_not_on_interval_or_equal_to_value_not_on_rhs {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"integer"
                      ifInteger:3
                isNotOnInterval:NSMakeRange(0, 2)
                      orEqualTo:NSNotFound];
  GHAssertTrue([reasons hasReasons], @"should have reasons if integer is not on interval or equal to outlier");
}

- (void) test_add_reason_if_not_on_interval_or_equal_to_value_on_interval_equal_outlier {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"integer"
                      ifInteger:NSNotFound
                isNotOnInterval:NSMakeRange(0, 2)
                      orEqualTo:NSNotFound];
  GHAssertFalse([reasons hasReasons], @"should not have reasons if integer is not on interval, but equal to outlier");
}

#pragma mark - Array Testing 
- (void) test_if_empty_array_empty {
  LjsReasons *reasons = [LjsReasons new];
  [reasons ifEmptyArray:[NSArray array] addReasonWithVarName:@"array"];
  GHAssertTrue([reasons hasReasons], @"should have reason if array is empty");
}


- (void) test_if_empty_array_nil_array {
  LjsReasons *reasons = [LjsReasons new];
  [reasons ifEmptyArray:nil addReasonWithVarName:@"array"];
  GHAssertTrue([reasons hasReasons], @"should have reason if array is nil");
}

- (void) test_if_empty_array_not_empty {
  LjsReasons *reasons = [LjsReasons new];
  [reasons ifEmptyArray:[self arrayOfAbcStrings] addReasonWithVarName:@"array"];
  GHAssertFalse([reasons hasReasons], @"should not have reason if array is not empty");
}

@end
