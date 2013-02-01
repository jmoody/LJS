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

#import "LjsStartAtLoginManager.h"
#import "Lumberjack.h"
#import <ServiceManagement/ServiceManagement.h>
#import "LjsValidator.h"
#import "NSArray+LjsAdditions.h"
#import "NSError+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *const kLjsStartAtLoginManagerErrorDomain = @"com.littlejoysoftware Start At Login Manager Error Domain";

@interface LjsStartAtLoginManager ()

@property (nonatomic, copy) NSString *helperAppIdentifier;

@end

@implementation LjsStartAtLoginManager

@synthesize helperAppIdentifier;

#pragma mark - Memory Management

- (id) init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id) initWithHelperAppIdentifier:(NSString *) aHelperAppIdentifier {
  self = [super init];
  if (self) {
    LjsReasons *reasons = [LjsReasons new];
    [reasons ifNilOrEmptyString:aHelperAppIdentifier addReasonWithVarName:@"helper app identifier"];
    NSArray *tokens = [aHelperAppIdentifier componentsSeparatedByString:@"."];
    if ([tokens count] != 3) {
      [reasons addReason:@"the helper app identifier '%@' is not a valid app identifier"];
    }
    if ([reasons hasReasons]) {
      DDLogError([reasons explanation:@"could not create the manager"
                          consequence:@"nil"]);
      return nil;
    }

    self.helperAppIdentifier = aHelperAppIdentifier;
  }
  return self;
}

#pragma mark - Login Item Methods

- (BOOL) isLoginItem {
  CFArrayRef cfJobDicts = SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
  NSArray* jobDicts = CFBridgingRelease(cfJobDicts);
  
  NSString *lIdentifier = self.helperAppIdentifier;
  __block BOOL isLoginItem = NO;
  if (jobDicts && [jobDicts count] > 0) {
    [jobDicts mapc:^(NSDictionary *job, NSUInteger idx, BOOL *stop) {
      NSString *label = [job objectForKey:@"Label"];
      if ([lIdentifier isEqualToString:label]) {
        isLoginItem = [[job objectForKey:@"OnDemand"] boolValue];
        *stop = YES;
      }
    }];
  }
  return isLoginItem;
}


- (BOOL) addLoginItem:(NSError **) aError {
  // already a login item
  if ([self isLoginItem]) {
    return YES;
  }
  
  NSString *lIdentifier = self.helperAppIdentifier;
  Boolean success = SMLoginItemSetEnabled((__bridge CFStringRef) lIdentifier, true);
  if (success == false) {
    NSString *errMessage = @"could not add item to login items";
    DDLogError(@"%@", errMessage);
    if (aError != nil) {
      *aError = [NSError errorWithDomain:kLjsStartAtLoginManagerErrorDomain
                                    code:kLjsStartAtLoginManagerErrorCode_add_item_failed
                    localizedDescription:errMessage];
      return NO;
    }
  }
  return YES;
}

- (BOOL) deleteLoginItem:(NSError *__autoreleasing *)aError {
  // already not a login item
  if ([self isLoginItem] == NO) {
    return YES;
  }
  
  NSString *lIdentifier = self.helperAppIdentifier;
  Boolean success = SMLoginItemSetEnabled((__bridge CFStringRef) lIdentifier, false);
  if (success == false) {
    NSString *errMessage = @"could not delete item from login items";
    DDLogError(@"%@", errMessage);
    if (aError != nil) {
      *aError = [NSError errorWithDomain:kLjsStartAtLoginManagerErrorDomain
                                    code:kLjsStartAtLoginManagerErrorCode_delete_item_failed
                    localizedDescription:errMessage];
      return NO;
    }
  }
  return YES;
}


@end
