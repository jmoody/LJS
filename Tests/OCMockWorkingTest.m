
#import "LjsTestCase.h"

//#ifdef LOG_CONFIGURATION_DEBUG
//static const int ddLogLevel = LOG_LEVEL_DEBUG;
//#else
//static const int ddLogLevel = LOG_LEVEL_WARN;
//#endif

@interface OCMockWorkingTest : LjsTestCase {}
@end


@implementation OCMockWorkingTest

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

- (void)test_OCMockWorking {
  id actual;
  id mock = [OCMockObject mockForClass:[NSString class]];
  [[[mock expect] andReturn:@"megamock"] lowercaseString];
  actual = [mock lowercaseString];
  [mock verify];
  GHAssertEqualStrings(actual, @"megamock", @"Should have returned stubbed value."); 
}




@end
