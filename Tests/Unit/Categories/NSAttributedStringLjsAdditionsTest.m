#import "LjsTestCase.h"
#import "NSAttributedString+LjsAdditions.h"

@interface NSAttributedStringLjsAdditionsTest : LjsTestCase {}
@end


@implementation NSAttributedStringLjsAdditionsTest

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

- (void) test_hyperlink_string {
  NSString *actual = nil;
  NSURL *url = [NSURL URLWithString:@"http://www.google.com"];

  actual = [NSAttributedString hyperlinkFromString:@"foo"
                                           withURL:url
                                         alignment:NSCenterTextAlignment];
  GHAssertNotNil(actual, @"should be able to make an attributed string");
}

@end
