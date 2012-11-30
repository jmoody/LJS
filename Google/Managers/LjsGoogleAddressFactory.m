// Copyright 2012 nUCROSOFT. All rights reserved.
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

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleAddressFactory.h"
#import "Lumberjack.h"
#import "LjsGoogleAddressComponentType.h"
#import "LjsGoogleAddressComponent.h"
#import "LjsGooglePlace.h"
#import "LjsGoogleReverseGeocode.h"
#import "NSArray+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


@interface LjsGoogleAddressFactory ()

@property (nonatomic, strong) NSArray *components;

- (id) initWithComponents:(NSSet *) aAddressComponents;
- (NSUInteger) indexOfComponentWithType:(NSString *) aType;
//- (NSUInteger) indexOfComponentWithType:(NSString *) aType
//                           longNameLike:(NSString *) aString;
//- (BOOL) containsAddrCompWithType:(NSString *) aType;

- (LjsGoogleAddressComponent *) componentWithType:(NSString *) aType;
- (LjsGoogleAddressComponent *) sublocality;
- (LjsGoogleAddressComponent *) locality;
- (LjsGoogleAddressComponent *) administrativeAreaLevel1;
- (LjsGoogleAddressComponent *) administrativeAreaLevel2;
- (LjsGoogleAddressComponent *) administrativeAreaLevel3;

- (LjsGoogleAddressComponent *) country;


//- (LjsGoogleAddressComponent *) componentWithType:(NSString *)aType 
//                                       searchTerm:(NSString *) aSearchTerm;
//- (LjsGoogleAddressComponent *) sublocalityWithSearchTerm:(NSString *) aSearchTerm;
//- (LjsGoogleAddressComponent *) localityWithSearchTerm:(NSString *) aSearchTerm;
//- (LjsGoogleAddressComponent *) administrativeAreaLevel1WithSearchTerm:(NSString *) aSearchTerm;
//- (LjsGoogleAddressComponent *) countryWithSearchTerm:(NSString *) aSearchTerm;
- (LjsGoogleAddressComponent *) bestComponentForState;
- (LjsGoogleAddressComponent *) bestComponentForCity;



@end

@implementation LjsGoogleAddressFactory
@synthesize components;

#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
}

- (id) init {
  [self doesNotRecognizeSelector:_cmd];
  return  nil;
}

- (id) initWithComponents:(NSSet *)aAddressComponents {
  self = [super init];
  if (self) {
    self.components = [aAddressComponents allObjects];
  }
  return self;
}

- (id) initWithPlace:(LjsGooglePlace *) aPlace {
  return [self initWithComponents:aPlace.addressComponents];
}

- (id) initWithReverseGeocode:(LjsGoogleReverseGeocode *) aGeocode {
  return [self initWithComponents:aGeocode.addressComponents];
}



- (NSUInteger) indexOfComponentWithType:(NSString *)aType {
  NSUInteger index;
  index = [self.components indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    LjsGoogleAddressComponent *comp = (LjsGoogleAddressComponent *) obj;
    return [comp hasTypeWithName:aType];
  }];
  return index;
}

- (LjsGoogleAddressComponent *) componentWithType:(NSString *) aType {
  LjsGoogleAddressComponent *result = nil;
  NSUInteger index = [self indexOfComponentWithType:aType];
  if (index != NSNotFound) {
    result = [self.components nth:index];
  }
  return result;
}

- (LjsGoogleAddressComponent *) sublocality {
  return [self componentWithType:@"sublocality"];
}

- (LjsGoogleAddressComponent *) locality {
  return [self componentWithType:@"locality"];
}

- (LjsGoogleAddressComponent *) administrativeAreaLevel1 {
  return [self componentWithType:@"administrative_area_level_1"];
}

- (LjsGoogleAddressComponent *) administrativeAreaLevel2 {
  return [self componentWithType:@"administrative_area_level_2"];
}

- (LjsGoogleAddressComponent *) administrativeAreaLevel3 {
  return [self componentWithType:@"administrative_area_level_3"];
}



- (LjsGoogleAddressComponent *) country {
  return [self componentWithType:@"country"];
}


- (LjsGoogleAddressComponent *) bestComponentForState {
  LjsGoogleAddressComponent *result;
  
  result = [self administrativeAreaLevel1];
  if (result != nil) {
    return  result;
  }
  
  result = [self administrativeAreaLevel2];
  if (result != nil) {
    return result;
  }
  
  result = [self administrativeAreaLevel3];
  if (result != nil) {
    return result;
  }
  
  result = [self locality];
  if (result != nil) {
    return result;
  }
  
  return nil;
}

- (LjsGoogleAddressComponent *) bestComponentForCity {
  LjsGoogleAddressComponent *result;
  result = [self sublocality];
  if (result != nil) {
    return result;
  }
  
  result = [self locality];
  if (result != nil) {
    return result;
  }
  
  result = [self administrativeAreaLevel3];
  if (result != nil) {
    return result;
  }
  
  result = [self administrativeAreaLevel2];
  if (result != nil) {
    return result;
  }
  return nil;
}

- (NSString *) bestCityStateString {
  LjsGoogleAddressComponent *city = [self bestComponentForCity];
  LjsGoogleAddressComponent *state = [self bestComponentForState];
  
  if (city == nil && state == nil) {
    return nil;
  }
  
  
  if ((city == nil && state != nil) || (city != nil && state == nil)) {
    if (city == nil && state != nil) {
      city = state;
      state = [self country];
    }
    
    if (city != nil && state == nil) {
      state = [self country];
    }
    
    if (state != nil) {
      return [NSString stringWithFormat:@"%@, %@", city.longName, state.shortName];
    } else {
      return [NSString stringWithFormat:@"%@", city.longName];
    }
  }
  
  if (city != nil && state != nil) {
    NSString *cityLn = city.longName;
    NSString *stateLn = state.longName;
    if ([cityLn isEqualToString:stateLn]) {
      state = city;
      state = [self country];
      if (state != nil) {
        return [NSString stringWithFormat:@"%@, %@", city.longName, state.shortName];
      } else {
        return [NSString stringWithFormat:@"%@", city.longName];
      }
    } else {
      return [NSString stringWithFormat:@"%@, %@", city.longName, state.shortName];
    }
  }
  
  DDLogError(@"should never reach here");
  return nil;
  
}

@end
