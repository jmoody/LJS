// Copyright (c) 2010 Little Joy Software
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
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsJsonRpcReply.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *LjsJsonRpcReplyErrorDomain = @"com.littlejoysoftware.JSON-RPC";

NSString *LjsJsonJsonRpcKey = @"jsonrpc";
NSString *LjsJsonJsonRpcRequiredVersion = @"2.0";
NSString *LjsJsonReplyErrorKey = @"error";
NSString *LjsJsonRpcReplyIdKey = @"id";
NSString *LjsJsonRpcReplyResultKey = @"result";

NSString *LjsJsonRpcReplyErrorMessageKey = @"message";


#ifdef JSON_RPC_10
NSString *LjsJsonRpcReplyErrorCodeOrNameKey = @"name";
NSString *LjsJsonRpcReplyErrorDataOrErrorsKey = @"errors";
#else
NSString *LjsJsonRpcReplyErrorCodeOrNameKey = @"code";
NSString *LjsJsonRpcReplyErrorDataOrErrorsKey = @"data";
#endif


NSInteger const LjsJsonRpcReplyMissingId = -17;


NSString *LjsJsonRpcReplyErrorDataUserInfoKey = @"com.littlejoysoftware.ljs.JsonRpcAdditionalErrorsUserInfoKey";


@implementation LjsJsonRpcReply

@synthesize errorFoundInReply;
@synthesize jsonParseError;
@synthesize jsonRpcFormatError;
@synthesize parser;
@synthesize replyDict;

#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
}

- (id) initWithJsonReply:(NSString *)json {
  self = [super init];
  if (self != nil) {
    SBJsonParser *aParser = [[SBJsonParser alloc] init];
    self.parser = aParser;

    NSError *tmpParseError = nil;
    self.replyDict = [self.parser objectWithString:json error:&tmpParseError];
    self.jsonParseError = tmpParseError;
    if ([self replyWasValidJson] && [self replyWasValidRpc] && [self replyHasRpcError]) {
      NSDictionary *errorDict = [self.replyDict objectForKey:LjsJsonReplyErrorKey];
      self.errorFoundInReply = [self errorWithDictionary:errorDict];
    } else {
      self.errorFoundInReply = nil;
    }
    
    // IMPORTANT
    // since the replyWasValidRpc method is so tedious, I decide to populate
    // self.rpcFormatError as a side effect of calling [self replyWasValuedRpc]
  
  }
  return self;
}

#ifdef JSON_RPC_10
- (NSError *) errorWithDictionary:(NSDictionary *) errorDict {
  NSString *message = [errorDict objectForKey:LjsJsonRpcReplyErrorMessageKey];
  NSString *codeStr = [errorDict objectForKey:LjsJsonRpcReplyErrorCodeOrNameKey];
  NSInteger code = [codeStr integerValue];
  NSArray *data = [errorDict objectForKey:LjsJsonRpcReplyErrorDataOrErrorsKey];
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  if (data != nil) {
    [userInfo setObject:data forKey:LjsJsonRpcReplyErrorDataUserInfoKey];
  }
  
  [userInfo setObject:message forKey:NSLocalizedDescriptionKey];
  
  NSError *error = [NSError errorWithDomain:LjsJsonRpcReplyErrorDomain
                                       code:code
                                   userInfo:userInfo];
  return error;
}

#else
- (NSError *) errorWithDictionary:(NSDictionary *) errorDict {
  NSString *message = [errorDict objectForKey:LjsJsonRpcReplyErrorMessageKey];
  NSString *codeStr = [errorDict objectForKey:LjsJsonRpcReplyErrorCodeOrNameKey];
  NSInteger code = [codeStr integerValue];
  NSString *data = [errorDict objectForKey:LjsJsonRpcReplyErrorDataOrErrorsKey];
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  if (data != nil) {
    [userInfo setObject:data forKey:LjsJsonRpcReplyErrorDataUserInfoKey];
  }
  
  [userInfo setObject:message forKey:NSLocalizedDescriptionKey];
  
  NSError *error = [NSError errorWithDomain:LjsJsonRpcReplyErrorDomain
                                       code:code
                                   userInfo:userInfo];
  return error;
}

#endif


- (BOOL) replyWasValidJson {
  return self.replyDict != nil;
}


- (BOOL) replyWasValidRpc {
  NSMutableArray *reasons = [NSMutableArray array];
  NSString *reason = @"";
  if ([self replyWasValidJson]) {
    NSString *version = [self.replyDict objectForKey:LjsJsonJsonRpcKey];
    if (![version isEqualToString:LjsJsonJsonRpcRequiredVersion]) {
#ifdef JSON_RPC_10
      DDLogWarn(@"using JSON RPC 1.0 rules");
#else
      reason = @"jsonrpc:\"2.0\" key-value pair missing";
      [reasons addObject:reason];
#endif
    }
    
    if ([self.replyDict objectForKey:LjsJsonRpcReplyIdKey] == nil) {
      reason = @"id key missing";
      [reasons addObject:reason];
     
    }
    
    if ([self replyHasResult] && [self replyHasRpcError])  {
      reason = @"contains both a result and error key";
      [reasons addObject:reason];
    
    } 
    
    if ([self replyHasRpcError]) {
      NSDictionary *errorDict = [self.replyDict objectForKey:LjsJsonReplyErrorKey];
      if (errorDict == nil || [errorDict count] < 2 || [errorDict count] > 4) {
        if (errorDict == nil) {
          reason = @"contains an error key, but none of the required key-value pairs";
          [reasons addObject:reason];
        } else {
          reason = [NSString stringWithFormat:@"contains an error key, but an incorrect number of keys - expected %d but found %d", 3, [errorDict count]];
          [reasons addObject:reason];
        }
      } else {

        BOOL hasCodeOrName = [errorDict objectForKey:LjsJsonRpcReplyErrorCodeOrNameKey] != nil;
        BOOL hasMessage = [errorDict objectForKey:LjsJsonRpcReplyErrorMessageKey] != nil;
        if (!(hasCodeOrName && hasMessage)) {
          reason = @"contains an error key, but is missing one or more of the required keys (code and/or message)";
          [reasons addObject:reason];
        }
        BOOL hasOtherKey = NO;
        for (NSString *key in [errorDict allKeys]) {
          if (!([key isEqualToString:LjsJsonRpcReplyErrorCodeOrNameKey] || 
                [key isEqualToString:LjsJsonRpcReplyErrorMessageKey] ||
                [key isEqualToString:LjsJsonRpcReplyErrorDataOrErrorsKey])) {
            hasOtherKey = YES;
          }
        }
        if (hasOtherKey) {
          reason = [NSString stringWithFormat:@"contains an error key, but has a key that is other than: %@, %@, or %@",
                    LjsJsonRpcReplyErrorCodeOrNameKey, LjsJsonRpcReplyErrorMessageKey, LjsJsonRpcReplyErrorDataOrErrorsKey];
          [reasons addObject:reason];
        }
      }
    }
    
    if (!([self replyHasResult] || [self replyHasRpcError])) {
      reason = @"reply contains neither a result or an error";
      [reasons addObject:reason];
    }

  } else {
    reason = @"invalid json format";
    [reasons addObject:reason];
  }
  
  BOOL result;
  if ([reasons count] == 0) {
    result = YES;
    self.jsonRpcFormatError = nil;
  } else {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"Rpc Format Error" forKey:NSLocalizedDescriptionKey];
    reason = [reasons componentsJoinedByString:@"\t,\n"];
    reason = [NSString stringWithFormat:@"Failed for these reasons: %@", reason];
    [userInfo setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
    self.jsonRpcFormatError = [NSError errorWithDomain:LjsJsonRpcReplyErrorDomain
                                              code:-11 userInfo:userInfo];
    result = NO;
  }
  
  return result;
}

- (BOOL) replyHasResult {
  return [self.replyDict objectForKey:LjsJsonRpcReplyResultKey] != nil;
}

- (BOOL) replyHasRpcError {
  return [self.replyDict objectForKey:LjsJsonReplyErrorKey] != nil;
}

- (NSInteger) replyId {
  NSInteger result;
  if ([self replyWasValidJson] && [self replyWasValidRpc]) {
    NSNumber *number = [self.replyDict objectForKey:LjsJsonRpcReplyIdKey];
    return [number integerValue];
  } else {
    result = LjsJsonRpcReplyMissingId;
  }
  return result;
}


#pragma mark DEAD SEA

//- (BOOL) replyWasValidRpc {
//  BOOL result = NO;
//  NSMutableArray *reasons = [NSMutableArray array];
//  NSString *reason = @"";
//  if ([self replyWasValidJson]) {
//    NSString *version = [self.replyDict objectForKey:LjsJsonJsonRpcKey];
//    if (![version isEqualToString:LjsJsonJsonRpcRequiredVersion]) {
//#ifdef JSON_RPC_10
//      DDLogWarn(@"using JSON RPC 1.0 rules - should be using 2.0");
//      result = YES;
//#else
//      reason = @"jsonrpc:\"2.0\" key-value pair missing";
//      [reasons addObject:reason];
//      result = NO;
//#endif
//    } else if ([self.replyDict objectForKey:LjsJsonRpcReplyIdKey] == nil) {
//      reason = @"id key missing";
//      [reasons addObject:reason];
//      result = NO;
//    } else if ([self replyHasResult] && [self replyHasRpcError])  {
//      reason = @"contains both a result and error key";
//      [reasons addObject:reason];
//      result = NO;
//    } else if ([self replyHasRpcError]) {
//      NSDictionary *errorDict = [self.replyDict objectForKey:LjsJsonReplyErrorKey];
//      DDLogDebug(@"error dict = %@", errorDict);
//      if (errorDict == nil || [errorDict count] < 2 || [errorDict count] > 4) {
//        if (errorDict == nil) {
//          reason = @"contains an error key, but none of the required key-value pairs";
//          [reasons addObject:reason];
//        } else {
//          reason = [NSString stringWithFormat:@"contains an error key, but an incorrect number of keys - expected %d but found %d", 3, [errorDict count]];
//          [reasons addObject:reason];
//        }
//        result = NO;
//      } else {
//        BOOL hasCode = [errorDict objectForKey:LjsJsonRpcReplyErrorCodeKey] != nil;
//        BOOL hasMessage = [errorDict objectForKey:LjsJsonRpcReplyErrorMessageKey] != nil;
//        if (!(hasCode && hasMessage)) {
//          reason = @"contains an error key, but is missing one or more of the required keys (code and/or message)";
//          [reasons addObject:reason];
//        }
//        
//        BOOL hasOtherKey = NO;
//        for (NSString *key in [errorDict allKeys]) {
//          if (!([key isEqualToString:LjsJsonRpcReplyErrorCodeKey] || 
//                [key isEqualToString:LjsJsonRpcReplyErrorMessageKey] ||
//                [key isEqualToString:LjsJsonRpcReplyErrorDataKey])) {
//            hasOtherKey = YES;
//          }
//        }
//        if (hasOtherKey) {
//          reason = @"contains an error key, but has a key that is other than: code, message, or data";
//          [reasons addObject:reason];
//        }
//        result = hasCode && hasMessage && !hasOtherKey;
//      }
//    } else if ([self replyHasResult]) {
//      result = YES;
//    }
//  } else {
//    reason = @"invalid json format";
//    [reasons addObject:reason];
//  }
//  
//  if (result == YES) {
//    self.rpcFormatError = nil;
//  } else {
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:@"Rpc Format Error" forKey:NSLocalizedDescriptionKey];
//    reason = [reasons componentsJoinedByString:@"\t,\n"];
//    reason = [NSString stringWithFormat:@"Failed for these reasons: %@", reason];
//    [userInfo setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
//    self.rpcFormatError = [NSError errorWithDomain:LjsJsonRpcReplyErrorDomain
//                                              code:-11 userInfo:userInfo];
//  }
//
//  return result;
//}
@end
