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

#import "LjsFileBackedKeyStore.h"
#import "Lumberjack.h"
#import "LjsFileUtilities.h"
#import "LjsValidator.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsFileBackedKeyStore

@synthesize filepath;
@synthesize store;

#pragma mark Memory Management
- (void) dealloc {
   //DDLogDebug(@"deallocating %@", [self class]);
}

- (id) initWithFileName:(NSString *)aFilename 
          directoryPath:(NSString *)aDirectoryPath 
                  error:(NSError *__autoreleasing *)error {
  self = [super init];
  if (self != nil) {
    NSAssert1([LjsValidator stringIsNonNilOrEmpty:aFilename],
              @"filename must not be nil or empty - < %@ >", aFilename);
    NSAssert1([LjsValidator stringIsNonNilOrEmpty:aDirectoryPath] != 0, 
              @"directory path must be non-nil and non-empty - < %@ >", aDirectoryPath);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    BOOL directoryExists = [LjsFileUtilities ensureSaveDirectory:aDirectoryPath
                                               existsWithManager:fm];
    if (directoryExists == NO) {
      NSString *message = NSLocalizedString(@"Could not create directory", nil);
      DDLogError(@"%@", [NSString stringWithFormat:@"%@: %@ - returning nil",
                         message, aDirectoryPath]);
      if (error != NULL) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:aDirectoryPath
                                                             forKey:LjsFileUtilitiesFileOrDirectoryErrorUserInfoKey];

        *error = [NSError errorWithDomain:LjsFileUtilitiesErrorDomain
                                     code:LjsFileUtilitiesFileDoesNotExistErrorCode 
                     localizedDescription:message
                            otherUserInfo:userInfo];
      }
      return nil;
    }
    
    self.filepath = [aDirectoryPath stringByAppendingPathComponent:aFilename];
    
    BOOL fileExists = [fm fileExistsAtPath:self.filepath];
    if (fileExists == NO) {
      self.store = [NSMutableDictionary dictionary];
      BOOL writeSucceeded = [LjsFileUtilities writeDictionary:self.store
                                                       toFile:self.filepath
                                                        error:error];
      if (writeSucceeded == NO) {
        // writing failed - bail out (error and messages handled in write selector)
        return nil;
      } 
    } else {

      NSDictionary *dict = [LjsFileUtilities readDictionaryFromFile:self.filepath
                                                              error:error];
      if (dict == nil) {
        // reading failed - bail out (error and messages handled in read selector)
        return nil;
      }
      self.store = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
  }
  return self;
}


- (id) initWithFileName:(NSString *) aFilename
          directoryPath:(NSString *) aDirectoryPath 
           defaultStore:(NSDictionary *) aStore
      overwriteExisting:(BOOL) shouldOverwrite
                  error:(NSError **) error {
  self = [super init];
  if (self) {
    NSAssert1([LjsValidator stringIsNonNilOrEmpty:aFilename],
              @"filename must not be nil or empty - < %@ >", aFilename);
    NSAssert1([LjsValidator stringIsNonNilOrEmpty:aDirectoryPath] != 0, 
              @"directory path must be non-nil and non-empty - < %@ >", aDirectoryPath);
    NSAssert1(aStore != nil && [aStore count] != 0, 
              @"the default store must not be nil or empty: < %@ >", aStore);
    
      
    NSFileManager *fm = [NSFileManager defaultManager];
    
    BOOL directoryExists = [LjsFileUtilities ensureSaveDirectory:aDirectoryPath
                                               existsWithManager:fm];
    if (directoryExists == NO) {
      NSString *message = NSLocalizedString(@"Could not create directory", nil);
      DDLogError(@"%@", [NSString stringWithFormat:@"%@: %@ - returning nil",
                         message, aDirectoryPath]);
      if (error != NULL) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:aDirectoryPath
                                                             forKey:LjsFileUtilitiesFileOrDirectoryErrorUserInfoKey];
        *error = [NSError errorWithDomain:LjsFileUtilitiesErrorDomain
                                     code:LjsFileUtilitiesFileDoesNotExistErrorCode 
                     localizedDescription:message
                            otherUserInfo:userInfo];
      }

      return nil;
    }
    
    self.filepath = [aDirectoryPath stringByAppendingPathComponent:aFilename];

    BOOL fileExists = [fm fileExistsAtPath:self.filepath];
    
    if (fileExists == NO) {
      BOOL writeSucceeded = [LjsFileUtilities writeDictionary:aStore
                                                       toFile:self.filepath
                                                        error:error];
      if (writeSucceeded == NO) {
        // writing failed - bail out (error and messages handled in write selector)
        return nil;
      } 
      self.store = [NSMutableDictionary dictionaryWithDictionary:aStore];
    } else {
      if (shouldOverwrite == YES) {
        BOOL writeSucceeded = [LjsFileUtilities writeDictionary:aStore
                                                         toFile:self.filepath
                                                          error:error];
        if (writeSucceeded == NO) {
          // writing failed - bail out (error and messages handled in write selector)
          return nil;
        } 
        self.store = [NSMutableDictionary dictionaryWithDictionary:aStore];
      } else {
        NSDictionary *dict = [LjsFileUtilities readDictionaryFromFile:self.filepath
                                                                error:error];
        if (dict == nil) {
          // reading failed - bail out (error and messages handled in read selector)
          return nil;
        }
        self.store = [NSMutableDictionary dictionaryWithDictionary:dict];
      }
    }
  }
  return self;
}

- (NSArray *) allKeys {
  return [self.store allKeys];
}

- (void) removeKeys:(NSArray *) keys {
  [self.store removeObjectsForKeys:keys];
  [LjsFileUtilities writeDictionary:self.store toFile:self.filepath error:nil];
}

- (NSString *) stringForKey:(NSString *) aKey 
               defaultValue:(NSString *) aDefault 
             storeIfMissing:(BOOL) aPersistMissing {
  NSString *result = (NSString *) [self.store objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [self storeObject:aDefault forKey:aKey];
  }
  if (result == nil) {
    result = aDefault;
  }
  return result;
}

- (NSNumber *) numberForKey:(NSString *) aKey 
               defaultValue:(NSNumber *) aDefault
             storeIfMissing:(BOOL) aPersistMissing {
  NSNumber *result = (NSNumber *) [self.store objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [self storeObject:aDefault forKey:aKey];
  }
  
  if (result == nil) {
    result = aDefault;
  }
  return result;
}

- (BOOL) boolForKey:(NSString *) aKey 
       defaultValue:(BOOL) aDefault
     storeIfMissing:(BOOL) aPersistMissing {
  NSNumber *number = [self numberForKey:aKey
                           defaultValue:nil
                         storeIfMissing:NO];
  
  if (number == nil && aPersistMissing) {
    number = [NSNumber numberWithBool:aDefault];
    [self storeObject:number forKey:aKey];
  }
  BOOL result;
  
  if (number == nil) {
    result = aDefault;
  } else {
    result = [number boolValue];
  }
  return result;
}


- (NSDate *) dateForKey:(NSString *) aKey
           defaultValue:(NSDate *) aDefault
         storeIfMissing:(BOOL) aPersistMissing {
  NSDate *result = (NSDate *) [self.store objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [self storeObject:aDefault forKey:aKey];
  }
  
  if (result == nil) {
    result = aDefault;
  }
  return result;
}

- (NSData *) dataForKey:(NSString *) aKey
           defaultValue:(NSData *) aDefault
         storeIfMissing:(BOOL) aPersistMissing {
  NSData *result = (NSData *) [self.store objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [self storeObject:aDefault forKey:aKey];
  }
  
  if (result == nil) {
    result = aDefault;
  }
  return result;
}

- (NSArray *) arrayForKey:(NSString *) aKey
             defaultValue:(NSArray *) aDefault
           storeIfMissing:(BOOL) aPersistMissing {
  NSArray *result = (NSArray *) [self.store objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [self storeObject:aDefault forKey:aKey];
  }
  
  if (result == nil) {
    result = aDefault;
  }
  return result;
}

- (NSDictionary *) dictionaryForKey:(NSString *) aKey
                       defaultValue:(NSDictionary *) aDefault
                     storeIfMissing:(BOOL) aPersistMissing {
  NSDictionary *result = (NSDictionary *) [self.store objectForKey:aKey];
  if (result == nil && aPersistMissing && aDefault != nil) {
    [self storeObject:aDefault forKey:aKey];
  }
  
  if (result == nil) {
    result = aDefault;
  }
  return result;
}




- (id) valueForDictionaryNamed:(NSString *) aDictName
                  withValueKey:(NSString *) aValueKey
                  defaultValue:(id) aDefaultValue
                storeIfMissing:(BOOL) aPersistMissing {
  id result = nil;
  
  NSDictionary *dict = [self dictionaryForKey:aDictName
                                 defaultValue:nil
                               storeIfMissing:NO];  
  if (dict == nil) {
    if (aPersistMissing == YES && aDefaultValue != nil) {
      dict = [NSDictionary dictionaryWithObject:aDefaultValue forKey:aValueKey];
      [self storeObject:dict forKey:aDictName];
    } 
  } else {
    result = [dict objectForKey:aValueKey];
    if (result == nil && aPersistMissing && aDefaultValue != nil) {
      NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
      [mdict setObject:aDefaultValue forKey:aValueKey];
      [self storeObject:mdict forKey:aDictName];
    }
  }
  
  if (result == nil) {
    result = aDefaultValue;
  }
  
  return result;
}

- (void) updateValueInDictionaryNamed:(NSString *) aDictName
                         withValueKey:(NSString *) aValueKey
                                value:(id) aValue {
  NSDictionary *dict = [self dictionaryForKey:aDictName
                                 defaultValue:nil
                               storeIfMissing:NO];
  if (dict == nil) {
    if (aValue != nil) {
      dict = [NSDictionary dictionaryWithObject:aValue forKey:aValueKey];
      [self storeObject:dict forKey:aDictName];
    } else {
      // nothing to do - dict is nil and value is nil
    }
  } else {
    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mdict setObject:aValue forKey:aValueKey];
    [self storeObject:mdict forKey:aDictName];
  }
}



- (void) storeObject:(id) object forKey:(NSString *) aKey {
  [self.store setObject:object forKey:aKey];
  [LjsFileUtilities writeDictionary:self.store toFile:self.filepath error:nil];
}

- (void) storeBool:(BOOL) aBool forKey:(NSString *) aKey {
  NSNumber *number = [NSNumber numberWithBool:aBool];
  [self storeObject:number forKey:aKey];
}

- (void) removeObjectForKey:(NSString *) aKey {
  [self.store removeObjectForKey:aKey];
  [LjsFileUtilities writeDictionary:self.store toFile:self.filepath error:nil];
}





@end
