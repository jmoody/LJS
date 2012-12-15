// Copyright 2012 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "LjsTestCase.h"
#import "LjsFileBackedKeyStore.h"
#import "LjsFileUtilities.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSString *LjsTestStoreFilename = @"com.littlejoysoftware.LjsTestStore.plist";



@interface LjsFileBackedStoreTests : LjsTestCase
@property (nonatomic, strong) LjsFileBackedKeyStore *store;
@property (nonatomic, strong) LjsFileBackedKeyStore *other;

- (NSArray *) listOfTestKeys;
- (NSArray *) listOfTestValues;
- (NSDictionary *) testMap;

@end

@implementation LjsFileBackedStoreTests
@synthesize store;
@synthesize other;

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
  NSString *docDir = [LjsFileUtilities findPreferencesDirectoryForUserp:YES];
  NSError *error = nil;
  
  self.store = [[LjsFileBackedKeyStore alloc]
                initWithFileName:LjsTestStoreFilename
                directoryPath:docDir
                error:&error];
  
  if (store == nil) {
    GHTestLog(@"error == %@", error);
  }
  
  GHAssertNotNil(self.store, @"store should not be nil");
  
  self.other = [[LjsFileBackedKeyStore alloc]
                initWithFileName:LjsTestStoreFilename
                directoryPath:docDir
                error:&error];
  GHAssertNotNil(self.other, @"other should not be nil");
  
}

- (void) tearDown {
  // Run after each test method
  [self.store removeKeys:[self.store allKeys]];
  self.store = nil;
  [super tearDown];
}  

- (NSArray *) listOfTestKeys {
  return [NSArray arrayWithObjects:@"a", @"b", @"c", nil];
}

- (NSArray *) listOfTestValues {
  return [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
}

- (NSDictionary *) testMap {
  return [NSDictionary dictionaryWithObjects:[self listOfTestValues]
                                     forKeys:[self listOfTestKeys]];
}

//NSUInteger actualCount = [[self.store allKeys] count];
//GHAssertEquals(actualCount, (NSUInteger)[map count], @"counts should be the same");

- (void) test_removeKeys {
  NSDictionary *map = [self testMap];
  for (NSString *key in [map allKeys]) {
    [self.store storeObject:[map objectForKey:key] forKey:key];
  }
  NSUInteger actualCount = [[self.store allKeys] count];
  NSUInteger expectedCount = [map count];
  GHAssertEquals(actualCount, expectedCount, @"should be same number of keys");
  NSString *first = [[self listOfTestKeys] first];
  NSArray *toRemove = [NSArray arrayWithObject:first];
  [self.store removeKeys:toRemove];
  
  NSString *found = [self.store stringForKey:first
                                defaultValue:nil 
                              storeIfMissing:NO];
  GHAssertNil(found, @"should not find key after removing it");

  [self.store removeKeys:[map allKeys]];
  actualCount = [[self.store allKeys] count];
  expectedCount = 0;
  GHAssertEquals(actualCount, expectedCount, @"should be no keys after removing all keys");
}

- (void) test_allKeys {
  NSDictionary *map = [self testMap];
  for (NSString *key in [map allKeys]) {
    [self.store storeObject:[map objectForKey:key] forKey:key];
  }
  GHAssertTrue([LjsValidator array:[self.store allKeys]
                   containsStrings:[map keySet] allowsOthers:NO], 
               @"store should contain %@ keys and no others",
               [map keySet]);
}


- (void) test_storeObject_for_nil_key_value {
  BOOL actual = [self.store storeObject:nil forKey:@"a"];
  GHAssertFalse(actual, @"should not be able to store nil object");
  actual = [self.store storeObject:@"a" forKey:[self emptyStringOrNil]];
  GHAssertFalse(actual, @"should not be able to store object for nil or empty key");
}

- (void) test_getting_values_from_dictionary_with_name_nil {
  id actual = [self.store valueForDictionaryNamed:nil
                                     withValueKey:@"key"
                                     defaultValue:@"default"
                                   storeIfMissing:[self flip]];
  assertThat(actual, nilValue());
}

- (void) test_getting_values_from_dictionary_with_value_key_nil {
 id actual = [self.store valueForDictionaryNamed:@"name"
                                    withValueKey:nil
                                    defaultValue:@"default"
                                  storeIfMissing:[self flip]];
  assertThat(actual, nilValue());
}

- (void) test_getting_values_from_dictionary_with_nil_default_value_persist_no {
  id obj = [self.store valueForDictionaryNamed:@"name"
                                  withValueKey:@"key"
                                  defaultValue:nil
                                storeIfMissing:NO];
  GHAssertNil(obj, @"object should be nil, but found: %@", obj);
  NSDictionary *dict = [self.store dictionaryForKey:@"name"
                                       defaultValue:nil
                                     storeIfMissing:NO];
  GHAssertNil(dict, @"dictionary for name should be nil because storeIfMissing was NO");

}

- (void) test_getting_values_from_dictionary_with_nil_default_value_persist_yes {
  id obj = [self.store valueForDictionaryNamed:@"name"
                                  withValueKey:@"key"
                                  defaultValue:nil
                                storeIfMissing:YES];
  GHAssertNil(obj, @"object should be nil, but found: %@", obj);
  NSDictionary *dict = [self.store dictionaryForKey:@"name"
                                       defaultValue:nil
                                     storeIfMissing:NO];
  GHAssertNil(dict, @"dictionary for name should be nil because default value was nil (would have stored empty array");
}

- (void) test_getting_values_from_dictionary_with_default_value_persist_no {
  id obj = [self.store valueForDictionaryNamed:@"name"
                                  withValueKey:@"key"
                                  defaultValue:@"default"
                                storeIfMissing:NO];
  GHAssertEqualStrings(obj, @"default", @"should return < default > because it was provided");
  
  NSDictionary *dict = [self.store dictionaryForKey:@"name"
                                       defaultValue:nil
                                     storeIfMissing:NO];
  GHAssertNil(dict, @"dictionary for name should be nil because storeIfMissing was NO");
}

- (void) test_getting_values_from_dictionary_with_default_value_persist_yes {
  id obj = [self.store valueForDictionaryNamed:@"name"
                                  withValueKey:@"key"
                                  defaultValue:@"default"
                                storeIfMissing:YES];
  GHAssertEqualStrings(obj, @"default", @"should return < default > because it was provided");
  
  NSDictionary *dict = [self.store dictionaryForKey:@"name"
                                       defaultValue:nil
                                     storeIfMissing:NO];
  GHAssertNotNil(dict, @"dictionary for name should not be nil storeIfMissing was YES and there was default value provided");
  GHAssertEqualStrings([dict objectForKey:@"key"], @"default", 
                       @"dictionary should contain < default > for key < key >");
  
  dict = [self.other dictionaryForKey:@"name"
                         defaultValue:nil
                       storeIfMissing:NO];
  GHAssertEqualStrings([dict objectForKey:@"key"], @"default", 
                       @"other store dictionary should contain < default > for key < key >");

}


- (void) test_updating_value_in_dictionary_with_nil_name {
  BOOL actual = [self.store updateValueInDictionaryNamed:nil
                                            withValueKey:@"key"
                                                   value:@"value"];
  GHAssertFalse(actual, @"should return false if value cannot be updated");
}

- (void) test_updating_value_in_dictionary_with_nil_key {
  BOOL actual = [self.store updateValueInDictionaryNamed:@"name"
                                            withValueKey:nil
                                                   value:@"value"];
  GHAssertFalse(actual, @"should return false if value cannot be updated");
}
                               
- (void) test_updating_value_in_dictionary_with_nil_value {
  BOOL actual = [self.store updateValueInDictionaryNamed:@"name"
                                            withValueKey:@"key"
                                                   value:nil];
  GHAssertFalse(actual, @"should return NO if we are unable to update value");
}


- (void) test_updating_value_in_dictionary {
  NSDictionary *dict = [NSDictionary dictionaryWithObject:@"old" forKey:@"key"];
  [self.store storeObject:dict forKey:@"name"];
  
  [self.store updateValueInDictionaryNamed:@"name"
                              withValueKey:@"key"
                                     value:@"new"];
  GHAssertEqualStrings([self.store valueForDictionaryNamed:@"name"
                                              withValueKey:@"key"
                                              defaultValue:nil
                                            storeIfMissing:NO],
                       @"new", @"value should have updated from < old > to < new >");
  
  GHAssertEqualStrings([self.other valueForDictionaryNamed:@"name"
                                              withValueKey:@"key"
                                              defaultValue:nil
                                            storeIfMissing:NO],
                       @"new", @"value in other store should have updated from < old > to < new >");
}






@end
