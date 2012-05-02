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

#import "LjsFaker.h"
#import "Lumberjack.h"
#import "NSArray+LjsAdditions.h"
#import "LjsFileUtilities.h"
#import "LjsVariates.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


/*
 com.littlejoysoftware.faker.addresses.us.plist
 com.littlejoysoftware.faker.cities.us.plist
 
 com.littlejoysoftware.faker.given-names.us.plist
 com.littlejoysoftware.faker.occupations.us.plist
 com.littlejoysoftware.faker.phone-numbers.us.plist
 com.littlejoysoftware.faker.postal-codes.us.plist
 com.littlejoysoftware.faker.surnames-names.us.plist
 */

static NSString *LjsFakerCompaniesUSplist = @"com.littlejoysoftware.faker.companies.us.plist";
static NSString *LjsFakerStreetAddressesUSplist = @"com.littlejoysoftware.faker.street-addresses.us.plist";
static NSString *LjsFakerCitiesUSplist = @"com.littlejoysoftware.faker.cities.us.plist";


@interface LjsFaker ()

@property (nonatomic, strong) NSArray *firstNames;
@property (nonatomic, strong) NSArray *lastNames;
@property (nonatomic, strong) NSArray *domainNames;

@property (nonatomic, strong) NSArray *companiesUS;
@property (nonatomic, strong) NSArray *streetAddresesUS;
@property (nonatomic, strong) NSArray *citiesUS;
@property (nonatomic, strong) NSDictionary *statesDictUS;

- (NSString *) pathWithFilename:(NSString *) aFilename;
- (NSString *) capitialize:(NSString *) aString;
+ (NSDictionary *) dictionaryOfStatesToAbbreviations;

@end

@implementation LjsFaker

@synthesize firstNames;
@synthesize lastNames;
@synthesize domainNames;
@synthesize companiesUS;
@synthesize streetAddresesUS;
@synthesize citiesUS;
@synthesize statesDictUS;

#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
}

- (id) init {
  self = [super init];
  if (self) {
    self.firstNames = nil;
    self.lastNames = nil;
    self.domainNames = nil;
    self.companiesUS = nil;
    self.streetAddresesUS = nil;
    self.citiesUS = nil;
    self.statesDictUS = [LjsFaker dictionaryOfStatesToAbbreviations];
  }
  return self;
}


- (NSString *) capitialize:(NSString *)aString {
  return [[aString lowercaseString] capitalizedString];
}

- (NSString *) firstName {
  if (self.firstNames == nil) {
    NSString *path = [self pathWithFilename:@"com.littlejoysoftware.faker.us-census-firstnames.plist"];
    self.firstNames = [LjsFileUtilities readArrayFromFile:path
                                                    error:nil];
  }
  NSString *first = [LjsVariates randomElement:self.firstNames];
  return [self capitialize:first];
}

- (NSString *) lastName {
  if (self.lastNames == nil) {
    NSString *path = [self pathWithFilename:@"com.littlejoysoftware.faker.us-census-surnames.plist"];
    self.lastNames = [LjsFileUtilities readArrayFromFile:path error:nil];
  }
  NSString *last = [LjsVariates randomElement:self.lastNames];
  return [self capitialize:last];
}

- (NSString *) name {
  return [NSString stringWithFormat:@"%@ %@",
          [self firstName], [self lastName]];
}

- (NSString *) websiteWithHttp:(BOOL) aIncludeHttp
                       escaped:(BOOL) aPercentEscape {
  if (self.domainNames == nil) {
    NSString *path = [self pathWithFilename:@"com.littlejoysoftware.faker.domain-names.plist"];
    self.domainNames = [LjsFileUtilities readArrayFromFile:path
                                                     error:nil];
  }
  NSString *random = [LjsVariates randomElement:self.domainNames];
  if (aIncludeHttp == YES) {
    random = [NSString stringWithFormat:@"http://%@", random];
  }
  
  if (aPercentEscape == YES) {
    random = [random stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  }
  return random;
}

- (NSString *) pathWithFilename:(NSString *) aFilename {
  NSBundle *main = [NSBundle mainBundle];
  NSString *resourcePath = [main resourcePath];
  return [resourcePath stringByAppendingPathComponent:aFilename];
}


- (NSString *) company {
  if (self.companiesUS == nil) {
    NSString *path = [self pathWithFilename:LjsFakerCompaniesUSplist];
    self.companiesUS = [LjsFileUtilities readArrayFromFile:path
                                                     error:nil];
  }
  return [LjsVariates randomElement:self.companiesUS];
}

- (NSString *) city {
  if (self.citiesUS == nil) {
    NSString *path = [self pathWithFilename:LjsFakerCitiesUSplist];
    self.citiesUS = [LjsFileUtilities readArrayFromFile:path
                                                  error:nil];
    
  }
  return [LjsVariates randomElement:self.citiesUS];
}

- (NSString *) streetAddress {
  if (self.streetAddresesUS == nil) {
    NSString *path = [self pathWithFilename:LjsFakerStreetAddressesUSplist];
    self.streetAddresesUS = [LjsFileUtilities readArrayFromFile:path
                                                          error:nil];
  }
  return [LjsVariates randomElement:self.streetAddresesUS];
}

- (NSString *) state:(BOOL) abbrevated {
  NSString *state = [LjsVariates randomElement:[self.statesDictUS allKeys]];
  if (abbrevated == NO) {
    state = [self.statesDictUS objectForKey:state];
  }
  
  return state;
}


+ (NSDictionary *) dictionaryOfStatesToAbbreviations {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          @"Alabama",@"AL",
          @"Alaska",@"AK",
          @"Arizona",@"AZ",
          @"Arkansas",@"AR",
          @"California",@"CA",
          @"Colorado",@"CO",
          @"Connecticut",@"CT",
          @"Delaware",@"DE",
          @"District of Columbia",@"DC",
          @"Florida",@"FL",
          @"Georgia",@"GA",
          @"Hawaii",@"HI",
          @"Idaho",@"ID",
          @"Illinois",@"IL",
          @"Indiana",@"IN",
          @"Iowa",@"IA",
          @"Kansas",@"KS",
          @"Kentucky",@"KY",
          @"Louisiana",@"LA",
          @"Maine",@"ME",
          @"Montana",@"MT",
          @"Nebraska",@"NE",
          @"Nevada",@"NV",
          @"New Hampshire",@"NH",
          @"New Jersey",@"NJ",
          @"New Mexico",@"NM",
          @"New York",@"NY",
          @"North Carolina",@"NC",
          @"North Dakota",@"ND",
          @"Ohio",@"OH",
          @"Oklahoma",@"OK",
          @"Oregon",@"OR",
          @"Maryland",@"MD",
          @"Massachusetts",@"MA",
          @"Michigan",@"MI",
          @"Minnesota",@"MN",
          @"Mississippi",@"MS",
          @"Missouri",@"MO",
          @"Pennsylvania",@"PA",
          @"Rhode Island",@"RI",
          @"South Carolina",@"SC",
          @"South Dakota",@"SD",
          @"Tennessee",@"TN",
          @"Texas",@"TX",
          @"Utah",@"UT",
          @"Vermont",@"VT",
          @"Virginia",@"VA",
          @"Washington",@"WA",
          @"West Virginia",@"WV",
          @"Wisconsin",@"WI",
          @"Wyoming",@"WY", nil];
}

@end