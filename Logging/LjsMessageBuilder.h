// Copyright 2011 The Little Joy Software Company. All rights reserved.
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


#import <Foundation/Foundation.h>

extern NSString *LjsMessageBuilderMethodNotYetTested;
extern NSString *LjsMessageBuilderMethodCouldUseMoreTesting;

@interface LjsMessageBuilder : NSObject 

/**
 the message
 */
@property (nonatomic, copy) NSString *message;

/** @name Initialization */

- (id) initWithMessage:(NSString *) aMessage;
+ (id) messageBuilderWith:(NSString *) aMessage;
+ (id) failedToCreateMessage:(Class) aClass;

/** @name append methods */
- (void) appendWithIntFail:(NSString *) reason
                      name:(NSString *) name
                     value:(int) value;

- (void) appendWithDoubleFail:(NSString *) reason
                      name:(NSString *) name
                     value:(double) value;

- (void) appendWithDecimalFail:(NSString *)reason 
                          name:(NSString *)name 
                         value:(NSDecimalNumber *) value;

- (void) appendWithNilOrEmpty:(NSString *) name;
- (void) appendWithNilValue:(NSString *) name;
- (void) appendWithMessage:(NSString *) append;
- (void) appendWithReturn:(NSString *) willReturn;

@end
