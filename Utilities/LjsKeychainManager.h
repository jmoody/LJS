#import <Foundation/Foundation.h>
#import "Reporter.h"

extern NSString *LjsKeychainManagerErrorDomain;

typedef enum {
  // a sublime number
  LjsKeychainManagerBadKeyError = 4390116,
  LjsKeychainManagerBadUsernameError,
  LjsKeychainManagerBadPasswordError,
  LjsKeychainManagerBadServiceNameError
} LjsKeychainManagerErrorCodes;

@interface LjsKeychainManager : NSObject 

/**
 helps generate NSError instances
 */
@property (nonatomic, strong) Reporter *reporter;

#pragma mark Username Stored in Defaults

/** @name Username and Password Validity */
- (BOOL) isValidUsername:(NSString *) username;
- (BOOL) isValidPassword:(NSString *) password;
- (BOOL) isValidServiceName:(NSString *) serviceName;
- (BOOL) isValidKey:(NSString *) key;

/** @name Managing Username in Defaults */
- (NSString *) usernameStoredInDefaultsForKey:(NSString *) key;
- (BOOL) deleteUsernameInDefaultsForKey:(NSString *) key error:(NSError **) error;
- (BOOL) setDefaultsUsername:(NSString *) username forKey:(NSString *) key error:(NSError **) error;


#pragma mark Should Use Key Chain in Defaults

/** @name Managing Whether the Keychain Should be Used in Defaults */
- (BOOL) shouldUseKeychainWithKey:(NSString  *) key error:(NSError **) error;
- (BOOL) deleteShouldUseKeychainInDefaults:(NSString *) key error:(NSError **) error;
- (BOOL) setDefaultsShouldUseKeychain:(BOOL) shouldUse key:(NSString *) key error:(NSError **) error;



#pragma mark Key Chain Interaction

/** @name Interacting with the Keychain */
- (BOOL) hasKeychainPasswordForUsername:(NSString *) username 
                            serviceName:(NSString *) serviceName
                                  error:(NSError **) error;

- (NSString *) keychainPasswordForUsernameInDefaults:(NSString *) key
                                         serviceName:(NSString *) serviceName
                                               error:(NSError **) error;

- (BOOL) keychainDeletePasswordForUsername:(NSString *) username 
                               serviceName:(NSString *) serviceName
                                     error:(NSError **) error;
- (BOOL) keychainStoreUsername:(NSString *) username 
                   serviceName:(NSString *) serviceName
                      password:(NSString *) password
                         error:(NSError **) error;

#pragma mark Synchronizing Key Chain and Defaults
/** @name Synchronizing with Defaults */
- (BOOL) synchronizeKeychainAndDefaultsWithUsername:(NSString *) username
                                usernameDefaultsKey:(NSString *) usernameKey
                                           password:(NSString *) password
                       shouldUseKeychainDefaultsKey:(NSString *) shouldUseKeychainKey
                                  shouldUseKeyChain:(BOOL) shouldUseKeychain
                                        serviceName:(NSString *) serviceName
                                              error:(NSError **) error;



/** @name Utility */
- (void) ljsKeychainManagerErrorWithCode:(NSUInteger) code
                                   error:(NSError **) error;
- (void) logKeychainError:(NSError *) error;
- (BOOL) isValidString:(NSString *) string;



@end
