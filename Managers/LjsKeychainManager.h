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
#import <Foundation/Foundation.h>
#import "NSError+LjsAdditions.h"

extern NSString *LjsKeychainManagerErrorDomain;

typedef enum {
  LjsKeychainManagerBadKeyError = 4390116,
  LjsKeychainManagerBadUsernameError,
  LjsKeychainManagerBadPasswordError,
  LjsKeychainManagerBadServiceNameError
} LjsKeychainManagerErrorCodes;


@interface LjsKeychainManager : NSObject 

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

- (NSString *) keychainPasswordForUsernameInDefaultsWithKey:(NSString *) key
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






@end
