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

#import "LjsLoginItemManager.h"
#import "Lumberjack.h"
#import "LjsValidator.h"
#import "LjsErrorFactory.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsLoginItemManager ()

@property (nonatomic, strong) NSTimer *checkLoginItemTimer;
@property (nonatomic, copy) Ljs_Block_LoginItemManager_TimerEvent timerEventBlock;

@end

@implementation LjsLoginItemManager

@synthesize checkLoginItemTimer;
@synthesize timerEventBlock;

/** @name LjsRepeatingTimerProtocol */
/**
 implements the LjsRepeatingTimerProtocol
 
 invalidates the checkLoginItemTimer and releases it
 */
- (void) stopAndReleaseRepeatingTimers {
  DDLogDebug(@"stopping check login item timer");
  if (self.checkLoginItemTimer != nil) {
    [self.checkLoginItemTimer invalidate];
    self.checkLoginItemTimer = nil;
  }
}

/**
 implements the LjsRepeatingTimerProtocol
 
 if the checkLoginItemTimer is non-nil, call stopAndReleaseRepeatingTimer
 then starts and retains the timer
 */
- (void) startAndRetainRepeatingTimers {
  DDLogDebug(@"starting check login item timer");
  if (self.checkLoginItemTimer != nil) {
    [self stopAndReleaseRepeatingTimers];
  }
  self.checkLoginItemTimer =
  [NSTimer scheduledTimerWithTimeInterval:1.0
                                   target:self
                                 selector:@selector(handleCheckLoginItemTimerEvent:)
                                 userInfo:nil
                                  repeats:YES];
}


#pragma mark Memory Management
- (void) dealloc {
   DDLogDebug(@"deallocating %@", [self class]);
}

- (id) init {
  //[self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id) initWithTimerEventBlock:(void (^)(BOOL))aTimerEventBlock {
  self = [super init];
  if (self) {
    LjsReasons *reasons = [LjsReasons new];
    [reasons ifNil:aTimerEventBlock addReasonWithVarName:@"timer event block"];
    if ([reasons hasReasons]) {
      DDLogError([reasons explanation:@"could not create login item manager"
                          consequence:@"nil"]);
      return nil;
    
    }
    self.timerEventBlock = aTimerEventBlock;
  }
  return self;
}

- (void) handleCheckLoginItemTimerEvent:(NSTimer *) aTimer {
  DDLogInfo(@"handling check login item timer event");
  BOOL status = [self isLoginItem];
  self.timerEventBlock(status);
}

#pragma mark - Login Item Methods

/**
 adds TwistedPair as a login item using and applescript
 @param aError will be populated with information about why the delete failed
 @return YES iff delete was successful

 */
-(BOOL) addLoginItem:(NSError **) aError {
    
  //tell application "System Events"
  //  make login item at end with properties {path:"/Applications/Ansible.app", kind:application}
  // end tell
  
  NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
  NSString *script =
  [NSString stringWithFormat:@"tell application \"System Events\"\nmake login item at end with properties {path:\"%@\", kind:application}\nend tell\n",
   bundlePath];
  
  NSAppleScript *ascript = [[NSAppleScript alloc]
                            initWithSource:script];
  
  NSDictionary *errorDictionary = nil;
  // the descriptor can return false, so we can't rely on it
  NSAppleEventDescriptor *descript __attribute__((unused)) = [ascript executeAndReturnError:&errorDictionary];
  //BOOL status = [descript booleanValue] == false ? NO : YES;
  BOOL failed = (errorDictionary != nil) && ([errorDictionary count] != 0);
  if (failed == YES) {
    NSString *message = [NSString swf:@"could not add the login item - executing this script: %@ produced these errors: %@",
                         script, errorDictionary];
    DDLogError(message);
    if (aError != NULL) {
      *aError = [LjsErrorFactory errorWithCode:0
                          localizedDescription:message
                                 otherUserInfo:errorDictionary];
    }
  } else {
    DDLogDebug(@"added login item for: %@", bundlePath);
  }
  return !failed;
}

/**
 removes TwistedPair login item using an applescript
 @param aError will be populated with information about why the delete failed
 @return YES iff delete was successful
 */
- (BOOL) deleteLoginItem:(NSError **) aError {
  NSBundle *main = [NSBundle mainBundle];
  NSString *bundleName = [[main infoDictionary] objectForKey:@"CFBundleName"];
  NSString *conditionLine = [NSString stringWithFormat:@"if login item \"%@\" exists then",
                             bundleName];
  NSString *deleteLine = [NSString stringWithFormat:@"delete login item \"%@\"",
                          bundleName];
  NSArray *array = [NSArray arrayWithObjects:
                    @"tell application \"System Events\"",
                    @"get the name of every login item",
                    conditionLine,
                    deleteLine,
                    @"end if",
                    @"end tell", nil];
  
  
  NSString *script = [array componentsJoinedByString:@"\n"];
  script = [script stringByAppendingString:@"\n"];
  
  NSAppleScript *ascript = [[NSAppleScript alloc] initWithSource:script];
  NSDictionary *errorDictionary = nil;
  // the descriptor can return false, so we can't rely on it
  NSAppleEventDescriptor *descript __attribute__((unused)) = [ascript executeAndReturnError:&errorDictionary];
  //BOOL status = [descript booleanValue] == false ? NO : YES;
  BOOL failed = (errorDictionary != nil) && ([errorDictionary count] != 0);
  if (failed == YES) {
    NSString *message = [NSString swf:@"could not delete login item < %@ > using script\n%@found:\n%@",
                         bundleName, script, errorDictionary];
    DDLogError(message);
    if (aError != NULL) {
      *aError = [LjsErrorFactory errorWithCode:0
                          localizedDescription:message
                                 otherUserInfo:errorDictionary];
    }
  } else {
    DDLogDebug(@"deleted < %@ > from login items", bundleName);
  }
  
  return !failed;
}

/**
 @return true iff twistedpair is a login item
 @bug there is a leak some where in LSSharedFileListItemResolve - it is
 neglible
 */
- (BOOL) isLoginItem {
  BOOL result = NO;
  NSString * appPath = [[NSBundle mainBundle] bundlePath];
  
  
	// Create a reference to the shared file list.
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                          kLSSharedFileListSessionLoginItems,
                                                          NULL);
  
	if (loginItems) {
		UInt32 seedValue;
		//Retrieve the list of Login Items and cast them to
		// a NSArray so that it will be easier to iterate.
    CFArrayRef cfLoginItemsArray = LSSharedFileListCopySnapshot(loginItems, &seedValue);
		NSArray  *loginItemsArray = (__bridge_transfer  NSArray *) cfLoginItemsArray;
    
    
		for(NSUInteger index = 0; index < [loginItemsArray count]; index++){
			LSSharedFileListItemRef itemRef =
      (__bridge LSSharedFileListItemRef)[loginItemsArray objectAtIndex:index];
      
			//Resolve the item with URL
			//if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr) {
      // This will retrieve the path for the application
      // For example, /Applications/test.app
      CFURLRef cfUrlRef =  nil;
      if (LSSharedFileListItemResolve(itemRef, 0, &cfUrlRef, NULL) == noErr) {
        NSURL *url = (__bridge_transfer NSURL *) cfUrlRef;
				NSString * urlPath = [url path];
				if ([urlPath compare:appPath] == NSOrderedSame){
					result = YES;
				}
			}
    }
  }
  if (loginItems != NULL) { CFRelease(loginItems); }
  return result;
}

@end
