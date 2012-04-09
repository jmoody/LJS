// Copyright 2011 Little Joy Software. All rights reserved.
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

#import "Lumberjack.h"
#import "LjsGestalt.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsGestalt ()



@end

@implementation LjsGestalt

#if !TARGET_OS_IPHONE

@synthesize majorVersion;
@synthesize minorVersion;
@synthesize bugVersion;

#endif

#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating LjsGestalt");
}


- (id) init {
  self = [super init];
  if (self) {
#if !TARGET_OS_IPHONE
    unsigned tMajor, tMinor, tBug;
    BOOL success = [self getSystemVersionMajor:&tMajor
                                         minor:&tMinor
                                        bugFix:&tBug];

    
    if (success == YES) {
      self.majorVersion = (NSUInteger) tMajor;
      self.minorVersion = (NSUInteger) tMinor;
      self.bugVersion = (NSUInteger) tBug;
    } else {
      self = nil;
    }
#endif
  }
  return self;
}


#if !TARGET_OS_IPHONE
//http://www.cocoadev.com/index.pl?DeterminingOSVersion
- (BOOL)getSystemVersionMajor:(unsigned *)major
                        minor:(unsigned *)minor
                       bugFix:(unsigned *)bugFix {
  OSErr err;
  SInt32 systemVersion, versionMajor, versionMinor, versionBugFix;
  if ((err = Gestalt(gestaltSystemVersion, &systemVersion)) != noErr) goto fail;
  if (systemVersion < 0x1040) {
    if (major) *major = ((systemVersion & 0xF000) >> 12) * 10 +
      ((systemVersion & 0x0F00) >> 8);
    if (minor) *minor = (systemVersion & 0x00F0) >> 4;
    if (bugFix) *bugFix = (systemVersion & 0x000F);
  } else {
    if ((err = Gestalt(gestaltSystemVersionMajor, &versionMajor)) != noErr) goto fail;
    if ((err = Gestalt(gestaltSystemVersionMinor, &versionMinor)) != noErr) goto fail;
    if ((err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix)) != noErr) goto fail;
    if (major) *major = versionMajor;
    if (minor) *minor = versionMinor;
    if (bugFix) *bugFix = versionBugFix;
  }
  
  return YES;
  
fail:
  DDLogError(@"Unable to obtain system version: %ld", (long)err);
  
  if (major) *major = 10;
  if (minor) *minor = 0;
  if (bugFix) *bugFix = 0;
  return NO;
}

- (NSString *) description {
  return [NSString stringWithFormat:@"Gestalt %d.%d.%d",
          self.majorVersion, self.minorVersion, self.bugVersion];
          
}


#endif

- (NSString *) buildConfiguration:(BOOL) abbrevated {
  NSString *config, *abbrev;
#if DEBUG_BUILD
  config = @"debug";
  abbrev = @"de";
#elif ADHOC_BUILD
  config = @"adhoc";
  abbrev = @"ah";
#elif APP_STORE_BUILD
  config = @"appstore";
  abbrev = @"as";
#else
  config = nil;
  abbrev = nil;
#endif
  return abbrevated ? abbrev : config;
}


- (BOOL) isDebugBuild {
  return [@"debug" isEqualToString:[self buildConfiguration:NO]];
}

- (BOOL) isAdHocBuild {
  return [@"adhoc" isEqualToString:[self buildConfiguration:NO]];
}

- (BOOL) isAppStoreBuild {
  return [@"appstore" isEqualToString:[self buildConfiguration:NO]];
}


@end

