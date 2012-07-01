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
#import "LjsGestalt.h"

@interface NSStringLjsAdditionsTest : LjsTestCase {}
@end


@implementation NSStringLjsAdditionsTest

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

- (void) test_emptyp_YES {
  NSString *str = nil;
  GHAssertFalse([str emptyp], @"should return false for nil string, should be obvious, but this is a clarifying test");
  str = @"";
  GHAssertTrue([str emptyp], @"emptyp should return YES if string is empty");

}

- (void) test_emptyp_NO {
  GHAssertFalse([@"foo" emptyp], @"not empty and non nil strings should not be emptyp");
}

- (void) test_stringIsEmptyP_YES {
  for (NSUInteger index = 0; index < 5; index++) {
    GHAssertTrue([NSString stringIsEmptyP:[self emptyStringOrNil]], @"stirng is empty p should return YES if string is empty or nil");
  }
}

- (void) test_stringIsEmptyP_NO {
  GHAssertFalse([NSString stringIsEmptyP:@"foo"], @"string is empty p should return false for non empty strings");
}


#if TARGET_OS_IPHONE
- (void) test_string_by_truncating_with_ellipsis {
  NSString *text, *actual;
  CGFloat w;
  CGSize size;
  UIFont *font = [UIFont systemFontOfSize:18];
  text = @"The horse raced past the barn fell.";
  size = [text sizeWithFont:font];
  w = size.width / 2;
  actual = [text stringByTruncatingToWidth:w withFont:font];

  // bloody fucking impossible to figure out
  // and maybe non-deterministic
  // iphone sim 4.3, mercury,  ipad 4.3 sim (non-retina)
  // The horse rac...
  // pluto, ipad 5.0 sim (non-retina/non-retina)
  // The horse ra...
  NSArray *candidates = [NSArray arrayWithObjects:
                         @"The horse rac...",
                         @"The horse ra...", nil];
  
  GHAssertTrue([candidates containsObject:actual], 
               @"%@ should be one of these strings: %@", actual, candidates);

}
#endif

- (void) test_make_keyword {
  NSString *actual = [@"a" makeKeyword];
  assertThat(actual, is(@":a"));
}

@end
