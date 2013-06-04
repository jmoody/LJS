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


#import <Foundation/Foundation.h>


/**
 NSString on NSString_LjsAdditions category.
 */
@interface NSString (NSString_LjsAdditions)

/** @name Task Section */

// ugh - these suck
//- (BOOL) emptyp;
//+ (BOOL) stringIsEmptyP:(NSString *) aString;

// would like to use empty or emptyp, but i want these to return true when
// called on nil objects
- (BOOL) not_empty;
- (BOOL) has_chars;


#pragma mark - compare (inner band)

// https://github.com/ZaBlanc/InnerBand
- (NSComparisonResult) diacriticInsensitiveCaseInsensitiveSort:(NSString *)rhs;
// https://github.com/ZaBlanc/InnerBand
- (NSComparisonResult) diacriticInsensitiveSort:(NSString *)rhs;
// https://github.com/ZaBlanc/InnerBand
- (NSComparisonResult) caseInsensitiveSort:(NSString *)rhs;
// https://github.com/ZaBlanc/InnerBand
- (NSString *)trimmed;

- (NSString *) stringByEscapingDoubleQuotes;
- (NSString *) stringByUnescapingDoubleQuotes;

/**
 @return a new string based on the receiver with a ':' on the front
 like Lisp make-keyword
 */
- (NSString *) makeKeyword;

// http://mobiledevelopertips.com/cocoa/truncate-an-nsstring-and-append-an-ellipsis-respecting-the-font-size.html
#if TARGET_OS_IPHONE
- (NSString *) stringByTruncatingToWidth:(CGFloat) width 
                                withFont:(UIFont *) font;
#endif


@end
