// Copyright 2012 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
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

#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif



@implementation NSString (NSString_LjsWebCategories)

- (NSString *) stringByEncodingForUrl {
  NSMutableString * output = [NSMutableString string];
  const unsigned char * source = (const unsigned char *)[self UTF8String];
  unsigned long sourceLen = strlen((const char *)source);
  for (unsigned long i = 0; i < sourceLen; ++i) {
    const unsigned char thisChar = source[i];
    if (thisChar == ' '){
      [output appendString:@"+"];
    } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' || 
               (thisChar >= 'a' && thisChar <= 'z') ||
               (thisChar >= 'A' && thisChar <= 'Z') ||
               (thisChar >= '0' && thisChar <= '9')) {
      [output appendFormat:@"%c", thisChar];
    } else {
      [output appendFormat:@"%%%02X", thisChar];
    }
  }
  return output;
}

@end

@implementation NSDictionary (NSDictionary_LjsWebCategories)

- (NSString *) stringByParameterizingForUrl {
  NSMutableArray *parameters = [NSMutableArray array];
  NSArray *keys = [self allKeys];
  NSArray *sorted = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    NSString *first = (NSString *) obj1;
    NSString *second = (NSString *) obj2;
    return [first compare:second];
  }];
  
  for (NSString *key in sorted) {
    NSString *escapedk = [key stringByEncodingForUrl];
    NSString *v = [[self objectForKey:key] isKindOfClass:[NSString class]] ? [self objectForKey:key] : [[self objectForKey:key] stringValue];
    NSString *escapedv = [v stringByEncodingForUrl];
    [parameters addObject:[NSString stringWithFormat:@"%@=%@", escapedk, escapedv]];
  }
  
  NSString *query = [parameters count] > 0 ? @"?" : @"";
  query = [query stringByAppendingString:[parameters componentsJoinedByString:@"&"]];
  return query;
}

@end
