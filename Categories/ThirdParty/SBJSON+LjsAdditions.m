// Copyright 2013 Little Joy Software. All rights reserved.
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

#import "SBJSON+LjsAdditions.h"
#import "Lumberjack.h"
#import "NSError+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation SBJsonParser (SBJSON_LjsAdditions)

- (id) objectWithString:(NSString *) aString
                  error:(NSError **) aError {
  id obj = [self objectWithString:aString];
  if (obj == nil) {
    if (aError != NULL) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:aString];
    }
  }
  return obj;
}

@end

#pragma mark - NSArray

@implementation NSArray (NSArray_SBJsonWriting)

- (NSString *) toJson:(NSError **) aError {
  SBJsonWriter *writer = [[SBJsonWriter alloc] init];
  NSString *json = [writer stringWithObject:self];
  if (json == nil) {
    DDLogDebug(@"error parsing %@ ==> %@", self, writer.error);
    if (aError != nil) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:writer.error];
    }
  }
  return json;
}

@end

@implementation NSDictionary (NSDictionary_SBJsonWriting)

- (NSString *) toJson:(NSError **) aError {
  SBJsonWriter *writer = [[SBJsonWriter alloc] init];
  NSString *json = [writer stringWithObject:self];
  if (json == nil) {
    DDLogDebug(@"error parsing %@ ==> %@", self, writer.error);
    if (aError != nil) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:writer.error];
    }
  }
  return json;
}

@end


@interface NSString (NSString_SBJsonParsing_Helper)

- (id) valueFromJson:(NSString **) aErrorMessage;

@end

@implementation NSString (NSString_SBJsonParsing_Helper)

- (id) valueFromJson:(NSString **) aErrorMessage {
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  id repr = [parser objectWithString:self];
  if (!repr) {
    DDLogDebug(@"error parsing %@ ==> %@", self, parser.error);
    if (aErrorMessage != nil) {
      *aErrorMessage = [NSString stringWithString:parser.error];
    }
  }
  return repr;
}

@end

@implementation NSString (NSString_SBJsonParsing)

- (NSArray *) arrayFromJson:(NSError **) aError {
  NSString *errorMsg = nil;
  id repr = [self valueFromJson:&errorMsg];
  if (repr == nil) {
    if (aError != nil) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:errorMsg];
    }
    return nil;
  }
  
  if ([repr respondsToSelector:@selector(objectAtIndex:)] == NO) {
    NSString *msg = @"could not create an array from self - am i a dictionary?";
    DDLogDebug(@"%@ ==> %@", msg, self);
    if (aError != nil) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:msg
                                userInfoObject:self
                                   userInfoKey:@"self"];
    }
    return nil;
  }
  return (NSArray *) repr;
}

- (NSDictionary *) dictionaryFromJson:(NSError **) aError {
  NSString *errorMsg = nil;
  id repr = [self valueFromJson:&errorMsg];
  if (repr == nil) {
    if (aError != nil) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:errorMsg];
    }
    return nil;
  }
  
  if ([repr respondsToSelector:@selector(objectForKey:)] == NO) {
    NSString *msg = @"could not create a dictionary from self - am i an array?";
    DDLogDebug(@"%@ ==> %@", msg, self);
    if (aError != nil) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:msg
                                userInfoObject:self
                                   userInfoKey:@"self"];
    }
    return nil;
  }
  return (NSDictionary *) repr;
}

@end


@interface NSData (NSData_SBJsonParsing_Helper)

- (id) valueFromJson:(NSString **) aErrorMessage;

@end

@implementation NSData (NSData_SBJsonParsing_Helper)

- (id) valueFromJson:(NSString **) aErrorMessage {
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  id repr = [parser objectWithData:self];
  if (!repr) {
    DDLogDebug(@"error parsing: %@", parser.error);
    if (aErrorMessage != nil) {
      *aErrorMessage = [NSString stringWithString:parser.error];
    }
  }
  return repr;
}

@end


@implementation NSData (NSData_SBJsonParsing)

- (NSArray *) arrayFromJson:(NSError **) aError {
  NSString *errorMsg = nil;
  id repr = [self valueFromJson:&errorMsg];
  if (repr == nil) {
    if (aError != nil) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:errorMsg];
    }
    return nil;
  }
  
  if ([repr respondsToSelector:@selector(objectAtIndex:)] == NO) {
    NSString *msg = @"could not create an array from self (NSData) - do i represent a dictionary?";
    DDLogDebug(@"%@", msg);
    if (aError != nil) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:msg];
    }
    return nil;
  }
  return (NSArray *) repr;
}

- (NSDictionary *) dictionaryFromJson:(NSError **) aError {
  NSString *errorMsg = nil;
  id repr = [self valueFromJson:&errorMsg];
  if (repr == nil) {
    if (aError != nil) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:errorMsg];
    }
    return nil;
  }
  
  if ([repr respondsToSelector:@selector(objectForKey:)] == NO) {
    NSString *msg = @"could not create a dictionary from self (NSData) - do i represent an array?";
    DDLogDebug(@"%@", msg);
    if (aError != nil) {
      *aError = [LjsErrorFactory errorWithCode:1
                          localizedDescription:msg];
    }
    return nil;
  }
  return (NSDictionary *) repr;
}

@end

