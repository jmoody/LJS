// Copyright 2012 Little Joy Software. All rights reserved.
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

#import "LjsUserDefaultsStore.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsUserDefaultsStore


#pragma mark Memory Management
- (void) dealloc {
   DDLogDebug(@"deallocating LjsUserDefaultsStore");
}

- (id) init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  return self;
}

- (void) removeKeys:(NSArray *) keys {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  for (NSString *key in keys) {
    [defaults removeObjectForKey:key];
  }
}

- (NSString *) stringForKey:(NSString *) aKey 
               defaultValue:(NSString *) aDefault 
             storeIfMissing:(BOOL) aPersistMissing {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *result = [defaults objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [defaults setObject:aDefault forKey:aKey];
  }
  
  if (result == nil) {
    result = aDefault;
  }
  return result;
}

- (NSNumber *) numberForKey:(NSString *) aKey 
               defaultValue:(NSNumber *) aDefault
             storeIfMissing:(BOOL) aPersistMissing {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSNumber *result = [defaults objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [defaults setObject:aDefault forKey:aKey];
  }
  if (result == nil) {
    result = aDefault;
  }
  return result;
}

- (BOOL) boolForKey:(NSString *) aKey 
       defaultValue:(BOOL) aDefault
     storeIfMissing:(BOOL) aPersistMissing {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  id object = [defaults objectForKey:aKey];
  if (object == nil && aPersistMissing) {
    [defaults setBool:aDefault forKey:aKey];
  }
  BOOL result;
  if (object != nil) {
    result = [defaults boolForKey:aKey];
  } else {
    result = aDefault;
  }
  return result;
}

- (NSDate *) dateForKey:(NSString *) aKey
           defaultValue:(NSDate *) aDefault
         storeIfMissing:(BOOL) aPersistMissing {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDate *result = (NSDate *) [defaults objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [defaults setObject:aDefault forKey:aKey];
  }
  if (result == nil) {
    result = aDefault;
  }
  return result;
}

- (NSData *) dataForKey:(NSString *) aKey
           defaultValue:(NSData *) aDefault
         storeIfMissing:(BOOL) aPersistMissing {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *result = (NSData *) [defaults objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [defaults setObject:aDefault forKey:aKey];
  }
  if (result == nil) {
    result = aDefault;
  }
  return result;
}

- (NSArray *) arrayForKey:(NSString *) aKey
             defaultValue:(NSArray *) aDefault
           storeIfMissing:(BOOL) aPersistMissing {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSArray *result = (NSArray *) [defaults objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [defaults setObject:aDefault forKey:aKey];
  }
  if (result == nil) {
    result = aDefault;
  }
  return result;
}

- (NSDictionary *) dictionaryForKey:(NSString *) aKey
                       defaultValue:(NSDictionary *) aDefault
                     storeIfMissing:(BOOL) aPersistMissing {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *result = (NSDictionary *) [defaults objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [defaults setObject:aDefault forKey:aKey];
  }
  if (result == nil) {
    result = aDefault;
  }
  return result;
}


- (void) storeObject:(id) object forKey:(NSString *) aKey {
  [[NSUserDefaults standardUserDefaults] setObject:object
                                            forKey:aKey];
}

- (void) storeBool:(BOOL) aBool forKey:(NSString *) aKey {
  [[NSUserDefaults standardUserDefaults] setBool:aBool
                                          forKey:aKey];
}

- (void) removeObjectForKey:(NSString *) aKey {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKey];
}



@end
