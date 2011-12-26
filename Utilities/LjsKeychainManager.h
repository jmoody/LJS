#import <Foundation/Foundation.h>

extern NSString *LjsKeychainManagerErrorDomain;

typedef enum {
  LjsKeychainManagerBadKeyError = 1,
  LjsKeychainManagerBadUsernameError,
  LjsKeychainManagerBadPasswordError
} LjsKeychainManagerErrorCodes;

@interface LjsKeychainManager : NSObject 

#pragma mark Username Stored in Defaults

/** @name Username and Password Validity */
- (BOOL) isValidUsername:(NSString *) username;
- (BOOL) isValidPassword:(NSString *) password;
- (BOOL) isValidKey:(NSString *) key;

/** @name Managing Username in Defaults */
- (NSString *) usernameStoredInDefaultsForKey:(NSString *) key;
- (BOOL) deleteUsernameInDefaultsForKey:(NSString *) key error:(NSError **) error;
- (BOOL) setDefaultsUsername:(NSString *) username forKey:(NSString *) key error:(NSError **) error;


#pragma mark Should Use Key Chain in Defaults

/** @name Managing Whether the Keychain Should be Used in Defaults */
- (BOOL) shouldUseKeyChainWithKey:(NSString  *) key error:(NSError **) error;
- (BOOL) deleteShouldUseKeyChainInDefaults:(NSString *) key error:(NSError **) error;
- (BOOL) setDefaultsShouldUseKeyChain:(BOOL) shouldUse key:(NSString *) key error:(NSError **) error;



#pragma mark Key Chain Interaction

/** @name Interacting with the Keychain */
- (BOOL) hasKeychainPasswordForUsername:(NSString *) username 
                            serviceName:(NSString *) serviceName
                                  error:(NSError **) error;

- (NSString *) keychainPasswordForUsernameInDefaults:(NSString *) key
                                         serviceName:(NSString *) serviceName
                                               error:(NSError **) error;

- (BOOL) keyChainDeletePasswordForUsername:(NSString *) username 
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
- (NSError *) ljsKeyChainManagerErrorWithCode:(NSUInteger) code
                                     userInfo:(NSDictionary *) userInfo;
- (void) logKeychainError:(NSError *) error;

@end
