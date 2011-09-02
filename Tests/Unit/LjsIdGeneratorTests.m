//
//  IdGeneratorTest.m
//  ProjectTemplate
//
//  Created by Joshua Moody on 12/22/10.
//  Copyright 2010 The Little Joy Software Company. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "LjsIdGenerator.h"

@interface LjsIdGeneratorTests : GHTestCase {}
@end

@implementation LjsIdGeneratorTests

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void)setUpClass {
  // Run at start of all tests in the class
}

- (void)tearDownClass {
  // Run at end of all tests in the class
}

- (void)setUp {
  // Run before each test method
}

- (void)tearDown {
  // Run after each test method
}  

- (void)testGHLog {
  //GHTestLog(@"GH test logging is working");
}

//- (void) testGenerateIdFromDateAndCount {
//  
//  // see if there are any errors.
//  NSString *tmp = [[IdGenerator sharedInstance] generateIdFromDateAndCount];
//  GHAssertNotNil(tmp, nil);
//  
//  // let's generate a bunch of these
//  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//  NSMutableArray *collisions = [[NSMutableArray alloc] init];
//  int index;
//  NSString *uid;
//  for (index = 0; index < 10000; index++) {
//    uid = [[IdGenerator sharedInstance] generateIdFromDateAndCount];
//    if ([dictionary objectForKey:uid] == nil) {
//      [dictionary setObject:uid forKey:uid];
//    } else {
//      GHTestLog(@"collision occured for key %@", uid);
//      [collisions addObject:uid];
//    }
//  }
//  
//  NSString *key;
//  int max, min, current;
//  min = 999999999;
//  max = 0;
//  for (key in [dictionary allKeys]) {
//    current = [key length];
//    if (current < min) {
//      min = current;
//    } else if (current > max) {
//      max = current;
//    }
//  }
//  GHAssertTrue([collisions count] == 0, nil);
//  GHAssertEquals(min, 16, nil);
//  GHAssertEquals(max, 19, nil);
//}

- (void) testGenerateUUID {
  NSString *tmp = [[LjsIdGenerator sharedInstance] generateUUID];
  GHAssertNotNil(tmp, nil);
  GHAssertTrue([tmp length] == 36, nil);
}

- (void) test_uuidWithCouchDBUuid {
  
  // "6e1295ed-6c29-495e-54cc-05947f18c8af"
  //  6E1295ED-6C29-495E-54CC-05947F18C8AF
  NSString *result = [[LjsIdGenerator sharedInstance] uuidWithCouchDBUuid:@"6e1295ed6c29495e54cc05947f18c8af"];
  GHAssertEqualStrings(result, @"6E1295ED-6C29-495E-54CC-05947F18C8AF", nil);
  
}

- (void) test_generateCouchDbCompatibleUUID {
  NSString *result = [[LjsIdGenerator sharedInstance] generateCouchDbCompatibleUUID];
  //GHTestLog(@"result = %@", result);
  GHAssertNotNil(result, nil);
}

- (void) test_couchDbUuidWithUuid {
  // "6e1295ed6c29495e54cc05947f18c8af"
  //  6E1295ED-6C29-495E-54CC-05947F18C8AF
  NSString *result = [[LjsIdGenerator sharedInstance] couchDbUuidWithUuid:@"6E1295ED-6C29-495E-54CC-05947F18C8AF"];
  GHAssertEqualStrings(result, @"6e1295ed6c29495e54cc05947f18c8af", nil);
}
@end
