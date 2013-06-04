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

/**
 When using repeating timers with target self it is important to invalidate
 the timer before deallocating self because the timer maintains a reference
 to the target until invalidate is called.  It is also often very useful to
 have, say the App Delegate, start and stop timers when the user moves from
 one state to another.
 
 Enter LjsRepeatingTimerProtocol.  Implementers must define methods for 
 starting/stopping and memory management.
 */
@protocol LjsRepeatingTimerProtocol <NSObject>

@required
/**
 Implementer should stop timers with invalidate and release the timers.
 */
- (void) stopAndReleaseRepeatingTimers;

/**
 Implementer should start timers and retain them and should ensure that if a 
 timer is already running, that is is invalidated and released.
 */
- (void) startAndRetainRepeatingTimers;

@end
