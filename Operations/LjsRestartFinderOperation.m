// Copyright 2011 Little Joy Software. All rights reserved.
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

#import "LjsRestartFinderOperation.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *LjsRestartFinderOperationFinishedNotification = @"com.littlejoysoftware.ljs LjsRestartFinderOperation Finished Notification";

@implementation LjsRestartFinderOperation


#pragma mark Memory Management
- (void) dealloc {
   DDLogDebug(@"deallocating %@", [self class]);
}

- (id) init {
  self = [super init];
  if (self) {

  }
  return self;
}

/** @name Main Method */

/** 
 Required method for NSOperation subclasses.
 */
- (void) main {
  @autoreleasepool {
    if (![self isCancelled]) {
      NSAppleScript *script = [[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to quit"];
      NSDictionary *errorDictionary = nil;
      [script executeAndReturnError:&errorDictionary];
      if (errorDictionary != nil && [errorDictionary count] != 0) {
        DDLogError(@"finder could not be stopped: %@", errorDictionary);
      } else {
        DDLogDebug(@"finder successfully stopped");
        
        if (![self isCancelled]) {
          NSAppleScript *delay = [[NSAppleScript alloc] initWithSource:@"delay 2.0"];
          [delay executeAndReturnError:&errorDictionary];
          if (errorDictionary != nil && [errorDictionary count] != 0) {
            DDLogError(@"delay could not be executed %@", errorDictionary);
            errorDictionary = nil;
          } else {
            DDLogDebug(@"successfully delayed");
          }
          
          if (![self isCancelled]) {
            
            NSAppleScript *activate = [[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to activate"];
            [activate executeAndReturnError:&errorDictionary];
            if (errorDictionary != nil && [errorDictionary count] != 0) {
              DDLogError(@"activate finder could not be executed %@", errorDictionary);
              errorDictionary = nil;
            } else {
              DDLogDebug(@"finder activated");
            }
          }
        }
      }
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:LjsRestartFinderOperationFinishedNotification
     object:nil];
   }
}


@end
