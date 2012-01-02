// Copyright 2011 The Little Joy Software Company. All rights reserved.
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

#import "LjsValidator.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsValidator

+ (BOOL) string:(NSString *) aString containsOnlyMembersOfCharacterSet:(NSCharacterSet *) aCharacterSet {
  BOOL result;
  if (aCharacterSet == nil) {
    DDLogError(@"the character set was nil - returning NO");
    result = NO;
  } else {
    if (aString != nil && [aString length] > 0) {
      NSCharacterSet *inverted = [aCharacterSet invertedSet];
      NSArray *array = [aString componentsSeparatedByCharactersInSet:inverted];
      result = [array count] == 1;
    } else {
      DDLogWarn(@"the string was nil or empty - return NO");
      result = NO;
    }
  }
  return result;
}

+ (BOOL) stringContainsOnlyAlphaNumeric:(NSString *) aString {
  BOOL result = NO;
  if (aString != nil && [aString length] > 0) {
    NSCharacterSet *alphaNumeric = [NSCharacterSet alphanumericCharacterSet];
    result = [LjsValidator string:aString containsOnlyMembersOfCharacterSet:alphaNumeric];
    
  }
  return result;
}


+ (BOOL) stringContainsOnlyNumbers:(NSString *) aString {
  BOOL result = NO;
  if (aString != nil && [aString length] > 0) {
    NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
    result = [LjsValidator string:aString containsOnlyMembersOfCharacterSet:decimalSet];
  }
  return result;
}

+ (BOOL) isDictionary:(id) value {
  return [value respondsToSelector:@selector(objectForKey:)];
}

+ (BOOL) isArray:(id)value {
  return [value respondsToSelector:@selector(objectAtIndex:)];
}

+ (BOOL) isString:(id) value {
  return [value respondsToSelector:@selector(componentsSeparatedByString:)];
}

+ (BOOL) array:(NSArray *) aArray hasCount:(NSUInteger) aCount {
  return [aArray count] == aCount;
}

+ (BOOL) array:(NSArray *) aArray containsString:(NSString *) aString {
  return [aArray containsObject:aString];
}

+ (BOOL) array:(NSArray *) aArray containsStrings:(NSSet *) aSetOfStrings {
  return [LjsValidator array:aArray containsStrings:aSetOfStrings allowsOthers:YES];
}

+ (BOOL) array:(NSArray *) aArray containsStrings:(NSSet *) aSetOfStrings
  allowsOthers:(BOOL) aAllowsOthers {
  
  if (aArray == nil || aSetOfStrings == nil) {
    return NO;
  }
  
  for (NSString *lhs in aSetOfStrings) {
    if ([LjsValidator array:aArray containsString:lhs] == NO) {
      return NO;
    } 
  }
  
  if (aAllowsOthers == NO) {
    NSSet *nodups = [NSSet setWithArray:aArray];
    if ([nodups count] != [aSetOfStrings count]) {
      return NO;
    }
  }
  
  return YES;
}


+ (BOOL) dictionary:(NSDictionary *) dictionary containsKey:(NSString *) key {
  return [dictionary objectForKey:key] != nil;
}

+ (BOOL) dictionary:(NSDictionary *) dictionary containsKeys:(NSArray *)keys {
  BOOL result = YES;
  for (NSString *key in keys) {
    if (![LjsValidator dictionary:dictionary containsKey:key]) {
      result = NO;
      break;
    }
  }
  return result;
}


+ (BOOL) dictionary:(NSDictionary *)dictionary 
       containsKeys:(NSArray *) keys
       allowsOthers:(BOOL) allowsOthers {
  BOOL result;
  if (allowsOthers == NO) {
    result = ([keys count] == [[dictionary allKeys] count] &&
              [LjsValidator dictionary:dictionary
                          containsKeys:keys]);
  } else {
    result = [LjsValidator dictionary:dictionary containsKeys:keys];
  }
  return result;
}


+ (BOOL) isValidEmail:(NSString *)checkString {
  BOOL stricterFilter = YES;
  NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}

@end
