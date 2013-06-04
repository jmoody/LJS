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

#import "LjsGoogleImportTest_Super.h"
#import "LjsGooglePlacesPredictiveReply.h"

@interface LjsGooglePlacesPredictiveReplyTests : LjsGoogleImportTest_Super

@end

@implementation LjsGooglePlacesPredictiveReplyTests

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  [super setUpClass];
}


- (void) setUp {
  self.resourceName = @"google-places-autocomplete-sample";
  [super setUp];
  // Run before each test method
}

- (void) tearDown {
  // Run after each test method
  [super tearDown];
}   

- (void) test_replyWithPredictions {
  LjsGooglePlacesPredictiveReply *reply;
  
  NSError *error = nil;
  reply = [[LjsGooglePlacesPredictiveReply alloc]
           initWithReply:self.jsonResource
           error:&error];
  // tests description
  GHTestLog(@"reply = %@", reply);
  
  GHAssertNil(error, nil);
  GHAssertTrue([reply statusHasResults], nil);
  GHAssertFalse([reply statusInvalidRequest], nil);
  GHAssertFalse([reply statusLocalParseError], nil);
  GHAssertFalse([reply statusNoResults], nil);
  GHAssertFalse([reply statusOverQueryLimit], nil);
  GHAssertFalse([reply statusRequestDenied], nil);
  
  GHAssertEquals((NSUInteger)[reply count], (NSUInteger)5, nil);
  GHAssertNotNil([reply predictions], nil);

}

@end
