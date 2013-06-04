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

#import "LjsKeyboardInfo.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsKeyboardInfo

@synthesize frameBegin, frameEnd;
@synthesize frameChangedByUserInteraction;
@synthesize animationDuration;
@synthesize animationCurve;
@synthesize beginTopOfFrame;
@synthesize endTopOfFrame;
@synthesize keyboardHeight;

static NSString *Ljs_UIKeyboardFrameChangedByUserInteraction = @"UIKeyboardFrameChangedByUserInteraction";
#pragma mark Memory Management

- (id) initWithNotification:(NSNotification *) aNotification {
  self = [super init];
  if (self) {

    NSDictionary *userInfo = [aNotification userInfo];
    id rect;
    
    rect = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    self.frameBegin = [rect CGRectValue];

    rect = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    self.frameEnd = [rect CGRectValue];
    
    NSNumber *number;
    
    number = [userInfo objectForKey:Ljs_UIKeyboardFrameChangedByUserInteraction];
    self.frameChangedByUserInteraction = [number boolValue];
    
    number = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    self.animationCurve = [number integerValue];
    
    number = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    self.animationDuration = [number doubleValue];
    
    self.beginTopOfFrame = self.frameBegin.origin.y;
    self.endTopOfFrame = self.frameEnd.origin.y;
    self.keyboardHeight = self.frameEnd.size.height;
  }
  return self;
}

+ (void) registerForKeyboardNotificationWithObserver:(id) aObserver 
                                         willShowSel:(SEL) aWillShowSel
                                          didShowSel:(SEL) aDidShowSel
                                         willHideSel:(SEL) aWillHideSel
                                          didHideSel:(SEL) aDidHideSel 
                                              object:(id) aObject {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  

  if (aWillShowSel != nil) {
    [nc addObserver:aObserver
           selector:aWillShowSel
               name:UIKeyboardWillShowNotification
             object:aObject];
  }
  
  if (aDidShowSel != nil) {
    [nc addObserver:aObserver
           selector:aDidShowSel
               name:UIKeyboardDidShowNotification
             object:aObject];
  }
  
  if (aWillHideSel != nil) {
    [nc addObserver:aObserver
           selector:aWillHideSel
               name:UIKeyboardWillHideNotification
             object:aObject];
  }
  
  if (aDidHideSel != nil) {
    [nc addObserver:aObserver
           selector:aDidHideSel
               name:UIKeyboardDidHideNotification
             object:aObject];  
  }
}


- (NSString *) description {
  NSString *begin =  NSStringFromCGRect(self.frameBegin);
  NSString *end =   NSStringFromCGRect(self.frameEnd);
  NSString *animation = [NSString stringWithFormat:@"(%d, %.2f)",
                         self.animationCurve, self.animationDuration];
  
  
  return [NSString stringWithFormat:@"#<LjsKeyboardInfo begin: %@\nend: %@\nanimation: %@",
          begin, end, animation];
}
@end
