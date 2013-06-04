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

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsKeychainManager.h"
#import "Lumberjack.h"
#import "SFHFKeychainUtils.h"
#import "NSError+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *LjsKeychainManagerErrorDomain = @"com.littlejoysoftware.ljs Keychain Manager Error";


@interface LjsKeychainManager ()

/** @name Utility */
- (NSString *) errorMessageForCode:(LjsKeychainManagerErrorCodes) aCode;
- (BOOL) isValidString:(NSString *) string;


@end

/**
 It is a common design pattern to have a username stored in defaults and a 
 password optionally (user controlled) stored in the Keychain.  
 LjsKeychainManager provides methods to bridge the Keychain Access API (using
 the SFHFKeychainUtils) and the User Defaults API.
 
 @warn Class could use more testing.
 */
@implementation LjsKeychainManager


- (id) init {
  self = [super init];
  if (self) {
    // keep this around - sometimes is it helpful to see what is in the defaults      
    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // NSDictionary *dict = [defaults dictionaryRepresentation];
    // DDLogDebug(@"dict = %@", dict);
  }
  return self;
}

#pragma mark Username Stored in Defaults

/**
 used to determine the validity of a username
 
 currently there are no restrictions on usernames other than they not be
 nil or empty
 
 @param username the name to check
 @return true if username is a non-nil, non-empty string
 */
- (BOOL) isValidUsername:(NSString *) username {
  return [self isValidString:username];
}

/**
 used to determine the validity of a password
 
 currently there are no restrictions on passwords other than they not be
 nil or empty
 
 @param password the password to check
 @return true iff password is a non-nil, non-empty string
 */
- (BOOL) isValidPassword:(NSString *) password {
  return [self isValidString:password];
}

/**
 @return true iff key is non-nil and non empty
 @param key the key to test
 */
- (BOOL) isValidKey:(NSString *) key {
  return [self isValidString:key];
}

/**
 @return true iff service name is non-nil and non empty
 @param serviceName the service name to test
 */
- (BOOL) isValidServiceName:(NSString *) serviceName {
  return [self isValidString:serviceName];
}


/**
 queries the NSUserDefaults standardUserDefaults with the
 @param key the defaults key
 @return if there is no entry, will return nil
 */
- (NSString *) usernameStoredInDefaultsForKey:(NSString *) key {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *username = [defaults stringForKey:key];
  
  NSString *result = nil;
  if ([self isValidUsername:username]) {
    result = username;
  }
  return result;  
}


/**
 deletes the value (if any) for the keyyfrom the NSUserDefaults standardUserDefaults
 @return true iff the delete was successful
 @param key the key under which to look for the username
 @param error catches invalid key errors
 */
- (BOOL) deleteUsernameInDefaultsForKey:(NSString *)key error:(NSError **)error {
  BOOL result = NO;
  if (![self isValidKey:key]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadKeyError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadKeyError
                         localizedDescription:message];
    }
    return NO;
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    result = YES;
  }
  return result;
}


/**
 sets the value for key NSUserDefaults
 standardUserDefaults
 @return true iff the username was succesfully set
 @param username the new value for username
 @param key the key to store the username under
 @param error catches bad key and bad username
 */
- (BOOL) setDefaultsUsername:(NSString *) username forKey:(NSString *) key error:(NSError **) error {
  if (![self isValidUsername:username]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadUsernameError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadUsernameError
                         localizedDescription:message];
    }
    return NO;
  }
  
  if (![self isValidKey:key]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadKeyError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadKeyError
                         localizedDescription:message];
    }
    return NO;
  }

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:username forKey:key];
  return YES;
}

#pragma mark Should Use Key Chain in Defaults

/**

 
 @return the BOOL value of the item stored in defaults under key
 @param key the key under which the should use keychain value is stored
 @param error catches bad key
 */
- (BOOL) shouldUseKeychainWithKey:(NSString  *) key error:(NSError **) error {
  if (![self isValidKey:key]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadKeyError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadKeyError
                         localizedDescription:message];
    }
    return NO;
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
  }
}


/**
 @return true iff the delete was successful
 @param key the key to lookup (and delete) from defaults
 @param error catches bad key
 */
- (BOOL) deleteShouldUseKeychainInDefaults:(NSString *) key error:(NSError **) error {
  if (![self isValidKey:key]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadKeyError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadKeyError
                         localizedDescription:message];
    }
    return NO;
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    return YES;
  }
}


/**
 @return sets defaults value to shouldUse for key 
 @param shouldUse the new value to store in the User Defaults
 @param key the key under which to store the shouldUse value
 @param error catches bad key
 */
- (BOOL) setDefaultsShouldUseKeychain:(BOOL) shouldUse key:(NSString *) key error:(NSError **) error {
  if (![self isValidKey:key]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadKeyError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadKeyError
                         localizedDescription:message];
    }
    return NO;
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldUse forKey:key];
    return YES;
  }
}

#pragma mark Key Chain Interaction

/**
 queries the keychain to see if a password is stored for username
 @param username the name we want the password for
 @param serviceName the keychain service name
 @param error catches bad usernames
 @return true iff the keychain has a password for the username
 */
- (BOOL) hasKeychainPasswordForUsername:(NSString *) username 
                            serviceName:(NSString *) serviceName
                                  error:(NSError **) error {
  
  if (![self isValidUsername:username]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadUsernameError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadUsernameError
                         localizedDescription:message];
    }    
    return NO;
  }
  
  if (![self isValidServiceName:serviceName]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadKeyError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadKeyError
                         localizedDescription:message];
    }    
    return NO;

  }
  

  NSString *fetchedPwd = [SFHFKeychainUtils getPasswordForUsername:username
                                                    andServiceName:serviceName
                                                             error:error];
  
  /*
  if (error != NULL) {
    DDLogError(@"%@", [*error localizedDescription]);
  }
   */
  
  if ([self isValidPassword:fetchedPwd] == NO) {
    if (error != NULL) {
      DDLogError(@"%@", [*error localizedDescription]);
    }
    return NO;
  } else {
    return YES;
  }
}


/**
 queries the keychain for the password stored for username
 
 @return returns the password stored for the username in the defaults or nil if
 no password is found
 @param key the key under the username is stored
 @param serviceName the keychain service name
 @param error catches bad key and Keychain Access error
 */
- (NSString *) keychainPasswordForUsernameInDefaultsWithKey:(NSString *) key
                                                serviceName:(NSString *) serviceName
                                                      error:(NSError **) error {
  if (![self isValidKey:key]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadKeyError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadKeyError
                         localizedDescription:message];
    }
    return nil;
  }
  
  if (![self isValidServiceName:serviceName]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadServiceNameError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadServiceNameError
                         localizedDescription:message];
    }    
    return nil;
  }
  
  NSString *username = [self usernameStoredInDefaultsForKey:key];
  
  if ([self isValidUsername:username] == NO) {
    return nil;
  }
  
  NSError *fetchError = nil;
  NSString *result = [SFHFKeychainUtils getPasswordForUsername:username
                                                andServiceName:serviceName
                                                      error:&fetchError];
  
  
  if (fetchError != nil) {
    if (error != NULL) {
      DDLogError(@"%@", [fetchError localizedDescription]);
      *error = fetchError;
    }
    return nil;
  }

  return result;
}

/**
 deletes the password for the keychain entry for the username

 @param username the username for the password we would like to delete
 @param serviceName the service name for the password
 @param error catches Keychain Access error
 @return true iff password was deleted
 */
- (BOOL) keychainDeletePasswordForUsername:(NSString *) username 
                               serviceName:(NSString *) serviceName
                                     error:(NSError **) error {
  return [SFHFKeychainUtils deleteItemForUsername:username
                                   andServiceName:serviceName
                                            error:error];
}

/**
 stores a username and password to the keychain
 
 @return true iff store was successful
 @param username the username for the password we would like to store
 @param serviceName the service name for the password
 @param password the password to store for the username
 @param error catches Keychain Access error
 */
- (BOOL) keychainStoreUsername:(NSString *) username 
                   serviceName:(NSString *) serviceName
                      password:(NSString *) password
                         error:(NSError **) error {

  return [SFHFKeychainUtils storeUsername:username 
                              andPassword:password
                           forServiceName:serviceName
                           updateExisting:YES 
                                    error:error];
}

#pragma mark Synchronizing Key Chain and Defaults

/**
 synchronizes the Keychain and User Defaults
 
 if shouldUseKeychain is YES and username and password are valid, then the
 pair is stored to the keychain and the username is stored in the User Defaults
 
 if shouldUseKeychain is NO, then any existing password for username in the Keychain
 is deleted.  the username is still persisted to User Defaults.
 
 the value of shouldUseKeychain is persisted the User Defaults
 
 This method will fail fast, but it is possible that the defaults might be set
 and the keychain elements will not be updated
 
 @return true iff synchronization is successful
 @param username the username to persist to defaults
 @param usernameKey the key under which to persist the username 
 @param password the password to store
 @param shouldUseKeychainKey the key under which shouldUseKeychain value is stored
 @param shouldUseKeychain the value to store under shouldUseKeychainKey
 @param serviceName the service name for the password
 @param error catches Keychain Access error 
 */
- (BOOL) synchronizeKeychainAndDefaultsWithUsername:(NSString *) username
                                usernameDefaultsKey:(NSString *) usernameKey
                                           password:(NSString *) password
                       shouldUseKeychainDefaultsKey:(NSString *) shouldUseKeychainKey
                                  shouldUseKeyChain:(BOOL) shouldUseKeychain
                                        serviceName:(NSString *) serviceName
                                              error:(NSError **) error {
  if (![self isValidUsername:username]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadUsernameError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadUsernameError
                         localizedDescription:message];
    }
    return NO;
  }
  
  if (![self isValidKey:usernameKey]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadKeyError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadKeyError
                         localizedDescription:message];
    }
    return NO;
  }
  
  if (![self isValidPassword:password]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadPasswordError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadPasswordError
                         localizedDescription:message];
    }
    return NO;
  }
  
  if (![self isValidKey:shouldUseKeychainKey]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadKeyError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadKeyError
                         localizedDescription:message];
    }
    return NO;
  }

  if (![self isValidServiceName:serviceName]) {
    NSString *message = [self errorMessageForCode:LjsKeychainManagerBadServiceNameError];
    DDLogError(@"%@", message);
    if (error != NULL) {
      *error = [LjsErrorFactory errorWithCode:LjsKeychainManagerBadServiceNameError
                         localizedDescription:message];
    }
    return NO;
  }
  
  
  if (![self setDefaultsShouldUseKeychain:shouldUseKeychain
                                      key:shouldUseKeychainKey
                                    error:error]) {
    return NO;
  }
  
  if (![self setDefaultsUsername:username forKey:usernameKey error:error]) {
    return NO;
  }
  
  [[NSUserDefaults standardUserDefaults] synchronize];

  
  if (shouldUseKeychain == YES) {

    return [self keychainStoreUsername:username
                           serviceName:serviceName
                              password:password
                                 error:error];
    

  } else {
    BOOL exists = [self hasKeychainPasswordForUsername:username
                                           serviceName:serviceName
                                                 error:error];    
    if (exists == YES) {
      return [self keychainDeletePasswordForUsername:username
                                         serviceName:serviceName
                                               error:error];
    } else {
      return YES;
    }
  }
}

#pragma mark Utility

/**
 Sets the error using Reporter API
 @param code the error code use
 @param error the error to populate
 @return always returns YES - return is include to suppress analyzer warnings
 */
- (NSString *) errorMessageForCode:(LjsKeychainManagerErrorCodes)aCode {
  switch (aCode) {
    case LjsKeychainManagerBadKeyError:
      return NSLocalizedString(@"The key you used was nil or empty, which is not allowed.",
                               @"part of error message");
    case LjsKeychainManagerBadPasswordError:
      return NSLocalizedString(@"The password you used was nil or empty, which is not allowed.",
                               @"part of error message");
    case LjsKeychainManagerBadUsernameError:
      return NSLocalizedString(@"The username you used was nil or empty, which is not allowed.",
                                   @"part of error message");
    case LjsKeychainManagerBadServiceNameError:
      return NSLocalizedString(@"The service name you used was nil or empty, which is not allowed.",
                               @"part of error message");
    default: {
      DDLogError(@"fell through switch for code: %d; will return generic error", (int)aCode);
      return NSLocalizedString(@"Encountered a unexpected error.", nil);
    }
  }
}


/**
 @return true iff string is non-nil and non-empty
 @param string the string to test
 */
- (BOOL) isValidString:(NSString *) string {
  return string != nil && [string length] != 0;
}


@end
