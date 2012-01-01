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

#import "LjsGestalt.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGestalt

@synthesize majorVersion;
@synthesize minorVersion;
@synthesize bugVersion;

#pragma mark Memory Management
- (void) dealloc {
   DDLogDebug(@"deallocating LjsGestalt");
  [super dealloc];
}

- (id) init {
  self = [super init];
  if (self) {
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
  }
  return self;
}

//http://www.cocoadev.com/index.pl?DeterminingOSVersion
- (BOOL)getSystemVersionMajor:(unsigned *)major
                        minor:(unsigned *)minor
                       bugFix:(unsigned *)bugFix {
  OSErr err;
  SInt32 systemVersion, versionMajor, versionMinor, versionBugFix;
  if ((err = Gestalt(gestaltSystemVersion, &systemVersion)) != noErr) goto fail;
  if (systemVersion < 0x1040)
  {
    if (major) *major = ((systemVersion & 0xF000) >> 12) * 10 +
      ((systemVersion & 0x0F00) >> 8);
    if (minor) *minor = (systemVersion & 0x00F0) >> 4;
    if (bugFix) *bugFix = (systemVersion & 0x000F);
  }
  else
  {
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

@end