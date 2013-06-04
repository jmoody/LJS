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

#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation NSDictionary (NSDictionary_LjsAdditions)

- (BOOL) not_empty {
  return [self count] != 0;
}

- (BOOL) has_objects {
  return [self count] != 0;
}


- (NSSet *) keySet {
  return [NSSet setWithArray:[self allKeys]];
}

- (void) maphash:(void (^)(id key, id val, BOOL *stop)) aBlock {
  [self maphash:aBlock concurrent:NO];
}

- (void) maphash:(void (^)(id key, id val, BOOL *stop)) aBlock concurrent:(BOOL) aConcurrent {
  if (aConcurrent == YES) {
    [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent 
                                  usingBlock:^(id key, id obj, BOOL *stop) {
                                    aBlock(key, obj, stop);
                                  }];
  } else {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      aBlock(key, obj, stop);
    }];
  }
}

- (NSArray *) mapcar:(id (^)(id key, id val)) aBlock {
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
  for (id _key in [self allKeys]) {
    id _val = [self objectForKey:_key];
    id result = aBlock(_key, _val);
    if (result != nil) {
      [array addObject:result];
    }
  }
  return array;
}


@end
