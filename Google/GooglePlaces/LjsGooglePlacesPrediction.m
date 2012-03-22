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

#import "LjsGooglePlacesPrediction.h"
#import "Lumberjack.h"
#import "NSMutableArray+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSString *LjsGooglePlacesPredictionJsonKeyDescription = @"description";
static NSString *LjsGooglePlacesPredictionJsonKeyId = @"id";
static NSString *LjsGooglePlacesPredictionJsonKeyReference = @"reference";
static NSString *LjsGooglePlacesPredictionJsonKeyTerms = @"terms";
static NSString *LjsGooglePlacesPredictionJsonKeyTypes = @"types";
static NSString *LjsGooglePlacesPredictionJsonKeyMatchedSubstrings = @"matched_substrings";
static NSString *LjsGooglePlacesPredictionJsonKeyValue = @"value";
static NSString *LjsGooglePlacesPredictionJsonKeyOffset = @"offset";
static NSString *LjsGooglePlacesPredictionJsonKeyLength = @"length";

static NSString *LjsGooglePlacesPredictionTypeGeocode = @"geocode";
static NSString *LjsGooglePlacesPredictionTypeEstablishment = @"establishment";

@interface LjsGooglePlacesPrediction ()

@property (nonatomic, strong) NSDictionary *sourceDictionary;

- (NSRange) makeRangeWithDictionary:(NSDictionary *) aDictionary;
- (NSArray *) makeRangesWithArray:(NSArray *) aArray;
- (NSArray *) tokensWithTermsArray:(NSArray *) aArray;

@end

@implementation LjsGooglePlacesPrediction

@synthesize prediction;
@synthesize stablePlaceId;
@synthesize searchReferenceId;
@synthesize tokens;
@synthesize types;
@synthesize matchedRanges;
@synthesize sourceDictionary;


#pragma mark Memory Management
- (void) dealloc {
   DDLogDebug(@"deallocating %@", [self class]);
}

- (id) initWithDictionary:(NSDictionary *) aDictionary {
  //  [self doesNotRecognizeSelector:_cmd];
  self = [super init];
  if (self) {
    self.sourceDictionary = aDictionary;
    self.prediction = [aDictionary objectForKey:LjsGooglePlacesPredictionJsonKeyDescription];
    self.stablePlaceId = [aDictionary objectForKey:LjsGooglePlacesPredictionJsonKeyId];
    self.searchReferenceId = [aDictionary objectForKey:LjsGooglePlacesPredictionJsonKeyReference];
    self.types = [aDictionary objectForKey:LjsGooglePlacesPredictionJsonKeyTypes];
    
    NSArray *ranges = [aDictionary objectForKey:LjsGooglePlacesPredictionJsonKeyMatchedSubstrings];
    self.matchedRanges = [self makeRangesWithArray:ranges];
    
    NSArray *terms = [aDictionary objectForKey:LjsGooglePlacesPredictionJsonKeyTerms];
    self.tokens = [self tokensWithTermsArray:terms];
    
  }
  return self;
}

- (NSArray *) makeRangesWithArray:(NSArray *)aArray {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[aArray count]];
  for (NSDictionary *rangeDict in aArray) {
    NSRange range = [self makeRangeWithDictionary:rangeDict];
    NSString *str = NSStringFromRange(range);
    [result append:str];
  }
  
  return result;
}

- (NSRange) makeRangeWithDictionary:(NSDictionary *)aDictionary {
  NSNumber *offset = [aDictionary objectForKey:LjsGooglePlacesPredictionJsonKeyOffset];
  NSNumber *length = [aDictionary objectForKey:LjsGooglePlacesPredictionJsonKeyLength];
  return NSMakeRange([offset intValue],
                     [length intValue]);
}

- (NSArray *) tokensWithTermsArray:(NSArray *) aArray {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:[aArray count]];
  for (NSDictionary *termDict in aArray) {
    NSString *value = [termDict objectForKey:LjsGooglePlacesPredictionJsonKeyValue];
    [result append:value];
  }
  return result;
}

- (NSString *) description {
  return [NSString stringWithFormat:@"#<Prediction %@>", self.prediction];
}

@end
