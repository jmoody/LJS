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

#import "LjsGoogleTranslateManager.h"
#import "Lumberjack.h"
#import "LjsValidator.h"
#import "LjsWebCategories.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequest+LjsAdditions.h"
#import "SBJson.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsGoogleTranslateManager ()

@property (nonatomic, strong) SBJsonParser *parser;

- (NSURL *) urlWithText:(NSString *) aText
      sourceLangCode:(NSString *) aSourceCode
      targetLangCode:(NSString *) aTargetCode;

- (BOOL) executeRequestForText:(NSString *) aText
                sourceLangCode:(NSString *) aSourceCode
                targetLangCode:(NSString *) aTargetLangCode
                      delegate:(id) aDelegate
               didFailSelector:(SEL) aDidFailSelector
             didFinishSelector:(SEL) aDidFinishSelector
                           tag:(NSUInteger) aTag
                  asynchronous:(BOOL) aAsync;

- (void) handleRequestDidFail:(ASIHTTPRequest *) aRequest;
- (void) handleRequestDidFinish:(ASIHTTPRequest *) aRequest;

- (NSString *) parseResponse:(NSString *) aString;


@end

@implementation LjsGoogleTranslateManager 

@synthesize apiToken;
@synthesize delegate;
@synthesize parser;

#pragma mark Memory Management
- (void) dealloc {
//  DDLogDebug(@"deallocating %@", [self class]);
  self.delegate = nil;
}

- (id) init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id) initWithApiToken:(NSString *) aApiToken
               delegate:(id<LjsGoogleTranslateManagerCallbackDelegate>) aDelegate {
  self = [super init];
  if (self) {
    self.apiToken = aApiToken;
    self.delegate = aDelegate;
    NSMutableArray *reasons = [NSMutableArray arrayWithCapacity:2];
    NSString *message;
    if ([LjsValidator stringIsNonNilAndNotEmpty:self.apiToken] == NO) {
      message = [NSString stringWithFormat:@"api token < %@ > needs to be non-nil and non empty",
                 self.apiToken];
      [reasons nappend:message];
    }

    if (self.delegate == nil) {
      message = [NSString stringWithFormat:@"delegate < %@ > need to be non-nil", self.delegate];
      [reasons nappend:message];
    }
    if ([reasons count] != 0) {
      DDLogError(@"failed to initialized because: %@", [reasons componentsJoinedByString:@"\n"]);
      return nil;
    }
    
    self.parser = [[SBJsonParser alloc] init];
  }
  return self;
}

- (NSURL *) urlWithText:(NSString *) aText
         sourceLangCode:(NSString *) aSourceCode
         targetLangCode:(NSString *) aTargetCode {
  NSMutableArray *reasons = [NSMutableArray arrayWithCapacity:3];
  NSString *message;
  
  if ([LjsValidator stringIsNonNilAndNotEmpty:aText] == NO) {
    message = [NSString stringWithFormat:@"aText < %@ > must be non-nil and non-empty", 
               aText];
    [reasons nappend:message];
  }
  if ([LjsValidator stringIsNonNilAndNotEmpty:aSourceCode] == NO) {
    message = [NSString stringWithFormat:@"source lang code < %@ > must be non-nil and non-empty", 
               aSourceCode];
    [reasons nappend:message];
  }
  if ([LjsValidator stringIsNonNilAndNotEmpty:aTargetCode] == NO) {
    message = [NSString stringWithFormat:@"target lang code < %@ > must be non-nil and non-empty", 
               aTargetCode];
    [reasons nappend:message];
  }
  if ([reasons count] != 0) {
    DDLogWarn(@"could not make url because: %@", [reasons componentsJoinedByString:@"\n"]);
    return nil;
  }
  
  NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.apiToken, @"key", 
                             aText, @"q",
                             aSourceCode, @"source",
                             aTargetCode, @"target",
                             nil];
  NSString *params = [paramDict stringByParameterizingForUrl];
  NSString *path = [@"https://www.googleapis.com/language/translate/v2"
                    stringByAppendingString:params];
  NSURL *url = [NSURL URLWithString:path];

  return url;
}

- (BOOL) executeRequestForText:(NSString *) aText
                sourceLangCode:(NSString *) aSourceCode
                targetLangCode:(NSString *) aTargetLangCode
                      delegate:(id) aDelegate
               didFailSelector:(SEL) aDidFailSelector
             didFinishSelector:(SEL) aDidFinishSelector
                           tag:(NSUInteger)aTag 
                  asynchronous:(BOOL) aAsync {
  NSMutableArray *reasons = [NSMutableArray arrayWithCapacity:3];
  NSString *message;
  if (aDelegate == nil) {
    message = [NSString stringWithFormat:@"a delegate < %@ > must not be nil", aDelegate];
    [reasons nappend:message];
  }
  
  if (aDidFailSelector == nil) {
    message = [NSString stringWithFormat:@"a did fail selector < %@ > must not be nil", aDidFailSelector];
    [reasons nappend:message];
  }
  
  if (aDidFinishSelector == nil) {
    message =  [NSString stringWithFormat:@"a did finish selector < %@ > must not be nil", aDidFinishSelector];
    [reasons nappend:message];
  }
  
  if ([reasons count] != 0) {
    DDLogWarn(@"could not execute request because: %@", [reasons componentsJoinedByString:@"\n"]);
    return NO;
  }
  
  NSURL *url = [self urlWithText:aText sourceLangCode:aSourceCode targetLangCode:aTargetLangCode];
                
  if (url == nil) {
    DDLogWarn(@"could not execute request because a url could not be created");
    return NO;
  }
  
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
  [request setDelegate:aDelegate];
  [request setRequestMethod:@"GET"];
  [request setDidFailSelector:aDidFailSelector];
  [request setDidFinishSelector:aDidFinishSelector];
  [request setResponseEncoding:NSUTF8StringEncoding];
  [request setTag:aTag];
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            aText, @"q",
                            aSourceCode, @"source",
                            aTargetLangCode, @"target", nil];
  [request setUserInfo:userInfo];
  

  if (aAsync) {
    DDLogDebug(@"starting async request");
    [request startAsynchronous];
  } else {
    DDLogDebug(@"starting synchronous request");
    [request startSynchronous]; 
  }
  
  return YES;
}

- (BOOL) translateText:(NSString *) aText
            sourceLang:(NSString *) aSource
            targetLang:(NSString *) aTarget
                   tag:(NSUInteger) aTag
          asynchronous:(BOOL) aAsync {
  BOOL started = [self executeRequestForText:aText
                              sourceLangCode:aSource
                              targetLangCode:aTarget
                                    delegate:self
                             didFailSelector:@selector(handleRequestDidFail:)
                           didFinishSelector:@selector(handleRequestDidFinish:)
                                         tag:aTag
                                asynchronous:aAsync];
  return started;
}

- (void) handleRequestDidFail:(ASIHTTPRequest *) aRequest {
  DDLogDebug(@"request did fail: %d : %@", [aRequest responseCode],
             [aRequest responseDescription]);
  [self.delegate failedTranslationWithTag:aRequest.tag
                                  request:aRequest
                                  manager:self];
}

- (void) handleRequestDidFinish:(ASIHTTPRequest *) aRequest {
  DDLogDebug(@"request did finish: %d : %@", [aRequest responseCode],
             [aRequest responseDescription]);
  if ([aRequest was200or201Successful] == NO) {
    [self handleRequestDidFail:aRequest];
    return;
  }
  
  NSString *json = [aRequest responseString];
  NSString *translation = [self parseResponse:json];
  if (translation == nil) {
    [self handleRequestDidFail:aRequest];
    return;
  } 

  [self.delegate finishedWithTranslation:translation
                                     tag:aRequest.tag
                                userInfo:aRequest.userInfo
                                 manager:self];
}

- (NSString *) parseResponse:(NSString *)aString {
  NSError *error = nil;
  NSDictionary *dict = [self.parser objectWithString:aString
                                               error:&error];
  
  if (dict == nil) {
    DDLogError(@"error parsing < %@ > : %@ - %@", 
               aString, [error code], [error localizedDescription]);
    return nil;
  }
  
  if ([LjsValidator dictionary:dict containsKey:@"error"]) {
    DDLogDebug(@"dictionary contains key: < error > - returning nil");
    return nil;
  }
  
  NSArray *translations = [[dict objectForKey:@"data"] objectForKey:@"translations"];
  NSDictionary *first = [translations first];
  // the google translation service is primarily focused on javascript, so quotes
  // are returned as &quot; so we replace them.
  NSString *rawText = [first objectForKey:@"translatedText"];
  rawText = [rawText stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
  rawText = [rawText trimmed];
  return rawText;
}



@end
