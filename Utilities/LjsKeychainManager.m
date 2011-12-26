#import "LjsKeychainManager.h"
#import "Lumberjack.h"
#import "SFHFKeychainUtils.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *LjsKeychainManagerErrorDomain = @"com.littlejoysoftware.ljs LJS Keychain Manager Error";

/**
 LjsKeychainManager provides methods to bridge the Keychain Access API and the 
 User Defaults API.
 */
@implementation LjsKeychainManager


- (void) dealloc {
  [super dealloc];
}

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
  return username != nil && [username length] != 0;
}

/**
 used to determine the validity of a password
 
 currently there are no restrictions on passwords other than they not be
 nil or empty
 
 @param password the password to check
 @return true iff password is a non-nil, non-empty string
 */
- (BOOL) isValidPassword:(NSString *) password {
  return password != nil && [password length] != 0;
}

- (BOOL) isValidKey:(NSString *) key {
  return key != nil && [key length] != 0;
}

/**
 queries the NSUserDefaults standardUserDefaults with the AgChoiceUsernameDefaultsKey
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
 deletes the value (if any) for the key AgChoiceUsernameDefaultsKey from the
 NSUserDefaults standardUserDefaults
 */
- (BOOL) deleteUsernameInDefaultsForKey:(NSString *)key error:(NSError **)error {
  BOOL result = NO;
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setNilValueForKey:key];
    result = YES;
  }
  return result;
}


/**
 sets the value for key AgChoiceUsernameDefaultsKey in the NSUserDefaults
 standardUserDefaults
 @param username the new value for AgChoiceUsernamDefaultsKey
 */
- (BOOL) setDefaultsUsername:(NSString *) username forKey:(NSString *) key error:(NSError **) error {
  if (![self isValidUsername:username]) {
    if (*error != NULL) {
      *error = [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadUsernameError
                                            userInfo:nil];
    }
    return NO;
  }
  
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
    return NO;
  }

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:username forKey:key];
  return YES;
}

#pragma mark Should Use Key Chain in Defaults

/**
 looks up the value of AgChoiceUseKeychainDefaultsKey in NSUserDefaults
 standardUserDefaults
 
 @return true iff value for key is AgChoiceYES
 */
- (BOOL) shouldUseKeyChainWithKey:(NSString  *) key error:(NSError **) error {
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
    return NO;
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
  }
}


/**
 removes the value of key AgChoiceUseKeychainDefaultsKey from NSUserDefaults
 standardUserDefaults
 */
- (BOOL) deleteShouldUseKeyChainInDefaults:(NSString *) key error:(NSError **) error {
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
    return NO;
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setNilValueForKey:key];
    return YES;
  }
}


/**
 sets the value of key AgChoiceUserKeycahinDefaultsKey in NSUserDefaults
 standardUserDefaults
 @param shouldUse the new value to store in the User Defaults
 */
- (BOOL) setDefaultsShouldUseKeyChain:(BOOL) shouldUse key:(NSString *) key error:(NSError **) error {
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
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
 @return true iff the keychain has a password for the username
 */
- (BOOL) hasKeychainPasswordForUsername:(NSString *) username 
                            serviceName:(NSString *) serviceName
                                  error:(NSError **) error {
  BOOL result = NO;
  if ([self isValidUsername:username]) {
    NSError *fetchError;
    NSString *fetchedPwd = [SFHFKeychainUtils getPasswordForUsername:username
                                                      andServiceName:serviceName
                                                               error:&fetchError];
    if (fetchError != nil) {
      [self logKeychainError:fetchError];
      if (*error != NULL) {
        *error = fetchError;
      }
    } else {
      result = [self isValidPassword:fetchedPwd];
    }
  }
  return result;
}


/**
 queries the keychain for the password stored for username
 
 if there is an error, it is logged
 
 @return returns the password stored for the username in the defaults or nil if
 no password is found
 */
- (NSString *) keychainPasswordForUsernameInDefaults:(NSString *) key
                                         serviceName:(NSString *) serviceName
                                               error:(NSError **) error {
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
    return nil;
  }
  
  NSString *username = [self usernameStoredInDefaultsForKey:key];
  
  NSError *fetchError;
  NSString *result = [SFHFKeychainUtils getPasswordForUsername:username
                                                andServiceName:serviceName
                                                         error:&fetchError];
  
  if (fetchError != nil) {
    [self logKeychainError:fetchError];
    if (*error != NULL) {
      *error = fetchError;
    }
  }
  return result;
}

/**
 deletes the password for the keychain entry for the username
 
 if there is an error, it is logged
 
 @param username the username for the password we would like to delete
 */
- (BOOL) keyChainDeletePasswordForUsername:(NSString *) username 
                               serviceName:(NSString *) serviceName
                                     error:(NSError **) error {
  return [SFHFKeychainUtils deleteItemForUsername:username
                                   andServiceName:serviceName
                                            error:error];
}

/**
 stores a username and password to the keychain
 
 if there is an error, it is logged
 
 existing values are overwritten
 
 @param username the username to store
 @param password the password to store for the username
 */
- (BOOL) keychainStoreUsername:(NSString *) username 
                   serviceName:(NSString *) serviceName
                      password:(NSString *) password
                         error:(NSError **) error {

  return [SFHFKeychainUtils storeUsername:username andPassword:password
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
 
 @param username a non-nil non-empty string
 @param password a non-nil non-empty string
 @param shouldUseKeychain if YES, will persist username/password to keychain,
 otherwise not
 */
- (BOOL) synchronizeKeychainAndDefaultsWithUsername:(NSString *) username
                                usernameDefaultsKey:(NSString *) usernameKey
                                           password:(NSString *) password
                       shouldUseKeychainDefaultsKey:(NSString *) shouldUseKeychainKey
                                  shouldUseKeyChain:(BOOL) shouldUseKeychain
                                        serviceName:(NSString *) serviceName
                                              error:(NSError **) error {
  if (![self isValidUsername:username]) {
    if (*error != NULL) {
      [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadUsernameError
                                   userInfo:nil];
    }
    return NO;
  }
  
  if (![self isValidKey:usernameKey]) {
    if (*error != NULL) {
      [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                   userInfo:nil];
    }
    return NO;
  }
  
  if (![self isValidPassword:password]) {
    if (*error != NULL) {
      [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadPasswordError
                                   userInfo:nil];
    }
    return NO;
  }
  
  if (![self isValidKey:shouldUseKeychainKey]) {
    if (*error != NULL) {
      [self ljsKeyChainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                   userInfo:nil];
    }
    return NO;
  }

  if (![self setDefaultsShouldUseKeyChain:shouldUseKeychain
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
    return [self keyChainDeletePasswordForUsername:username
                                       serviceName:serviceName
                                             error:error];
  }
}

#pragma mark Utility

- (NSError *) ljsKeyChainManagerErrorWithCode:(NSUInteger) code
                                     userInfo:(NSDictionary *)userInfo {
  return [NSError errorWithDomain:LjsKeychainManagerErrorDomain
                             code:code
                         userInfo:userInfo];
}


/**
 prints error information to the log stream(s)
 @param error the error to log
 */
- (void) logKeychainError:(NSError *) error {
  NSInteger code = [error code];
  NSString *message = [error localizedDescription];
  DDLogError(@"%d: %@", code, message);
}

@end
