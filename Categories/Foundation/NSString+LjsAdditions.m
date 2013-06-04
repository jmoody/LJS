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

// several selectors from https://github.com/ZaBlanc/InnerBand
//
//  NSString+InnerBand.m
//  InnerBand
//
//  InnerBand - The iOS Booster!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


static NSString *const ellipsis = @"...";

@implementation NSString (NSString_LjsAdditions)


- (BOOL) not_empty {
  return [self length] != 0;
}

- (BOOL) has_chars {
  return [self length] != 0;
}

// https://github.com/ZaBlanc/InnerBand
- (NSComparisonResult) diacriticInsensitiveCaseInsensitiveSort:(NSString *)rhs {
	return [self compare:rhs options:NSDiacriticInsensitiveSearch | 
          NSCaseInsensitiveSearch];	
}

// https://github.com/ZaBlanc/InnerBand
- (NSComparisonResult) diacriticInsensitiveSort:(NSString *)rhs {
	return [self compare:rhs options:NSDiacriticInsensitiveSearch];	
}

// https://github.com/ZaBlanc/InnerBand
- (NSComparisonResult) caseInsensitiveSort:(NSString *)rhs {
	return [self compare:rhs options:NSCaseInsensitiveSearch];	
}

// https://github.com/ZaBlanc/InnerBand
- (NSString *)trimmed {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) makeKeyword {
  if ([self has_chars] == NO) { return nil; }
  
  NSString *firstChar = [self substringToIndex:1];
  BOOL noSpaces = [self rangeOfString:@" "].location == NSNotFound;
  if ([firstChar isEqualToString:@":"] && noSpaces) {
    return self;
  }

  NSString *trimmed = [[self trimmed] stringByReplacingOccurrencesOfString:@":"
                                                                withString:@""];


  NSArray *tokens = [trimmed componentsSeparatedByString:@" "];
  NSPredicate *prd = [NSPredicate predicateWithBlock:^BOOL(NSString *str,
                                                           NSDictionary *bindings) {
    return [str has_chars];
  }];
  
  tokens = [tokens filteredArrayUsingPredicate:prd];
  NSString *squeezed = [tokens componentsJoinedByString:@"-"];
  
  firstChar = [squeezed substringToIndex:1];
  return [firstChar isEqualToString:@":"] ? squeezed :
  [NSString stringWithFormat:@":%@", squeezed];
}


- (NSString *) stringByEscapingDoubleQuotes {
  NSMutableString *mutable = [self mutableCopy];
  
  [mutable replaceOccurrencesOfString:@"\""
                           withString:@"\\\""
                              options:NSCaseInsensitiveSearch 
                              range:NSMakeRange(0, [mutable length])];
  return [NSString stringWithString:mutable];
}

- (NSString *) stringByUnescapingDoubleQuotes {
  NSMutableString *mutable = [self mutableCopy];
  
  [mutable replaceOccurrencesOfString:@"\\"
                           withString:@"\""
                              options:NSCaseInsensitiveSearch 
                                range:NSMakeRange(0, [mutable length])];
  return [NSString stringWithString:mutable];
}


#if TARGET_OS_IPHONE
- (NSString *) stringByTruncatingToWidth:(CGFloat) width withFont:(UIFont *) font {
  // Create copy that will be the returned result
  NSMutableString *truncatedString = [self mutableCopy];
  
  // Make sure string is longer than requested width
  if ([self sizeWithFont:font].width > width) {
    // Accommodate for ellipsis we'll tack on the end
    width -= [ellipsis sizeWithFont:font].width;
    
    // Get range for last character in string
    NSRange range = {truncatedString.length - 1, 1};
    
    // Loop, deleting characters until string fits within width
    while ([truncatedString sizeWithFont:font].width > width) {
      // Delete character at end
      [truncatedString deleteCharactersInRange:range];
      
      // Move back another character
      range.location--;
    }
    
    // Append ellipsis
    [truncatedString replaceCharactersInRange:range withString:ellipsis];
  }
  return truncatedString;
}
#endif

@end
