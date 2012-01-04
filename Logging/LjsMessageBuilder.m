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

//#if ! __has_feature(objc_arc)
//#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
//#endif

#import "LjsMessageBuilder.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


NSString *LjsMessageBuilderMethodNotYetTested = @"METHOD IS NOT YET TESTED";
NSString *LjsMessageBuilderMethodCouldUseMoreTesting = @"METHOD COULD USE MORE TESTING";

/**
 Helps build log meaningful log messages based on method parameters.
 
 @bug This class is a work in progress and should probably not be used.
 */
@implementation LjsMessageBuilder
@synthesize message;

- (id) init {
  self = [super init];
  if (self) {
    self.message = @"";
  }
  return self;
}

- (id) initWithMessage:(NSString *) aMessage {
  self = [super init];
  if (self) {
    self.message = aMessage;
  }
  return self;
}

+ (id) messageBuilderWith:(NSString *) aMessage {
  return [[self alloc] initWithMessage:aMessage];
}

+ (id) failedToCreateMessage:(Class) aClass {
  NSString *msg = [NSString stringWithFormat:@"Failed to create instance of %@ because:\n",
                   aClass];
  return [[self alloc] initWithMessage:msg];                   
}



- (NSString *) description {
  NSString *result = [NSString stringWithFormat:@"<#%@ >", [self class]];
  return result;
}

- (void) appendWithIntFail:(NSString *) reason
                      name:(NSString *) name
                     value:(int) value {
  self.message = [message stringByAppendingFormat:@"%@ = %d %@\n",
                  name, value, reason];
                  
}
                                      
- (void) appendWithDoubleFail:(NSString *) reason
                         name:(NSString *) name
                        value:(double) value {
  self.message = [message stringByAppendingFormat:@"%@ = %f %@\n",
                  name, value, reason];
}
                                        

- (void) appendWithDecimalFail:(NSString *)reason 
                          name:(NSString *)name 
                         value:(NSDecimalNumber *) value {
  self.message = [message stringByAppendingFormat:@"%@ = %@ %@\n",
                  name, value, reason];
}

- (void) appendWithNilOrEmpty:(NSString *) name {
  self.message = [message stringByAppendingFormat:@"%@ was nil or empty\n",
                  name];
}

- (void) appendWithNilValue:(NSString *) name {
  self.message = [message stringByAppendingFormat:@"%@ was nil\n",
                  name];
}
                                          
                                        
- (void) appendWithMessage:(NSString *) append {
  self.message = [message stringByAppendingFormat:@"%@\n", append];
}

- (void) appendWithReturn:(NSString *) willReturn {
  self.message = [message stringByAppendingFormat:@"%@",
                  willReturn];
}


@end
