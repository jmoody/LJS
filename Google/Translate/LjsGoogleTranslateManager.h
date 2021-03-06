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


#import <Foundation/Foundation.h>

@class ASIHTTPRequest;
@class LjsGoogleTranslateManager;

@protocol LjsGoogleTranslateManagerCallbackDelegate <NSObject>

@required
- (void) finishedWithTranslation:(NSString *) aTranslation
                             tag:(NSUInteger) aTag
                        userInfo:(NSDictionary *) aUserInfo
                         manager:(LjsGoogleTranslateManager *) aManager;

- (void) failedTranslationWithTag:(NSUInteger) aTag
                          request:(ASIHTTPRequest *) aRequest
                          manager:(LjsGoogleTranslateManager *) aManager;
@end

/**
 Documentation
 */
@interface LjsGoogleTranslateManager : NSObject 

/** @name Properties */
@property (nonatomic, copy) NSString *apiToken;
@property (nonatomic, assign) id<LjsGoogleTranslateManagerCallbackDelegate> delegate;

/** @name Initializing Objects */
- (id) initWithApiToken:(NSString *) aApiToken
               delegate:(id<LjsGoogleTranslateManagerCallbackDelegate>) aDelegate;

/** @name Handling Notifications, Requests, and Events */

/** @name Utility */
- (BOOL) translateText:(NSString *) aText
            sourceLang:(NSString *) aSource
            targetLang:(NSString *) aTarget
                   tag:(NSUInteger) aTag
          asynchronous:(BOOL) aAsync;




@end
