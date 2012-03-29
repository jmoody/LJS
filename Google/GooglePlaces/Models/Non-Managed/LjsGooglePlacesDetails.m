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

#import "LjsGooglePlacesDetails.h"
#import "Lumberjack.h"
#import "LjsLocationManager.h"
#import "LjsGoogleGlobals.h"
#import "LjsGooglePlacesNmoAddressComponent.h"
#import "NSMutableArray+LjsAdditions.h"
#import "LjsGooglePlacesNmoAttribution.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGooglePlacesDetails

@synthesize addressComponents;
@synthesize formattedAddress;
@synthesize formattedPhoneNumber;
@synthesize internationalPhoneNumber;
@synthesize location;
@synthesize rating;
@synthesize icon;
@synthesize name;
@synthesize mapUrl;
@synthesize vicinity;
@synthesize website;
@synthesize attributions;

#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
}

- (id) initWithDictionary:(NSDictionary *)aDictionary {
  self = [super initWithDictionary:aDictionary];
  if (self) {
    self.formattedAddress = [aDictionary objectForKey:@"formatted_address"];
    self.formattedPhoneNumber = [aDictionary objectForKey:@"formatted_phone_number"];
    self.internationalPhoneNumber = [aDictionary objectForKey:@"international_phone_number"];
    self.name = [aDictionary objectForKey:@"name"];
    self.mapUrl = [aDictionary objectForKey:@"url"];
    self.vicinity = [aDictionary objectForKey:@"vicinity"];
    self.website = [aDictionary objectForKey:@"website"];
    self.icon = [aDictionary objectForKey:@"icon"];
    NSNumber *ratingNum = [aDictionary objectForKey:@"rating"];
    if (ratingNum == nil) {
      rating = LjsGoogleFloatNotFound;
    } else {
      rating = [ratingNum doubleValue];
    }
    NSDictionary *geometry = [aDictionary objectForKey:@"geometry"];
    if (geometry == nil) {
      location = CGPointMake(LjsLocationDegreesNotFound, LjsLocationDegreesNotFound);
    } else {
      NSDictionary *locDict = [geometry objectForKey:@"location"];
      if (locDict == nil) {
        location = CGPointMake(LjsLocationDegreesNotFound, LjsLocationDegreesNotFound);
      } else {
        NSNumber *latNum = [locDict objectForKey:@"lat"];
        NSNumber *longNum = [locDict objectForKey:@"lng"];
        location = CGPointMake([latNum doubleValue], [longNum doubleValue]);
      }
    }
    
    NSArray *components = [aDictionary objectForKey:@"address_components"];
    NSMutableArray *marray = [NSMutableArray arrayWithCapacity:[components count]];
    LjsGooglePlacesNmoAddressComponent *comp;
    for (NSDictionary *compDict in components) {
      comp = [[LjsGooglePlacesNmoAddressComponent alloc]
              initWithDictionary:compDict];
      [marray nappend:comp];
    }
    self.addressComponents = [NSArray arrayWithArray:marray];
    
    NSArray *html = [aDictionary objectForKey:@"html_attributions"];
    marray = [NSMutableArray arrayWithCapacity:[html count]];
    for (NSString *str in html) {
      LjsGooglePlacesNmoAttribution *attr;
      attr = [[LjsGooglePlacesNmoAttribution alloc] initWithHtml:str];
      [marray nappend:attr];
    }
    self.attributions = [NSArray arrayWithArray:marray];
  }
  return self;
}

- (NSString *) description {
  return [NSString stringWithFormat:@"#<Place Details:  %@ - [%@]>",
          self.name, [self.types componentsJoinedByString:@","]];
}


@end
