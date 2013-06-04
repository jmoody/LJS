// Copyright (c) 2010 Little Joy Software
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
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "ASIHTTPResponseUtils.h"
#import "Lumberjack.h"



#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

/**
 ASIHTTPResponseUtils is a class for extracting server response codes and error
 messages from an ASIHTTPRequest.
 */
@implementation ASIHTTPResponseUtils

/**
 Simply calls the super init method.
 
 @return an instance of ASIHTTPResponseUtils or nil
 */
- (id) init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  return self;
}


/**
 returns the response code of a request.
 
 NOTE:  ASIHTTPRequest appears to have problem with correctly identifying code
 408.  A status code 0 is converted to 408 by this method.
 
 @param aRequest the request to query
 @return an NSInteger representing the response code.
 */
- (NSInteger) responseCodeWithRequest:(ASIHTTPRequest *) aRequest {
  int statusCode = [aRequest responseStatusCode];
  if (statusCode == 0) {
    statusCode = 408;
  }
  return statusCode;
}

/**
 returns the localized error message of a request.  
 
 @param aRequest a request that has failed
 @return if no error is found, this method will return nil
 */
- (NSString *) errorMessageForFailedRequest:(ASIHTTPRequest *) aRequest {
  NSString *result = [aRequest responseStatusMessage];
  if (result == nil || [result length] == 0) {
    NSError *requestError = [aRequest error];
    if (requestError == nil) {
      result = @"";
    } else {
      result = [requestError localizedDescription];
    }
  }
  return result;
}

/**
 returns a description string for a request.
 
 `<response code>:  <localized description>`
 
 This is a convenience method for logging and as such it is not appropriate to
 use for displaying text to the user.
 
 @param aRequest the request to query
 @return a brief description of the response to the request
 */
- (NSString *) responseDescriptionForRequest:(ASIHTTPRequest *) aRequest {
  NSString *error = [self errorMessageForFailedRequest:aRequest];
  if (error == nil) {
    error = @"Success.";
  }
  NSString *result =
  [NSString stringWithFormat:@"%ld:  %@", (long)[self responseCodeWithRequest:aRequest], error];
  return result;
}

/** 
 returns YES iff the request timed out
 
 @param aRequest the request to query
 @return  returns YES iff the request timed out
 */
- (BOOL) requestDidTimeOut:(ASIHTTPRequest *) aRequest {
  NSInteger code = [self responseCodeWithRequest:aRequest];
  return code == 408;
}

/**
 returns YES iff the request was successful with 200 or 201
 @param aRequest the request to query
 @return YES iff the request was successful with 200 or 201
 */
- (BOOL) requestWas200or201Successful:(ASIHTTPRequest *) aRequest {
  NSInteger code = [self responseCodeWithRequest:aRequest];
  return code == 200 || code == 201;
}


@end
