

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

- (void) test_has_chars_false {
  NSString *str = nil;
  GHAssertFalse([str has_chars], @"should not have chars: '%@'", str);
  GHAssertFalse([str not_empty], @"should not be not_empty: '%@'", str);
  NSMutableString *mstr = nil;
  GHAssertFalse([mstr has_chars], @"should not have chars: '%@'", mstr);
  GHAssertFalse([mstr not_empty], @"should not be not_empty: '%@'", mstr);

  str = @"";
  GHAssertFalse([str has_chars], @"should not have chars: '%@'", str);
  GHAssertFalse([str not_empty], @"should not be not_empty: '%@'", str);
  mstr = [NSMutableString stringWithString:str];
  GHAssertFalse([mstr has_chars], @"should not have chars: '%@'", mstr);
  GHAssertFalse([mstr not_empty], @"should not be not_empty: '%@'", mstr);
}

- (void) test_has_chars_true {
  NSString *str = @"a";
  GHAssertTrue([str has_chars], @"should have chars: '%@'", str);
  GHAssertTrue([str not_empty], @"should be not_empty: '%@'", str);
  NSMutableString *mstr = [NSMutableString stringWithString:str];
  GHAssertTrue([mstr has_chars], @"should have chars: '%@'", mstr);
  GHAssertTrue([mstr not_empty], @"should be not_empty: '%@'", mstr);
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


- (void) test_make_keyword_no_spaces_no_colon {
  NSString *actual = [@"abc" makeKeyword];
  assertThat(actual, is(@":abc"));
}

- (void) test_make_keyword_has_spaces {
  NSString *actual = [@"a b c" makeKeyword];
  assertThat(actual, is(@":a-b-c"));
}

- (void) test_make_keyword_has_werid_spaces {
  NSString *actual = [@" a  b     c    " makeKeyword];
  assertThat(actual, is(@":a-b-c"));
}

- (void) test_make_keyword_already_has_colon {
  NSString *actual = [@":a  b     c    " makeKeyword];
  assertThat(actual, is(@":a-b-c"));
}

- (void) test_make_keyword_has_funny_first_colon {
  NSString *actual = [@" :a  b     c    " makeKeyword];
  assertThat(actual, is(@":a-b-c"));
}

- (void) test_make_keyword_has_funnier_first_colon {
  NSString *actual = [@" : a  b     c    " makeKeyword];
  assertThat(actual, is(@":a-b-c"));
}





@end
