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
#import "NSArray+LjsAdditions.h"
#import "NSString+LjsAdditions.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

typedef enum : NSUInteger {
  kDidChangeNotification = 0,
  kWillChangeNotification
} LjsFileBackedKeyStoreNotificationType;

#define kLjsFileBackedKeyStoreNotificationTypes @"did change", @"will change", nil

NSString *LjsFileBackedKeyStoreErrorDomain = @"Ljs File Backed Key Store Error";
NSUInteger const LjsFileBackedKeyStoreErrorCode = 4390116;



@interface LjsFileBackedKeyStore ()

- (id) initWithFileName:(NSString *)aFilename
          directoryPath:(NSString *)aDirectoryPath
shouldPostNotifications:(BOOL) aShouldPostNotifications
                  error:(NSError *__autoreleasing *)error;


@property (nonatomic, strong) NSMutableDictionary *store;
@property (nonatomic, copy) NSString *filepath;

- (void) postNotification:(LjsFileBackedKeyStoreNotificationType) aNotificationType;

@end

@implementation LjsFileBackedKeyStore

@synthesize filepath;
@synthesize store = _store;
@synthesize storeDidChangeNotificationName = _storeDidChangeNotificationName;
@synthesize storeWillChangeNotificationName = _storeWillChangeNotificationName;
@synthesize shouldPostNotifications;

#pragma mark - Memory Management

- (id) init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

+ (LjsFileBackedKeyStore *) sharedInstanceWithFilename:(NSString *) aFilename
                                         directoryPath:(NSString *) aDirectoryPath
                               shouldPostNotifications:(BOOL) aShouldPostNotifications
                                                 error:(NSError **) aError {
  static LjsFileBackedKeyStore *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[LjsFileBackedKeyStore alloc]
                      initWithFileName:aFilename
                      directoryPath:aDirectoryPath
                      shouldPostNotifications:aShouldPostNotifications
                      error:aError];
  });
  return sharedInstance;
}


- (id) initWithFileName:(NSString *)aFilename
          directoryPath:(NSString *)aDirectoryPath
shouldPostNotifications:(BOOL) aShouldPostNotifications
                  error:(NSError *__autoreleasing *)error {
  self = [super init];

  if (self == nil) {
    return nil;
  }
  
  self.store = nil;
  
  BOOL validFilename = [aFilename has_chars];
  NSAssert1(validFilename,
            @"filename must not be nil or empty - < %@ >", aFilename);
  BOOL validDirectory = [aDirectoryPath has_chars];
  NSAssert1(validDirectory != 0, 
            @"directory path must be non-nil and non-empty - < %@ >", aDirectoryPath);
  if (validFilename == NO || validDirectory == NO) {
    if (error != NULL) {
      *error = [NSError errorWithDomain:LjsFileUtilitiesErrorDomain
                                   code:LjsFileBackedKeyStoreErrorCode
                   localizedDescription:@"could not created keystore because of a problem with the arguments"];
    }
    return nil;
  }
  
  NSFileManager *fm = [NSFileManager defaultManager];
  
  BOOL directoryExists = [LjsFileUtilities ensureSaveDirectory:aDirectoryPath
                                             existsWithManager:fm];
  if (directoryExists == NO) {
    NSString *message = NSLocalizedString(@"Could not create directory",
                                          @"LJS:  error message translation is OPTIONAL");
    DDLogError(@"%@", [NSString stringWithFormat:@"%@: %@ - returning nil",
                       message, aDirectoryPath]);
    if (error != NULL) {
      NSDictionary *userInfo = [NSDictionary dictionaryWithObject:aDirectoryPath
                                                           forKey:LjsFileUtilitiesFileOrDirectoryErrorUserInfoKey];
      
      *error = [NSError errorWithDomain:LjsFileUtilitiesErrorDomain
                                   code:kLjsFileUtilitiesErrorCodeFileDoesNotExist
                   localizedDescription:message
                          otherUserInfo:userInfo];
    }
    return nil;
  }
  
  self.filepath = [aDirectoryPath stringByAppendingPathComponent:aFilename];
    
  BOOL fileExists = [fm fileExistsAtPath:self.filepath];
  if (fileExists == NO) {
    self.store = [NSMutableDictionary dictionary];
    // file does not exist - no need to post notification that we created it
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
  
  NSString *bundleId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
  _storeWillChangeNotificationName = [NSString stringWithFormat:@"%@ - '%@' file will change notification",
                                      bundleId, aFilename];
  _storeDidChangeNotificationName = [NSString stringWithFormat:@"%@ - '%@' file did change notification",
                                     bundleId, aFilename];
  self.shouldPostNotifications = aShouldPostNotifications;
  return self;
}


- (void) postNotification:(LjsFileBackedKeyStoreNotificationType) aNotificationType {
  if (self.shouldPostNotifications == YES) {
    NSString *name = nil;
    switch (aNotificationType) {
      case kDidChangeNotification: { name = self.storeDidChangeNotificationName; break; }
      case kWillChangeNotification: { name = self.storeWillChangeNotificationName; break; }
      default: {
        NSArray *types = [[NSArray alloc] initWithObjects:kLjsFileBackedKeyStoreNotificationTypes];
        DDLogError(@"notification type: '%d' was not in %@; will not post notification",
                   (int)aNotificationType, types);
        return;
      }
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:name
     object:self];
  }
}


- (NSArray *) allKeys {
  return [self.store allKeys];
}

- (void) removeKeys:(NSArray *) keys {
  [self.store removeObjectsForKeys:keys];
  [self postNotification:kWillChangeNotification];
  [LjsFileUtilities writeDictionary:self.store toFile:self.filepath error:nil];
  [self postNotification:kDidChangeNotification];
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
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"dictionary name" ifNil:aDictName];
  [reasons addReasonWithVarName:@"value key" ifNil:aValueKey];
  if ([reasons hasReasons]) {
    DDLogError([reasons explanation:@"cannot get value"
                        consequence:@"nil"]);
    return nil;
  }
    
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

- (BOOL) updateValueInDictionaryNamed:(NSString *) aDictName
                         withValueKey:(NSString *) aValueKey
                                value:(id) aValue {

  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"dictionary name" ifNilOrEmptyString:aDictName];
  [reasons addReasonWithVarName:@"value key" ifNilOrEmptyString:aValueKey];
  [reasons addReasonWithVarName:@"a value" ifNil:aValue];
  if ([reasons hasReasons]) {
    DDLogError([reasons explanation:@"cannot update value"
                        consequence:@"NO"]);
    return NO;
  }
  
  NSDictionary *dict = [self dictionaryForKey:aDictName
                                 defaultValue:nil
                               storeIfMissing:NO];
  if (dict == nil) {
    dict = [NSDictionary dictionaryWithObject:aValue forKey:aValueKey];
    [self storeObject:dict forKey:aDictName];
  } else {
    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mdict setObject:aValue forKey:aValueKey];
      [self storeObject:mdict forKey:aDictName];
    
  }
  return YES;
}



- (BOOL) storeObject:(id) object forKey:(NSString *) aKey {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"object" ifNil:object];
  [reasons addReasonWithVarName:@"key" ifNilOrEmptyString:aKey];
  if ([reasons hasReasons]) {
    DDLogError([reasons explanation:@"could not perform store"
                        consequence:@"NO"]);
    return NO;
  }

  [self postNotification:kWillChangeNotification];
  [self.store setObject:object forKey:aKey];
  NSError *writeError = nil;
  if ([LjsFileUtilities writeDictionary:self.store
                                 toFile:self.filepath
                                  error:&writeError] == NO) {
    DDLogError(@"could not store change - will not post 'did change' notification");
    return NO;
  }
  [self postNotification:kDidChangeNotification];
  return YES;
}

- (BOOL) storeBool:(BOOL) aBool forKey:(NSString *) aKey {
  NSNumber *number = [NSNumber numberWithBool:aBool];
  return [self storeObject:number forKey:aKey];
}

- (BOOL) removeObjectForKey:(NSString *) aKey {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"key" ifNilOrEmptyString:aKey];
  if ([reasons hasReasons]) {
    DDLogError([reasons explanation:@"could not remove key"
                        consequence:@"NO"]);
    return NO;
  }

  [self postNotification:kWillChangeNotification];
  NSError *writeError = nil;
  [self.store removeObjectForKey:aKey];
  if ([LjsFileUtilities writeDictionary:self.store
                                 toFile:self.filepath
                                  error:&writeError] == NO) {
    DDLogError(@"could not remove item - will not post 'did change' notification");
    return NO;
  }
  [self postNotification:kDidChangeNotification];
  return YES;
}


@end

