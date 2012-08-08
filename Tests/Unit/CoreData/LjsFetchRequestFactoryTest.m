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

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsManagedObjectContextTest.h"
#import "LjsFetchRequestFactory.h"
#import "FourEdPodcastManager.h"
#import "4ePodcastsModel.h"

@interface LjsFetchRequestFactory (TEST)

@end

@interface LjsFetchRequestFactoryTest : LjsManagedObjectContextTest {}
@property (nonatomic, strong) LjsFetchRequestFactory *fac;
@property (nonatomic, strong) FourEdPodcastManager *man;
@property (nonatomic, assign, readonly) NSManagedObjectContext *context;
@end

@implementation LjsFetchRequestFactoryTest
@synthesize fac;
@synthesize man;
@synthesize context;

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  [super setUpClass];
  // Run at start of all tests in the class
  self.fac = [LjsFetchRequestFactory new];
}

- (void) tearDownClass {
  // Run at end of all tests in the class
  [super tearDownClass];
  self.fac = nil;
}

- (void) setUp {
  [super setUp];
  // Run before each test method
  NSManagedObjectContext *con = [self inMemoryContextWithModelName:@"4ePodcasts"];
  GHAssertNotNil(con, @"context cannot be nil");
  self.man = [[FourEdPodcastManager alloc] initWithContext:con];
  GHAssertNotNil(self.man, @"manager cannot be nil");
}

- (void) tearDown {
  self.man = nil;
  // Run after each test method
  [super tearDown];
}

- (NSManagedObjectContext *) context {
  return man.context;
}
- (void) test_predicate_with_key {
  NSPredicate *prd = [self.fac predicateForKey:@":key"];
  NSString *actual = [prd predicateFormat];
  assertThat(actual, is(@"key LIKE \":key\""));
}

/*
 - (NSPredicate *) predicateForAttribute:(NSString *)aAttributeName
 value:(NSString *)aAttributeValue {
 
 */
- (void) test_predicate_with_attribute_name_and_value {
  NSPredicate *prd = [self.fac predicateForAttribute:@"dataSourceType.name"
                                                             value:@"action"];
  NSString *actual = [prd predicateFormat];
  assertThat(actual, is(@"dataSourceType.name LIKE \"action\""));
}

- (void) test_predicate_with_attribute_value_and_key {
  NSPredicate *prd = [self.fac predicateForAttribute:@"type"
                                                             value:@":action-type"
                                                               key:@":key"];
  NSString *actual = [prd predicateFormat];
  assertThat(actual, is(@"key LIKE \":key\" AND type LIKE \":action-type\""));
}

/*
 - (NSUInteger) countForEntity:(NSString *) aEntityName
 predicate:(NSPredicate *) aPredicateOrNil
 context:(NSManagedObjectContext *) aContext
 error:(NSError **) error;
 */

- (void) test_count_for_entity_with_bad_entity_name {
  NSError *error = nil;
  NSUInteger actual = [self.fac countForEntity:[self emptyStringOrNil]
                                     predicate:nil
                                       context:self.context
                                         error:&error];
  assertThatInteger(actual, equalToInteger(NSNotFound));
  GHAssertNotNil(error, @"error must not be nil");
  GHTestLog(@"error = %@", error);
}

- (void) test_count_for_entity_with_nil_context {
  NSError *error = nil;
  NSUInteger actual = [self.fac countForEntity:[DndCharacter entityName]
                                     predicate:nil
                                       context:nil
                                         error:&error];
  assertThatInteger(actual, equalToInteger(NSNotFound));
  GHAssertNotNil(error, @"error must not be nil");
  GHTestLog(@"error = %@", error);
}



- (void) test_count_for_entity_with_nil_predicate {
  NSError *error = nil;
  NSUInteger actual = [self.fac countForEntity:[DndRace entityName]
                                      predicate:nil
                                        context:self.context
                                          error:&error];
  GHAssertNil(error, @"error must be nil: %@", error);
  assertThatInteger(actual, equalToInteger(5));
}

- (void) test_count_for_entity_with_key_predicate {
  NSError *error = nil;
  NSPredicate *prd = [self.fac predicateForKey:@":stephen"];
  NSUInteger actual = [self.fac countForEntity:[DndPlayer entityName]
                                     predicate:prd
                                       context:self.context
                                         error:&error];
  GHAssertNil(error, @"error must be nil: %@", error);
  assertThatInteger(actual, equalToInteger(1));
}

- (void) test_count_for_entity_with_compound_predicate_unique {
  NSError *error = nil;
  
  NSPredicate *prd = [self.fac predicateForAttribute:@"race.key"
                                               value:@":eladrin"
                                                 key:@":orem"];
  NSUInteger actual = [self.fac countForEntity:[DndCharacter entityName]
                                     predicate:prd
                                       context:self.context
                                         error:&error];
  GHAssertNil(error, @"error must be nil: %@", error);
  assertThatInteger(actual, equalToInteger(1));
}

- (void) test_count_for_entity_with_compound_predicate_none {
  NSError *error = nil;
  
  NSPredicate *prd = [self.fac predicateForAttribute:@"role.key"
                                               value:@":controller"
                                                 key:@":torque"];
  NSUInteger actual = [self.fac countForEntity:[DndCharacter entityName]
                                     predicate:prd
                                       context:self.context
                                         error:&error];
  GHAssertNil(error, @"error must be nil: %@", error);
  assertThatInteger(actual, equalToInteger(0));
}

/*
 - (BOOL) entityExistsForKey:(NSString *) aKey
 entityName:(NSString *) aEntityName
 context:(NSManagedObjectContext *) aContext
 shouldBeUnique:(BOOL) aShouldBeUnique
 error:(NSError **) aError {
 */

- (void) test_entity_exists_for_key_bad_key {
  NSError *error = nil;
  NSUInteger count = NSNotFound - 1;
  BOOL actual = [self.fac entityExistsForKey:[self emptyStringOrNil]
                                  entityName:[DndRace entityName]
                                     context:self.context
                                       count:&count
                                       error:&error];
  
  GHAssertNotNil(error, @"error must not be nil");
  assertThatInteger(count, equalToInteger(NSNotFound));
  assertThatBool(actual, equalToBool(NO));
  GHTestLog(@"error = %@", error);
}

- (void) test_entity_exists_for_key_bad_entity_name {
  NSError *error = nil;
  NSUInteger count = NSNotFound - 1;
  BOOL actual = [self.fac entityExistsForKey:@":some key"
                                  entityName:[self emptyStringOrNil]
                                     context:self.context
                                       count:&count
                                       error:&error];
  
  GHAssertNotNil(error, @"error must not be nil");
  assertThatInteger(count, equalToInteger(NSNotFound));
  assertThatBool(actual, equalToBool(NO));
  GHTestLog(@"error = %@", error);
}

- (void) test_entity_exists_for_key_nil_context {
  NSError *error = nil;
  NSUInteger count = NSNotFound - 1;
  BOOL actual = [self.fac entityExistsForKey:@":some key"
                                  entityName:@"entity"
                                     context:nil
                                       count:&count
                                       error:&error];
  
  GHAssertNotNil(error, @"error must not be nil");
  assertThatInteger(count, equalToInteger(NSNotFound));
  assertThatBool(actual, equalToBool(NO));
  GHTestLog(@"error = %@", error);
}

- (void) test_entity_exists_for_key_no_ref_nil_context {
  NSError *error = nil;
  //NSUInteger count = NSNotFound - 1;
  BOOL actual = [self.fac entityExistsForKey:@":some key"
                                  entityName:@"entity"
                                     context:nil
                                       count:nil
                                       error:&error];
  
  GHAssertNotNil(error, @"error must not be nil");
  //assertThatInteger(count, equalToInteger(NSNotFound));
  assertThatBool(actual, equalToBool(NO));
  GHTestLog(@"error = %@", error);
}

- (void) test_entity_exists_for_key_return_yes {
  NSError *error = nil;
  NSUInteger count = NSNotFound;
  BOOL actual = [self.fac entityExistsForKey:@":half-orc"
                                  entityName:[DndRace entityName]
                                     context:self.context
                                       count:&count
                                       error:&error];
  
  GHAssertNil(error, @"error must be nil: %@", error);
  assertThatInteger(count, isNot(equalToInteger(NSNotFound)));
  assertThatBool(actual, equalToBool(YES));
}

- (void) test_entity_exists_for_key_return_no {
  NSError *error = nil;
  NSUInteger count = NSNotFound;
  BOOL actual = [self.fac entityExistsForKey:@":dwarf"
                                  entityName:[DndRace entityName]
                                     context:self.context
                                       count:&count
                                       error:&error];
  
  GHAssertNil(error, @"error must be nil: %@", error);
  assertThatInteger(count, isNot(equalToInteger(NSNotFound)));
  assertThatBool(actual, equalToBool(NO));
}


- (void) test_entity_exists_for_key_return_yes_not_unique {
  
  DndRole *role = (DndRole *)[DndRole insertInManagedObjectContext:self.context];
  role.displayName = @"FOOBAR";
  role.key = @":striker";
  [self.man saveContext:self.context];
  
  NSError *error = nil;
  NSUInteger count = NSNotFound;
  BOOL actual = [self.fac entityExistsForKey:@":striker"
                                  entityName:[DndRole entityName]
                                     context:self.context
                                       count:&count
                                       error:&error];
  
  GHAssertNil(error, @"error must be nil: %@", error);
  assertThatInteger(count, equalToInteger(2));
  assertThatBool(actual, equalToBool(YES));
}

- (void) test_entity_exists_error {
    
  NSError *error = nil;
  NSUInteger count = NSNotFound;
  BOOL actual = [self.fac entityExistsForKey:@":striker"
                                  entityName:[DndRole entityName]
                                     context:nil
                                       count:&count
                                       error:&error];
  assertThatInteger(count, equalToInteger(NSNotFound));
  GHAssertNotNil(error, @"error must not be nil");
  assertThatBool(actual, equalToBool(NO));
}

/*
 - (id) entityForKey:(NSString *) aKey
 entityName:(NSString *) aEntityName
 count:(NSUInteger *) aCountRef
 context:(NSManagedObjectContext *) aContext
 error:(NSError **) aError;
 
 */
- (void) test_entity_for_key_bad_key {
  NSError *error = nil;
  NSUInteger count;
  DndRole *role = [self.fac entityForKey:[self emptyStringOrNil]
                              entityName:[DndRole entityName]
                                   count:&count
                                 context:self.context
                                   error:&error];
  assertThatInteger(count, equalToInteger(NSNotFound));
  GHAssertNotNil(error, @"error must not be nil");
  GHAssertNil(role, @"role must be nil");
}

- (void) test_entity_for_key_bad_entity_name {
  NSError *error = nil;
  NSUInteger count = NSNotFound - 1;
  DndRole *role = [self.fac entityForKey:@":key"
                              entityName:[self emptyStringOrNil]
                                   count:&count
                                 context:self.context
                                   error:&error];
  assertThatInteger(count, equalToInteger(NSNotFound));
  GHAssertNotNil(error, @"error must not be nil");
  GHAssertNil(role, @"role must be nil");
}

- (void) test_entity_for_key_nil_context {
  NSError *error = nil;
  NSUInteger count = NSNotFound - 1;
  DndRole *role = [self.fac entityForKey:@":key"
                              entityName:@"entity name"
                                   count:&count
                                 context:nil
                                   error:&error];
  assertThatInteger(count, equalToInteger(NSNotFound));
  GHAssertNotNil(error, @"error must not be nil");
  GHAssertNil(role, @"role must be nil");
}

- (void) test_entity_for_key_return_unique {
  NSError *error = nil;
  NSUInteger count = NSNotFound - 1;
  DndRole *role = [self.fac entityForKey:@":striker"
                              entityName:[DndRole entityName]
                                   count:&count
                                 context:self.context
                                   error:&error];
  GHAssertNotNil(role, @"role must not be nil");
  GHAssertNil(error, @"error must be nil: %@", error);
  assertThatInteger(count, equalToInteger(1));
}


- (void) test_entity_for_key_return_non_unique {
  DndRole *role = (DndRole *)[DndRole insertInManagedObjectContext:self.context];
  role.displayName = @"FOOBAR";
  role.key = @":striker";
  [self.man saveContext:self.context];

  NSError *error = nil;
  NSUInteger count = NSNotFound - 1;
  DndRole *fetched = [self.fac entityForKey:@":striker"
                                 entityName:[DndRole entityName]
                                      count:&count
                                    context:self.context
                                      error:&error];
  GHAssertNotNil(fetched, @"role must not be nil");
  GHAssertNil(error, @"error must be nil: %@", error);
  assertThatInteger(count, equalToInteger(2));
}

- (void) test_entity_for_key_return_nil_because_none_found {
  
  NSError *error = nil;
  NSUInteger count = NSNotFound - 1;
  DndRole *fetched = [self.fac entityForKey:@":healer"
                                 entityName:[DndRole entityName]
                                      count:&count
                                    context:self.context
                                      error:&error];
  GHAssertNil(fetched, @"role must be nil: %@", fetched);
  GHAssertNil(error, @"error must be nil: %@", error);
  assertThatInteger(count, equalToInteger(0));
}





@end
