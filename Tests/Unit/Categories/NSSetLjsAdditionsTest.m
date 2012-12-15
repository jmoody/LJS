

#import "LjsTestCase.h"

@interface NSSetLjsAdditionsTest : LjsTestCase


@end


@implementation NSSetLjsAdditionsTest

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

- (void) test_emptyp {
  NSSet *set = nil;
  GHAssertFalse([set emptyp], @"nil set should return NO - should be obvious - included as a clarifying test");
  set = [NSSet set];
  GHAssertTrue([set emptyp], @"emptyp should return yes if set is empty");
  set = [NSSet setWithObject:@"a"];
  GHAssertFalse([set emptyp], @"sets with objects should not be emptyp");
}

- (void) test_setIsEmptyP_YES {
  NSSet *set = nil;
  GHAssertTrue([NSSet setIsEmptyP:set], @"nil sets should be emptyp");
  set = [NSSet set];
  GHAssertTrue([NSSet setIsEmptyP:set], @"empty sets should be emptyp");
}

- (void) test_setIsEmptyP_NO {
  NSSet *set = [NSSet setWithObject:@"a"];
  GHAssertFalse([NSSet setIsEmptyP:set], @"sets that are not empty should not be emptyp");
}

- (void) test_mapcar {
  NSSet *set = [NSSet setWithObjects:@"a", @"b", @"c", nil];
  NSSet *actual = [set mapcar:^(id obj) {
    return [obj uppercaseString];
  }];
  NSSet *expected = [NSSet setWithObjects:@"A", @"B", @"C", nil];
  GHAssertEquals((NSUInteger)[set count], (NSUInteger)3, @"should contain the same number of elements");
  GHAssertTrue([[expected objectsPassingTest:^BOOL(id obj, BOOL *stop) {
    return ![actual containsObject:obj];
  }] emptyp], @"actual should contain all the objects in expected");
}


/*
 - (NSSet *) mapc:(void (^)(id obj)) aBlock;
 // the threshold for useful concurrency is 10,000 and 50,000 objects
 //http://darkdust.net/writings/objective-c/nsarray-enumeration-performance#The_graphs
 - (NSSet *) mapc:(void (^)(id obj)) aBlock concurrent:(BOOL) aConcurrent;
 
 */


- (void) test_mapc {
  NSSet *set = [self setOfMutableStrings];
  NSSet *actual = [set mapc:^(NSMutableString *obj, BOOL *stop) {
    [obj setString:[obj uppercaseString]];
  }];
  GHAssertEqualObjects(set, actual, @"array returned by mapc should be the same object as the target");
  GHAssertEquals((NSUInteger)[set count], (NSUInteger)3, @"should contain the same number of elements");
  NSSet *expected = [NSSet setWithObjects:@"A", @"B", @"C", nil];
  GHAssertTrue([[expected objectsPassingTest:^BOOL(id obj, BOOL *stop) {
    return ![actual containsObject:obj];
  }] emptyp], @"actual should contain all the objects in expected");
}

- (void) test_mapc_concurrent {
  NSSet *set = [self setOfMutableStrings];
  NSSet *actual = [set mapc:^(NSMutableString *obj, BOOL *stop) {
    [obj setString:[obj uppercaseString]];
  }
                     concurrent:YES];
  GHAssertEqualObjects(set, actual, @"array returned by mapc should be the same object as the target");
  GHAssertEquals((NSUInteger)[set count], (NSUInteger)3, @"should contain the same number of elements");
  NSSet *expected = [NSSet setWithObjects:@"A", @"B", @"C", nil];
  GHAssertTrue([[expected objectsPassingTest:^BOOL(id obj, BOOL *stop) {
    return ![actual containsObject:obj];
  }] emptyp], @"actual should contain all the objects in expected");  
}

@end
