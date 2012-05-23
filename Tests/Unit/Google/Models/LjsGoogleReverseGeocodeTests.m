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

#import "LjsTestCase.h"
#import "LjsGoogleReverseGeocode.h"
#import "LjsGoogleAddressComponentType.h"
#import "LjsGoogleAddressComponentGeocode.h"
#import "LjsGoogleManager.h"
#import "LjsLocationManager.h"
#import "LjsGoogleReverseGeocodeOptions.h"

@interface LjsGoogleReverseGeocodeTests : LjsTestCase {}
@property (nonatomic, strong) LjsGoogleManager *manager;
@property (nonatomic, strong) LjsLocationManager *locManager;
@property (nonatomic, strong) LjsGoogleReverseGeocodeOptions *options;

@end

@implementation LjsGoogleReverseGeocodeTests
@synthesize manager;
@synthesize locManager;
@synthesize options;

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  // Run at start of all tests in the class
  self.locManager = [[LjsLocationManager alloc] init];
  self.manager = [[LjsGoogleManager alloc]
                  initWithLocationManager:self.locManager];
  
  LjsLocation *zurich = [LjsLocation locationZurich];
  LjsGrgHttpRequestOptions *httpOptions = [[LjsGrgHttpRequestOptions alloc]
                                           initWithShouldMakeRequest:YES
                                           sensor:NO
                                           postNotification:NO
                                           searchTermOrNil:nil];
  LjsGrgPredicateFactory *factory = [[LjsGrgPredicateFactory alloc] init];
  NSPredicate *predicate = [factory predicateForCityTownNeighborhoodWithLocation:zurich];
  
  self.options = [[LjsGoogleReverseGeocodeOptions alloc]
                  initWithLocation:zurich
                  predicate:predicate
                  httpRequestOptions:httpOptions];
  [self.manager geocodesWithOptions:self.options];
}

- (void) tearDownClass {
  // Run at end of all tests in the class
}

- (void) setUp {
  // Run before each test method
//  while ([self.manager geocodeExistsForLocation:self.options.location] == NO) {
//    // spin
//    GHTestLog(@"spinning");
//  }
  
  GHTestLog(@"47.41902,8.53668 ==> %@ exists ? %d",
            [self.options.location key], [self.manager geocodeExistsForLocation:self.options.location] == NO);
  
//  while ([[self.manager geocodesWithOptions:self.options] count] == 0) {
//    // spin
//  }
}

- (void) tearDown {
  // Run after each test method
}  

//- (void) test_cityStateWithoutSearchTerm {
//  NSArray *geocodes = [self.manager geocodesWithOptions:self.options];
//  LjsGoogleReverseGeocode *best = [self bestGeocodeForCityStateInArray:geocodes];
////  LjsGoogleAddressComponent *cityComp = nil;
//  //  LjsGoogleAddressComponent *stateComp = nil;
//  if (best != nil) {
//    NSArray *bestPair = [self bestPairForCityStateInGeo:best];
//    if ([bestPair count] != 0) {
//      LjsGoogleAddressComponent *city = [bestPair nth:0];
//      LjsGoogleAddressComponent *state = [bestPair nth:1];
//      
//      NSString *result = [NSString stringWithFormat:@"%@, %@",
//                          city.longName, state.longName];
//      GHTestLog(@"result = %@", result);
//      return;
//    }
//  }
//  GHTestLog(@"could not find good city/state");
//}
//
//- (void) test_cityStateWithSearchTerm {
//  NSString *result;
//  NSArray *aArray = [self.manager geocodesWithOptions:self.options];
//  
//  NSArray *comps = [NSArray array];
//  NSUInteger count = [aArray count];
//  NSUInteger index = 0;
//  LjsGoogleReverseGeocode *gc = nil;
//  do {
//    gc = [aArray nth:index];
//    comps = [gc  bestPairForCityState];
//    if ([comps count] == 2) {
//      break;
//    }
//    index++;
//  
//  } while (index < count);
//  
//  count = [comps count];
//  if (count == 2) {
//    result = [NSString stringWithFormat:@"%@, %@", 
//              [comps nth:0], [comps nth:1]];
//  } else if (count == 1) {
//    result = [NSString stringWithFormat:@"%@", [comps nth:0]];
//  } else {
//    result = nil;
//  }
//  GHTestLog(@"result = %@", result);
//}
//
//
//
//
//- (void) test_indexOfAddrCompInArrayWithTypeLongNameLike {
//  NSArray *geocodes = [self.manager geocodesWithOptions:self.options];
//  LjsGoogleReverseGeocode *first = [geocodes first];
//  NSArray *array = [first.addressComponents allObjects];
//  NSUInteger index;
//  index = [first indexOfAddrCompInArray:array
//                               withType:@"administrative_area_level_1"
//                           longNameLike:@"zurich"];
//  
//  if (index != NSNotFound) {
//    GHTestLog(@"index = %d ==> %@", index, [array nth:index]);
//  } else {
//    GHTestLog(@"not found");
//  }
//  
//}
//
//
//
//- (NSArray *) bestPairForCityStateInGeo:(LjsGoogleReverseGeocode *) aGeo
//                             searchTerm:(NSString *) aSearchTerm {
//  
//  
//  NSMutableArray *result = [NSMutableArray arrayWithCapacity:2];
//  LjsGoogleAddressComponent *cityComp = nil;
//  LjsGoogleAddressComponent *stateComp = nil;
//  cityComp = [aGeo sublocalityWithSearchTerm:aSearchTerm];
//  if (cityComp != nil) {
//    stateComp = [aGeo localityWithSearchTerm:aSearchTerm];
//    if (stateComp == nil) {
//      stateComp = [aGeo administrativeAreaLevel1WithSearchTerm:aSearchTerm];
//      if (stateComp == nil) {
//        stateComp = [aGeo countryWithSearchTerm:aSearchTerm];
//        if (stateComp == nil) {
//          return result;
//        }
//      }
//    }
//    [result nappend:cityComp];
//    [result nappend:stateComp];
//    return result;
//  }
//  
//  cityComp = [aGeo localityWithSearchTerm:aSearchTerm];
//  if (cityComp != nil) {
//    stateComp = [aGeo administrativeAreaLevel1WithSearchTerm:aSearchTerm];
//    if (stateComp == nil) {
//      stateComp = [aGeo countryWithSearchTerm:aSearchTerm];
//      if (stateComp == nil) {
//        return result;
//      }
//    }
//    [result nappend:cityComp];
//    [result nappend:stateComp];
//    return result;
//  }
//  
//  cityComp = [aGeo administrativeAreaLevel1WithSearchTerm:aSearchTerm];
//  if (cityComp != nil) {
//    stateComp = [aGeo countryWithSearchTerm:aSearchTerm];
//    if (stateComp == nil) {
//      return result;
//    }
//    [result nappend:cityComp];
//    [result nappend:stateComp];
//    return result;
//  }
//  return result;
//
//}
//
//
//
//- (NSArray *) bestPairForCityStateInGeo:(LjsGoogleReverseGeocode *) aGeo {
//  NSMutableArray *result = [NSMutableArray arrayWithCapacity:2];
//  LjsGoogleAddressComponent *cityComp = nil;
//  LjsGoogleAddressComponent *stateComp = nil;
//  cityComp = [aGeo sublocality];
//  if (cityComp != nil) {
//    stateComp = [aGeo locality];
//    if (stateComp == nil) {
//      stateComp = [aGeo administrativeAreaLevel1];
//      if (stateComp == nil) {
//        stateComp = [aGeo country];
//        if (stateComp == nil) {
//          return result;
//        }
//      }
//    }
//    [result nappend:cityComp];
//    [result nappend:stateComp];
//    return result;
//  }
//  
//  cityComp = [aGeo locality];
//  if (cityComp != nil) {
//    stateComp = [aGeo administrativeAreaLevel1];
//    if (stateComp == nil) {
//      stateComp = [aGeo country];
//      if (stateComp == nil) {
//        return result;
//      }
//    }
//    [result nappend:cityComp];
//    [result nappend:stateComp];
//    return result;
//  }
//  
//  cityComp = [aGeo administrativeAreaLevel1];
//  if (cityComp != nil) {
//    stateComp = [aGeo country];
//    if (stateComp == nil) {
//      return result;
//    }
//    [result nappend:cityComp];
//    [result nappend:stateComp];
//    return result;
//  }
//  return result;
//}
//
//
//- (LjsGoogleAddressComponent *) bestComponentForCityInGeo:(LjsGoogleReverseGeocode *) aGeo {
//  LjsGoogleAddressComponent *result;
//  result = [aGeo sublocality];
//  if (result != nil) {
//    return result;
//  }
//  
//  result = [aGeo locality];
//  if (result != nil) {
//    return result;
//  }
//  
//  result = [aGeo administrativeAreaLevel1];
//  if (result != nil) {
//    return result;
//  }
//  
//  return nil;
//}
//
//- (LjsGoogleReverseGeocode *) bestGeocodeForCityStateInArray:(NSArray *) aArray {
//  LjsGoogleReverseGeocode *result;
//  result = [self geocodeWithSublocalityAddrCompInArray:aArray];
//  if (result != nil) {
//    return result;
//  }
//  
//  result = [self geocodeWithLocalityAddrCompInArray:aArray];
//  if (result != nil) {
//    return result;
//  }
//  
//  result = [self geocodeWithLevel1AddrCompInArray:aArray];
//  if (result != nil) {
//    return result;
//  }
//  
//  return nil;
//}
//
//- (NSUInteger) indexOfGeocodeWithAddrCompWithType:(NSString *) aType
//                                          inArray:(NSArray *) aArray {
//  NSUInteger index;
//  index = [aArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//    LjsGoogleReverseGeocode *geo = (LjsGoogleReverseGeocode *) obj;
//    return [geo containsAddrCompWithType:aType];
//  }];
//  return index;
//}
//
//- (LjsGoogleReverseGeocode *) geocodeWithSublocalityAddrCompInArray:(NSArray *) aArray {
//  LjsGoogleReverseGeocode *result = nil;
//  NSUInteger index = [self indexOfGeocodeWithAddrCompWithType:@"sublocality"
//                                                      inArray:aArray];
//  if (index != NSNotFound) {
//    result = [aArray nth:index];
//  }
//  return result;
//}
//
//- (LjsGoogleReverseGeocode *) geocodeWithLocalityAddrCompInArray:(NSArray *) aArray {
//  LjsGoogleReverseGeocode *result = nil;
//  NSUInteger index = [self indexOfGeocodeWithAddrCompWithType:@"locality"
//                                                      inArray:aArray];
//  if (index != NSNotFound) {
//    result = [aArray nth:index];
//  }
//  return result;
//}
//
//- (LjsGoogleReverseGeocode *) geocodeWithLevel1AddrCompInArray:(NSArray *) aArray {
//  LjsGoogleReverseGeocode *result = nil;
//  NSUInteger index = [self indexOfGeocodeWithAddrCompWithType:@"administrative_area_level_1"
//                                                      inArray:aArray];
//  if (index != NSNotFound) {
//    result = [aArray nth:index];
//  }
//  return result;
//}
//
//- (LjsGoogleReverseGeocode *) geocodeWithCountryAddrCompInArray:(NSArray *) aArray {
//  LjsGoogleReverseGeocode *result = nil;
//  NSUInteger index = [self indexOfGeocodeWithAddrCompWithType:@"country"
//                                                      inArray:aArray];
//  if (index != NSNotFound) {
//    result = [aArray nth:index];
//  }
//  return result;
//}
//
//
//
//
//
//- (NSString *) cityStateWithGeo:(LjsGoogleReverseGeocode *) aGeo {
//  NSString *city = nil;
//  NSString *state = nil;
//  
//  LjsGoogleAddressComponent *comp;
//  comp = [aGeo sublocality];
//  if (comp != nil) {
//    city = comp.longName;
//  }
//  
//  if (city == nil) {
//    comp = [aGeo locality];
//    if (comp != nil) {
//      city = comp.longName;
//    }
//  }
//  
//  if (city == nil) {
//    return nil;
//  }
//  
//  comp = [aGeo administrativeAreaLevel1];
//  if (comp != nil) {
//    state = comp.longName;
//  }
//  if (state == nil) {
//    return nil;    
//  }
//  return [NSString stringWithFormat:@"%@, %@", 
//          city, state];
//} 

@end






