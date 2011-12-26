
#import <Foundation/Foundation.h>

@interface LjsKeychainManager : NSObject {
    
}

#pragma mark Username Stored in Defaults

/** @name Username and Password Validity */
- (BOOL) isValidUsername:(NSString *) username;
- (BOOL) isValidPassword:(NSString *) password;

/** @name Managing Username in Defaults */
- (NSString *) usernameStoredInDefaults;
- (NSString *) usernameStoredInDefaultsForKey:(NSString *) key;
- (void) deleteUsernameInDefaults;
- (void) setDefaultsUsername:(NSString *) username;

#pragma mark Should Use Key Chain in Defaults

/** @name Managing Whether the Keychain Should be Used in Defaults */
- (BOOL) shouldUseKeyChain;
- (void) deleteShouldUseKeyChainInDefaults;
- (void) setDefaultsShouldUseKeyChain:(BOOL) shouldUse;

#pragma mark Key Chain Interaction

/** @name Interacting with the Keychain */
- (void) logKeychainError:(NSError *) error;
- (BOOL) hasKeychainPasswordForUsername:(NSString *) username;
- (NSString *) keyChainPasswordForUsernameInDefaults;
- (void) keyChainDeletePasswordForUsername:(NSString *) username;
- (void) keychainStoreUsername:(NSString *) username password:(NSString *) password;

#pragma mark Synchronizing Key Chain and Defaults
/** @name Synchronizing with Defaults */
- (void) synchronizeKeychainAndDefaultsWithUsername:(NSString *) username
                                           password:(NSString *) password
                                  shouldUseKeyChain:(BOOL) shouldUseKeychain;
@end
