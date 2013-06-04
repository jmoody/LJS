// Copyright 2012 nUCROSOFT. All rights reserved.
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

#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif
                
@implementation NSMutableArray (NSMutableArray_LjsAdditions)

#pragma mark - runtime errors for NSArray methods that are not defined

- (NSArray *) append:(id) object {
  DDLogError(@"cannot append to mutable array - use nappend");
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (NSArray *) reverse {
  DDLogError(@"cannot reverse mutable array - use nreverse");
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (void) nreverse {
  NSArray *tmp = [[self reverseObjectEnumerator] allObjects];
  [self removeAllObjects];
  [self addObjectsFromArray:tmp];
}

- (void) nappend:(id) object {
  if (object == nil) {
    return;
  }
  
  if ([object isKindOfClass:[NSArray class]]) {
    NSArray *other = (NSArray *) object;
    [self addObjectsFromArray:other];
  } else {
    [self addObject:object];
  }
}

- (void) push:(id) object {
  if (object == nil) {
    return;
  }
  [self insertObject:object atIndex:0]; 
}

- (id) pop {
  if ([self count] == 0) {
    return nil;
  }
  id object = [self objectAtIndex:0];
  [self removeObjectAtIndex:0];
  return object;
}



@end
