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

// a1 is always the RECEIVED value
// a2 is always the EXPECTED value
// GHAssertNoErr(a1, description, ...)
// GHAssertErr(a1, a2, description, ...)
// GHAssertNotNULL(a1, description, ...)
// GHAssertNULL(a1, description, ...)
// GHAssertNotEquals(a1, a2, description, ...)
// GHAssertNotEqualObjects(a1, a2, desc, ...)
// GHAssertOperation(a1, a2, op, description, ...)
// GHAssertGreaterThan(a1, a2, description, ...)
// GHAssertGreaterThanOrEqual(a1, a2, description, ...)
// GHAssertLessThan(a1, a2, description, ...)
// GHAssertLessThanOrEqual(a1, a2, description, ...)
// GHAssertEqualStrings(a1, a2, description, ...)
// GHAssertNotEqualStrings(a1, a2, description, ...)
// GHAssertEqualCStrings(a1, a2, description, ...)
// GHAssertNotEqualCStrings(a1, a2, description, ...)
// GHAssertEqualObjects(a1, a2, description, ...)
// GHAssertEquals(a1, a2, description, ...)
// GHAbsoluteDifference(left,right) (MAX(left,right)-MIN(left,right))
// GHAssertEqualsWithAccuracy(a1, a2, accuracy, description, ...)
// GHFail(description, ...)
// GHAssertNil(a1, description, ...)
// GHAssertNotNil(a1, description, ...)
// GHAssertTrue(expr, description, ...)
// GHAssertTrueNoThrow(expr, description, ...)
// GHAssertFalse(expr, description, ...)
// GHAssertFalseNoThrow(expr, description, ...)
// GHAssertThrows(expr, description, ...)
// GHAssertThrowsSpecific(expr, specificException, description, ...)
// GHAssertThrowsSpecificNamed(expr, specificException, aName, description, ...)
// GHAssertNoThrow(expr, description, ...)
// GHAssertNoThrowSpecific(expr, specificException, description, ...)
// GHAssertNoThrowSpecificNamed(expr, specificException, aName, description, ...)

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsTestCase.h"
#import "LjsGoogleTranslateManager.h"
#import "LjsCaesarCipher.h"
#import "LjsWebCategories.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequest+LjsAdditions.h"
#import "SBJson.h"

@interface LjsGoogleTranslateManager (TEST)

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

- (NSString *) parseResponse:(NSString *) aString;

- (SBJsonParser *) parser;

@end



@interface LjsGoogleTranslateManagerTests : LjsTestCase 
<LjsGoogleTranslateManagerCallbackDelegate>

@property (nonatomic, strong) LjsGoogleTranslateManager *manager;
@property (nonatomic, strong) LjsCaesarCipher *cipher;

@property (atomic, strong) NSCondition* condition;
@property (atomic, assign) BOOL operationSucceeded;

@property (atomic, strong) ASIHTTPRequest *currentRequest;

- (void) requestDidFail:(ASIHTTPRequest *) aRequest;
- (void) requestDidFinish:(ASIHTTPRequest *) aRequest;

@end

@implementation LjsGoogleTranslateManagerTests
@synthesize manager;
@synthesize cipher;
@synthesize condition;
@synthesize operationSucceeded;
@synthesize currentRequest;

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  // Run at start of all tests in the class
  [super setUpClass];
  NSString *decoded = [self decodedKey];
  
  self.manager = [[LjsGoogleTranslateManager alloc]
                  initWithApiToken:nil
                  delegate:nil];
  GHAssertNil(self.manager, nil);
  
  self.manager = [[LjsGoogleTranslateManager alloc]
                  initWithApiToken:@""
                  delegate:nil];
  GHAssertNil(self.manager, nil);
  
  self.manager = [[LjsGoogleTranslateManager alloc]
                  initWithApiToken:decoded
                  delegate:nil];
  GHAssertNil(self.manager, nil);
  
  self.manager = [[LjsGoogleTranslateManager alloc]
                  initWithApiToken:decoded
                  delegate:self];

  GHAssertNotNil(self.manager, nil);
  GHAssertEqualStrings(self.manager.apiToken, decoded, nil);
  GHAssertEquals(self.manager.delegate, self, nil);
  GHAssertNotNil([self.manager parser], nil);

}

- (void) test_initFails {
  LjsGoogleTranslateManager *tm;
  GHAssertThrows((tm = [[LjsGoogleTranslateManager alloc] init]),
                 @"NSInvalidArgumentException", nil);
}

- (NSString *) decodedKey {
  NSString *encoded = @"hpB)zAhY7tY;h,0u4 _0!x}<9`~1\"0n0^Zi1':/";
  if (self.cipher == nil) {
    NSUInteger rotate = [encoded length];
    self.cipher = [[LjsCaesarCipher alloc] initWithRotate:rotate];
  }
  return [self.cipher stringByDecodingString:encoded];
}

- (void) tearDownClass {
  // Run at end of all tests in the class
  [super tearDownClass];
}

- (void) setUp {
  [super setUp];
  // Run before each test method
  self.condition = [[NSCondition alloc] init];
	self.operationSucceeded = NO;
}

- (void) tearDown {
  // Run after each test method
//  self.condition = nil;
//  self.operationSucceeded = YES;
  [super tearDown];
}  


- (void) test_urlForTranslationRequestWithBadParamters {
  NSString *source = [self emptyStringOrNil];
  NSString *target = [self emptyStringOrNil];
  NSString *text = [self emptyStringOrNil];
  NSURL *actual = [self.manager urlWithText:text
                             sourceLangCode:source
                             targetLangCode:target];
  GHAssertNil(actual, nil);

}

- (void) test_urlForTranslationRequestWithBadText {
  NSString *source = @"en";
  NSString *target = @"de";
  NSString *text = [self emptyStringOrNil];
  NSURL *actual = [self.manager urlWithText:text
                             sourceLangCode:source
                             targetLangCode:target];

  GHAssertNil(actual, nil);

}

- (void) test_urlForTranslationRequestWithBadSource {
  NSString *source = [self emptyStringOrNil];
  NSString *target = @"de";
  NSString *text = @"text";
  NSURL *actual = [self.manager urlWithText:text
                             sourceLangCode:source
                             targetLangCode:target];
  
  GHAssertNil(actual, nil);

}

- (void) test_urlForTranslationRequestWithBadTarget {
  NSString *source = @"en";
  NSString *target = [self emptyStringOrNil];
  NSString *text = @"text";
  NSURL *actual = [self.manager urlWithText:text
                             sourceLangCode:source
                             targetLangCode:target];
  
  GHAssertNil(actual, nil);

}

- (void) test_urlForTranslationWithGoodParameters {
  NSString *source = @"en";
  NSString *target = @"de";
  NSString *text = @"text";
  NSURL *actual = [self.manager urlWithText:text
                             sourceLangCode:source
                             targetLangCode:target];
  GHTestLog(@"actual = %@", actual);
  NSURL *expected = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/language/translate/v2?key=%@&q=text&source=en&target=de",
                                          [self decodedKey]]];
  
  GHAssertEqualObjects(actual, expected, nil);

}


- (void) requestDidFail:(ASIHTTPRequest *)aRequest {
  GHTestLog(@"request did fail");
  GHAssertTrue(aRequest.tag == 0, nil);
  
  operationSucceeded = NO;
  [condition lock];
	[condition signal];
	[condition unlock];
}

- (void) requestDidFinish:(ASIHTTPRequest *)aRequest {
  GHTestLog(@"request did finish: %d: %@", [aRequest responseCode],
            [aRequest responseDescription]);
  GHAssertTrue(aRequest.tag == 0, nil);
  self.operationSucceeded = [aRequest was200or201Successful];
  [self.condition lock];
	[self.condition signal];
	[self.condition unlock];
}

- (void) test_requestWithBadURLParameters {
  NSString *source = [self emptyStringOrNil];
  NSString *target = @"de";
  NSString *text = @"text";
  NSUInteger tag = 0;
  BOOL actual = [self.manager executeRequestForText:text
                                     sourceLangCode:source
                                     targetLangCode:target
                                           delegate:self
                                    didFailSelector:@selector(requestDidFail:)
                                  didFinishSelector:@selector(requestDidFinish:)
                                                tag:tag
                                       asynchronous:NO];
  GHAssertFalse(actual, nil);

}

- (void) test_requestWithBadDelegate {
  NSString *source = @"en";
  NSString *target = @"de";
  NSString *text = @"text";
  NSUInteger tag = 0;
  BOOL actual = [self.manager executeRequestForText:text
                                     sourceLangCode:source
                                     targetLangCode:target
                                           delegate:nil
                                    didFailSelector:@selector(requestDidFail:)
                                  didFinishSelector:@selector(requestDidFinish:)
                                                tag:tag
                                       asynchronous:NO];
  GHAssertFalse(actual, nil);

}

- (void) test_requestWithBadFailSelector {
  NSString *source = @"en";
  NSString *target = @"de";
  NSString *text = @"text";
  NSUInteger tag = 0;
  BOOL actual = [self.manager executeRequestForText:text
                                     sourceLangCode:source
                                     targetLangCode:target
                                           delegate:self
                                    didFailSelector:nil
                                  didFinishSelector:@selector(requestDidFinish:)
                                                tag:tag
                                       asynchronous:NO];
  GHAssertFalse(actual, nil);

}

- (void) test_requestWithBadFinishedSelector {
  NSString *source = @"en";
  NSString *target = @"de";
  NSString *text = @"text";
  NSUInteger tag = 0;
  BOOL actual = [self.manager executeRequestForText:text
                                     sourceLangCode:source
                                     targetLangCode:target
                                           delegate:self
                                    didFailSelector:@selector(requestDidFail:)
                                  didFinishSelector:nil
                                                tag:tag
                                       asynchronous:NO];
  GHAssertFalse(actual, nil);

}

- (void) test_requestWithGoodParameters {
  NSString *source = @"en";
  NSString *target = @"de";
  NSString *text = @"text";
  NSUInteger tag = 0;
  BOOL actual = [self.manager executeRequestForText:text
                                     sourceLangCode:source
                                     targetLangCode:target
                                           delegate:self
                                    didFailSelector:@selector(requestDidFail:)
                                  didFinishSelector:@selector(requestDidFinish:)
                                                tag:tag
                                       asynchronous:YES];
  GHAssertTrue(actual, nil);
 
  [self.condition lock];
  BOOL timedOut = ![self.condition waitUntilDate:[self dateForDefaultTimeOut]];
	[self.condition unlock];

  if (timedOut) {
    GHTestLog(@"operation timed out, so there is no test");
  } else {
    GHTestLog(@"operation completed, so we check the result");
    GHAssertTrue(self.operationSucceeded, nil);
  }
}


- (void) failedTranslationWithTag:(NSUInteger)aTag 
                          request:(ASIHTTPRequest *)aRequest 
                          manager:(LjsGoogleTranslateManager *)aManager {
  GHTestLog(@"failed translation with tag: %d", aTag);
  GHAssertTrue(aTag == 0, nil);
  self.operationSucceeded = NO;
  [self.condition lock];
	[self.condition signal];
	[self.condition unlock];
}


- (void) finishedWithTranslation:(NSString *)aTranslation 
                             tag:(NSUInteger)aTag 
                        userInfo:(NSDictionary *)aUserInfo 
                         manager:(LjsGoogleTranslateManager *)aManager {
  GHTestLog(@"finished with translation %d: %@", aTag, aTranslation);
  GHAssertTrue(aTag == 0, nil);
  GHAssertEqualStrings(aTranslation, @"Text", nil);
  self.operationSucceeded = YES;
  [self.condition lock];
	[self.condition signal];
	[self.condition unlock];
}


- (void) test_translateWithBadParameters {
  BOOL actual = [self.manager translateText:nil
                                 sourceLang:nil
                                 targetLang:nil
                                        tag:0
                               asynchronous:YES];
  GHAssertFalse(actual, nil);
}

- (void) test_translateWithGoodParameters {
  BOOL actual = [self.manager translateText:@"text"
                                 sourceLang:@"en"
                                 targetLang:@"de"
                                        tag:0
                               asynchronous:YES];
  GHAssertTrue(actual, nil);
  
  [self.condition lock];
  BOOL timedOut = ![self.condition waitUntilDate:[self dateForDefaultTimeOut]];
	[self.condition unlock];
  
  if (timedOut) {
    GHTestLog(@"operation timed out, so there is no test");
  } else {
    GHTestLog(@"operation completed, so we check the result");
    GHAssertTrue(self.operationSucceeded, nil);
  }
}


- (void) test_parseResultsBadlyFormattedJson {
  NSString *response = @"{\"data\": {\"translations\": {\"translatedText\": \"Hallo Welt\"}]}}";
  NSString *actual = [self.manager parseResponse:response];
  GHAssertNil(actual, nil);
}

- (void) test_parseResultWithError {
  NSString *response = @"{\"error\":{\"errors\":{\"domain\":\"global\",\"reason\":\"invalid\",\"message\":\"InvalidValue\"}],\"code\":400,\"message\":\"InvalidValue\"}}";
  NSString *actual = [self.manager parseResponse:response];
  GHAssertNil(actual, nil);
}

- (void) test_parseResultsGood {
  NSString *response = @"{\"data\": {\"translations\": [{\"translatedText\": \"Hallo Welt\"}]}}";
  NSString *actual = [self.manager parseResponse:response];
  NSString *expected = @"Hallo Welt";
  GHAssertEqualStrings(actual, expected, nil);
}

- (void) test_parseResultsWithQuotes {
  NSString *response = @"{\"data\": {\"translations\": [{\"translatedText\": \"&quot;Hallo Welt&quot;\"}]}}";
  NSString *actual = [self.manager parseResponse:response];
  NSString *expected = @"\"Hallo Welt\"";
  GHAssertEqualStrings(actual, expected, nil);
}


@end
