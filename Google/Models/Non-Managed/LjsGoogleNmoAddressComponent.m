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

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleNmoAddressComponent.h"
#import "Lumberjack.h"
#import "LjsValidator.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleNmoAddressComponent

@synthesize longName;
@synthesize shortName;
@synthesize types;

#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating %@", [self class]);
}

- (id) initWithDictionary:(NSDictionary *)aDictionary {
  self = [super init];
  if (self) {
    NSArray *keys = [NSArray arrayWithObjects:@"long_name", @"short_name", @"types", nil];
    BOOL valid;
    valid = [LjsValidator dictionary:aDictionary containsKeys:keys allowsOthers:YES];
    if (valid == NO) {
      DDLogWarn(@"dictionary: %@ must contain keys %@ - returning nil", aDictionary, keys);
      return nil;
    }
    
    for (NSString *key in [[keys reverse] rest]) {
      NSString *value = [aDictionary objectForKey:key];
      valid = [LjsValidator stringIsNonNilAndNotEmpty:value];
      if (valid == NO) {
        DDLogWarn(@"@< %@ > must be non-nil and non-empty - returning nil", value);
        return nil;
      }
    }
    
    self.longName = [aDictionary objectForKey:@"long_name"];
    self.shortName = [aDictionary objectForKey:@"short_name"];
    self.types = [aDictionary objectForKey:@"types"];
    
    if (self.types == nil || [self.types count] == 0) {
      return nil;
    }
  }
  return self;
}

/*
- (BOOL) isStreetNumber {
  return [LjsValidator array:self.types containsString:@"street_number"];
}

- (BOOL) isRoute {
  return [LjsValidator array:self.types containsString:@"route"];
}

- (BOOL) isLocality {
  return [LjsValidator array:self.types containsString:@"locality"];
}

- (BOOL) isAdministrativeArea1 {
  return [LjsValidator array:self.types containsString:@"administrative_area_level_1"];
}

- (BOOL) isAdministrativeArea2 {
  return [LjsValidator array:self.types containsString:@"administrative_area_level_2"];
}

- (BOOL) isCountry {
  return [LjsValidator array:self.types containsString:@"country"];
}

- (BOOL) isPostalCode {
  return [LjsValidator array:self.types containsString:@"postal_code"];
}
 */

- (NSString *) description {
  return [NSString stringWithFormat:@"#<Address Component:  %@ (%@) - [%@]>",
          self.longName, self.shortName, [self.types componentsJoinedByString:@","]];
}

@end
