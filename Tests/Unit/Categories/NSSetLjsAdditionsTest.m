#import "LjsTestCase.h"
#import "NSMutableSet+LjsAdditions.h"

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

- (void) test_non_empty {
  NSSet *set = nil;
  GHAssertFalse([set has_objects], @"nil sets should return NO");
  GHAssertFalse([set not_empty], @"nil sets should return NO");
  set = [NSSet set];
  GHAssertFalse([set has_objects], @"empty sets should have no objects");
  GHAssertFalse([set not_empty], @"empty sets should have no objects");
  set = [NSSet setWithObject:@"a"];
  GHAssertTrue([set has_objects], @"sets with objects should have objects");
  GHAssertTrue([set not_empty], @"sets with objects should have objects");
}

- (void) test_mapcar {
  NSSet *set = [NSSet setWithObjects:@"a", @"b", @"c", nil];
  NSSet *actual = [set mapcar:^(id obj) {
    return [obj uppercaseString];
  }];
  NSSet *expected = [NSSet setWithObjects:@"A", @"B", @"C", nil];
  GHAssertEquals((NSUInteger)[set count], (NSUInteger)3, @"should contain the same number of elements");
  GHAssertTrue([[expected objectsPassingTest:^BOOL(id obj, BOOL *stop) {
    return [actual containsObject:obj];
  }] has_objects], @"actual should contain all the objects in expected");
}


- (void) test_mapc {
  NSSet *set = [self setOfMutableStrings];
  NSSet *actual = [set mapc:^(NSMutableString *obj, BOOL *stop) {
    [obj setString:[obj uppercaseString]];
  }];
  GHAssertEqualObjects(set, actual, @"array returned by mapc should be the same object as the target");
  GHAssertEquals((NSUInteger)[set count], (NSUInteger)3, @"should contain the same number of elements");
  NSSet *expected = [NSSet setWithObjects:@"A", @"B", @"C", nil];
  GHAssertTrue([[expected objectsPassingTest:^BOOL(id obj, BOOL *stop) {
    return [actual containsObject:obj];
  }] has_objects], @"actual should contain all the objects in expected");
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
    return [actual containsObject:obj];
  }] has_objects], @"actual should contain all the objects in expected");
}

#pragma mark - Push and Pop

- (void) test_push_nil {
  NSMutableSet *set = [NSMutableSet setWithObjects:@"a", @"b", @"c", nil];
  [set push:nil];
  GHAssertEquals((int)[set count], (int)3, @"should not be able to push nil");
}

- (void) test_push_non_nil {
  NSMutableSet *set = [NSMutableSet setWithObjects:@"a", @"b", @"c", nil];
  [set push:@"d"];
  GHAssertEquals((int)[set count], (int)4, @"should not be able to push non nil");
}

- (void) test_pop_empty {
  NSMutableSet *set = [NSMutableSet set];
  id obj = [set pop];
  GHAssertNil(obj, @"poping empty set should return nil");
}

- (void) test_pop_not_empty {
  NSMutableSet *set = [NSMutableSet setWithObjects:@"a", @"b", @"c", nil];
  id obj = [set pop];
  GHAssertNotNil(obj, @"should be able to pop obj from non-empty set");
  GHAssertEquals((int)[set count], (int)2, @"should not be able to push non nil");
}



@end
