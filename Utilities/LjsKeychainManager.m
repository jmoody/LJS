#import "LjsKeychainManager.h"
#import "Lumberjack.h"
#import "SFHFKeychainUtils.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSString *LjsSecurityManagerUsernameDefaultsKey = @"com.littlejoysoftware.ljs LJS Security Manager  UserName Defaults Key";
static NSString *LjsSecurityManagerUseKeychainDefaultsKey = @"com.littlejoysoftware.ljs LJS Security Manager  Use Keychain Defaults Key";
static NSString *LjsSecurityManagerKeychainServiceName = @"com.littlejoysoftware.ljs LJS Security Manager ";
static NSString *LjsSecurityManagerYES = @"YES";
static NSString *LjsSecurityManagerNO = @"NO";

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
  BOOL result;
  if (username != nil && [username length] != 0) {
    result = YES;
  } else {
    result = NO;
  }
  return result;
}

/**
 used to determine the validity of a password
 
 currently there are no restrictions on passwords other than they not be
 nil or empty
 
 @param password the password to check
 @return true iff password is a non-nil, non-empty string
 */
- (BOOL) isValidPassword:(NSString *) password {
  BOOL result;
  if (password != nil && [password length] != 0) {
    result = YES;
  } else {
    result = NO;
  }
  return result;
}

/**
 queries the NSUserDefaults standardUserDefaults with the AgChoiceUsernameDefaultsKey
 
 @return if there is no entry, will return nil
 */
- (NSString *) usernameStoredInDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *username = [defaults stringForKey:LjsSecurityManagerUsernameDefaultsKey];
  
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
- (void) deleteUsernameInDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setNilValueForKey:LjsSecurityManagerUsernameDefaultsKey];
}


/**
 sets the value for key AgChoiceUsernameDefaultsKey in the NSUserDefaults
 standardUserDefaults
 @param username the new value for AgChoiceUsernamDefaultsKey
 */
- (void) setDefaultsUsername:(NSString *) username {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:username forKey:LjsSecurityManagerUsernameDefaultsKey];
}

#pragma mark Should Use Key Chain in Defaults

/**
 looks up the value of AgChoiceUseKeychainDefaultsKey in NSUserDefaults
 standardUserDefaults
 
 @return true iff value for key is AgChoiceYES
 */
- (BOOL) shouldUseKeyChain {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *value = [defaults stringForKey:LjsSecurityManagerUseKeychainDefaultsKey];
  BOOL result;
  if (value != nil && [value isEqualToString:LjsSecurityManagerYES]) {
    result = YES;
  } else {
    result = NO;
  }
  return result;
}


/**
 removes the value of key AgChoiceUseKeychainDefaultsKey from NSUserDefaults
 standardUserDefaults
 */
- (void) deleteShouldUseKeyChainInDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setNilValueForKey:LjsSecurityManagerUseKeychainDefaultsKey];
}

/**
 sets the value of key AgChoiceUserKeycahinDefaultsKey in NSUserDefaults
 standardUserDefaults
 @param shouldUse the new value to store in the User Defaults
 */
- (void) setDefaultsShouldUseKeyChain:(BOOL) shouldUse {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (shouldUse == YES) {
    [defaults setObject:LjsSecurityManagerYES forKey:LjsSecurityManagerUseKeychainDefaultsKey];
  } else {
    [defaults setObject:LjsSecurityManagerNO forKey:LjsSecurityManagerUseKeychainDefaultsKey];
  }
}

#pragma mark Key Chain Interaction

/**
 prints error information to the log stream(s)
 @param error the error to log
 */
- (void) logKeychainError:(NSError *) error {
  NSInteger code = [error code];
  NSString *message = [error localizedDescription];
  DDLogError(@"%d: %@", code, message);
}


/**
 queries the keychain to see if a password is stored for username
 @param username the name we want the password for
 @return true iff the keychain has a password for the username
 */
- (BOOL) hasKeychainPasswordForUsername:(NSString *) username {
  BOOL result = NO;
  if ([self isValidUsername:username]) {
    NSError *error;
    NSString *fetchedPwd = [SFHFKeychainUtils getPasswordForUsername:username
                                                      andServiceName:LjsSecurityManagerKeychainServiceName
                                                               error:&error];
    if (error != nil) {
      [self logKeychainError:error];
    } else {
      result = (fetchedPwd != nil && [fetchedPwd length] != 0);
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
- (NSString *) keyChainPasswordForUsernameInDefaults {
  NSString *result = nil;
  NSString *username = [self usernameStoredInDefaults];
  if ([self isValidUsername:username]) {
    if ([self hasKeychainPasswordForUsername:username]) {
      NSError *error;
      NSString *fetched = [SFHFKeychainUtils getPasswordForUsername:username
                                                     andServiceName:LjsSecurityManagerKeychainServiceName
                                                              error:&error];
      
      if (error != nil) {
        [self logKeychainError:error];
      } else {
        result = fetched;
      }
    }
  }
  return result;
}

/**
 deletes the password for the keychain entry for the username
 
 if there is an error, it is logged
 
 @param username the username for the password we would like to delete
 */
- (void) keyChainDeletePasswordForUsername:(NSString *) username {
  if ([self isValidUsername:username]) {
    if ([self hasKeychainPasswordForUsername:username]) {
      NSError *error;
      [SFHFKeychainUtils deleteItemForUsername:username
                                andServiceName:LjsSecurityManagerKeychainServiceName
                                         error:&error];
      
      if (error != nil) {
        [self logKeychainError:error];
      }
    }
  }
}

/**
 stores a username and password to the keychain
 
 if there is an error, it is logged
 
 existing values are overwritten
 
 @param username the username to store
 @param password the password to store for the username
 */
- (void) keychainStoreUsername:(NSString *) username password:(NSString *) password {
  BOOL update = [self hasKeychainPasswordForUsername:username];
  NSError *error;
  [SFHFKeychainUtils storeUsername:username andPassword:password
                    forServiceName:LjsSecurityManagerKeychainServiceName updateExisting:update error:&error];
  if (error != nil) {
    [self logKeychainError:error];
  }
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
- (void) synchronizeKeychainAndDefaultsWithUsername:(NSString *) username
                                           password:(NSString *) password
                                  shouldUseKeyChain:(BOOL) shouldUseKeychain {
  //DDLogDebug(@"synchronizing with username: %@, password: %@, should use keychain: %d",
  //           username, password, shouldUseKeychain);
  if ([self isValidUsername:username]) {
    [self setDefaultsUsername:username];
  } else {
    DDLogError(@"%@ is not a valid username - doing nothing", username);
  }
  
  if (shouldUseKeychain == YES) {
    if ([self isValidPassword:password]) {
      [self keychainStoreUsername:username password:password];
    } else {
      DDLogError(@"%@ is not a valid password - doing nothing", password);
    }
  } else {
    [self keyChainDeletePasswordForUsername:username];
  }
  [self setDefaultsShouldUseKeyChain:shouldUseKeychain];
  [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
