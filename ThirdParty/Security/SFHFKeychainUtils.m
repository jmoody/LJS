//
//  SFHFKeychainUtils.m
//
//  Created by Buzz Andersen on 10/20/08.
//  Based partly on code by Jonathan Wight, Jon Crosby, and Mike Malone.
//  Copyright 2008 Sci-Fi Hi-Fi. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "SFHFKeychainUtils.h"
#import <Security/Security.h>
#import "Lumberjack.h"
#import "LjsGestalt.h"

//#ifdef LOG_CONFIGURATION_DEBUG
//static const int ddLogLevel = LOG_LEVEL_DEBUG;
//#else
//static const int ddLogLevel = LOG_LEVEL_WARN;
//#endif
static const int ddLogLevel = LOG_LEVEL_WARN;

static NSString *SFHFKeychainUtilsErrorDomain = @"SFHFKeychainUtilsErrorDomain";

@interface SFHFKeychainUtils (PrivateMethods)
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000 && TARGET_IPHONE_SIMULATOR
+ (SecKeychainItemRef) getKeychainItemReferenceForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;
#else

+ (NSString *) passwordRef;

#endif


@end


@implementation SFHFKeychainUtils

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000 && TARGET_IPHONE_SIMULATOR


+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
	if (!username || !serviceName) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		return nil;
	}
  
	SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];
  
	if (*error || !item) {
		return nil;
	}
  
	// from Advanced Mac OS X Programming, ch. 16
  UInt32 length;
  char *password;
  SecKeychainAttribute attributes[8];
  SecKeychainAttributeList list;
  
  attributes[0].tag = kSecAccountItemAttr;
  attributes[1].tag = kSecDescriptionItemAttr;
  attributes[2].tag = kSecLabelItemAttr;
  attributes[3].tag = kSecModDateItemAttr;
  
  list.count = 4;
  list.attr = attributes;
  
  OSStatus status = SecKeychainItemCopyContent(item, NULL, &list, &length, (void **)&password);
  
	if (status != noErr) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
		return nil;
  }
  
	NSString *passwordString = nil;
  
	if (password != NULL) {
		char passwordBuffer[1024];
    
		if (length > 1023) {
			length = 1023;
		}
		strncpy(passwordBuffer, password, length);
    
		passwordBuffer[length] = '\0';
		passwordString = [NSString stringWithCString:passwordBuffer];
	}
  
	SecKeychainItemFreeContent(&list, password);
  
  CFRelease(item);
  
  return passwordString;
}

+ (void) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error {	
	if (!username || !password || !serviceName) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		return;
	}
  
	OSStatus status = noErr;
  
	SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];
  
	if (*error && [*error code] != noErr) {
		return;
	}
  
	*error = nil;
  
	if (item) {
		status = SecKeychainItemModifyAttributesAndData(item,
                                                    NULL,
                                                    strlen([password UTF8String]),
                                                    [password UTF8String]);
    
		CFRelease(item);
	}
	else {
		status = SecKeychainAddGenericPassword(NULL,                                     
                                           strlen([serviceName UTF8String]), 
                                           [serviceName UTF8String],
                                           strlen([username UTF8String]),                        
                                           [username UTF8String],
                                           strlen([password UTF8String]),
                                           [password UTF8String],
                                           NULL);
	}
  
	if (status != noErr) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
	}
}

+ (void) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
	if (!username || !serviceName) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: 2000 userInfo: nil];
		return;
	}
  
	*error = nil;
  
	SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];
  
	if (*error && [*error code] != noErr) {
		return;
	}
  
	OSStatus status;
  
	if (item) {
		status = SecKeychainItemDelete(item);
    
		CFRelease(item);
	}
  
	if (status != noErr) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
	}
}

+ (SecKeychainItemRef) getKeychainItemReferenceForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
	if (!username || !serviceName) {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		return nil;
	}
  
	*error = nil;
  
	SecKeychainItemRef item;
  
	OSStatus status = SecKeychainFindGenericPassword(NULL,
                                                   strlen([serviceName UTF8String]),
                                                   [serviceName UTF8String],
                                                   strlen([username UTF8String]),
                                                   [username UTF8String],
                                                   NULL,
                                                   NULL,
                                                   &item);
  
	if (status != noErr) {
		if (status != errSecItemNotFound) {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
		}
    
		return nil;		
	}
  
	return item;
}

#else


+ (NSString *) passwordRef {
  #if !TARGET_OS_IPHONE
  LjsGestalt *gestalt = [LjsGestalt new];
  if (gestalt.minorVersion == LjsGestaltMinor_v_10_6) {
    return (__bridge_transfer NSString *) kSecClassInternetPassword;
  } else {
    return (__bridge_transfer NSString *) kSecClassGenericPassword;
  }
#else
  return (__bridge_transfer NSString *) kSecClassGenericPassword;
#endif
}

+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
	if (!username || !serviceName) {
		if (error != nil) {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return nil;
	}
  
	if (error != nil) {
		*error = nil;
	}
  
	// Set up a query dictionary with the base query attributes: item type (generic), username, and service
  
	NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil];
  //NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword, username, serviceName, nil];
  NSArray *objects = [[NSArray alloc] initWithObjects: [SFHFKeychainUtils passwordRef], username, serviceName, nil];
  
	NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
  
	// First do a query for attributes, in case we already have a Keychain item with no password data set.
	// One likely way such an incorrect item could have come about is due to the previous (incorrect)
	// version of this code (which set the password as a generic attribute instead of password data).
  

	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject: (id) kCFBooleanTrue forKey:(__bridge_transfer id) kSecReturnAttributes];

  CFDictionaryRef cfAttributeQuery = (__bridge_retained CFDictionaryRef) attributeQuery;  
  CFTypeRef cfAttrResult = NULL;
  
  DDLogDebug(@"attr query = %@", attributeQuery);
	OSStatus status = SecItemCopyMatching(cfAttributeQuery, &cfAttrResult);
  CFRelease(cfAttributeQuery);
  
  // ugh - faking out ARC
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
  NSData *attrData __attribute ((unused)) = (__bridge_transfer NSData *)cfAttrResult;
#pragma clang diagnostic pop

	if (status != noErr) {
    // No existing item found--simply return nil for the password
		DDLogDebug(@"did not find an existing username - will return nil");
    if (error != nil && status != errSecItemNotFound) {
      DDLogDebug(@"there was a problem quering for username in SecItemCopyMatching - %d", (int)status);
			//Only return an error if a real exception happened--not simply for "not found."
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
		}
		return nil;
	}
  
	// We have an existing item, now query for the password data associated with it.
  DDLogDebug(@"found a username - looking for password");
	NSMutableDictionary *passwordQuery = [query mutableCopy];
	[passwordQuery setObject: (id) kCFBooleanTrue forKey: (__bridge_transfer  id) kSecReturnData];
  CFDictionaryRef cfPasswordQuery = (__bridge_retained CFDictionaryRef) passwordQuery;
  CFTypeRef cfResData = NULL;
	status = SecItemCopyMatching(cfPasswordQuery, &cfResData);
	NSData *resultData = (__bridge_transfer NSData *)cfResData;
  CFRelease(cfPasswordQuery);

	if (status != noErr) {

		if (status == errSecItemNotFound) {
      DDLogDebug(@"executing the password query resulted in an error - TRY PROMPTING AGAIN");
			// We found attributes for the item previously, but no password now, so return a special error.
			// Users of this API will probably want to detect this error and prompt the user to
			// re-enter their credentials.  When you attempt to store the re-entered credentials
			// using storeUsername:andPassword:forServiceName:updateExisting:error
			// the old, incorrect entry will be deleted and a new one with a properly encrypted
			// password will be added.
			if (error != nil) {
				*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -1999 userInfo: nil];
			}
		}	else {
      DDLogDebug(@"executing the password query resulted in an error: %d", (int)status);
      // Something else went wrong. Simply return the normal Keychain API error code.
			if (error != nil) {
				*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
			}
		}
    
		return nil;
	}
  
	NSString *password = nil;	
  
	if (resultData) {
		password = [[NSString alloc] initWithData: resultData encoding: NSUTF8StringEncoding];
	}	else {
		// There is an existing item, but we weren't able to get password data for it for some reason,
		// Possibly as a result of an item being incorrectly entered by the previous code.
		// Set the -1999 error so the code above us can prompt the user again.
    DDLogDebug(@"sec item exists for username/password but no data was found - TRY PROMPTING AGAIN");
		if (error != nil) {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -1999 userInfo: nil];
		}
	}
	return password;
}

+ (BOOL) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error 
{		
	if (!username || !password || !serviceName) 
  {
		if (error != nil) 
    {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return NO;
	}
  
  DDLogDebug(@"username, password, and service name OK");
	// See if we already have a password entered for these credentials.
	NSError *getError = nil;
	NSString *existingPassword = [SFHFKeychainUtils getPasswordForUsername: username andServiceName: serviceName error:&getError];
    
	if ([getError code] == -1999) {
    DDLogDebug(@"there was an existing entry without a properly installed password - attempting to delete");
    // There is an existing entry without a password properly stored (possibly as a result of the previous incorrect version of this code.
		// Delete the existing item before moving on entering a correct one.
    
		getError = nil;
    [self deleteItemForUsername: username andServiceName: serviceName error: &getError];
    
		if ([getError code] != noErr) {
      DDLogDebug(@"there was a problem deleting existing password - returning NO");
			if (error != nil) {
				*error = getError;
			}
			return NO;
		}
	}	else if ([getError code] != noErr)  {
    DDLogDebug(@"there was a problem looking up existing password: %d - return NO", (int)[getError code]);
		if (error != nil) {
			*error = getError;
		}
		return NO;
	}
  
	if (error != nil) {
		*error = nil;
	}
  
	OSStatus status = noErr;
  
	if (existingPassword) {
    DDLogDebug(@"there is an existing password that was properly stored");
		// We have an existing, properly entered item with a password.
		// Update the existing item.

		if (![existingPassword isEqualToString:password] && updateExisting) {
      DDLogDebug(@"the existing password is different from the new password and we have been asked to update");
			//Only update if we're allowed to update existing.  If not, simply do nothing.
      
			NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass, 
                       kSecAttrService, 
                       kSecAttrLabel, 
                       kSecAttrAccount, 
                       nil];
     
      /*
			NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword, 
                          serviceName,
                          serviceName,
                          username,
                          nil];
       */
      
      NSArray *objects = [[NSArray alloc] initWithObjects: [SFHFKeychainUtils passwordRef],
                          serviceName,
                          serviceName,
                          username,
                          nil];

			NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
      
			status = SecItemUpdate((__bridge_retained CFDictionaryRef) query, (__bridge_retained CFDictionaryRef) [NSDictionary dictionaryWithObject: [password dataUsingEncoding: NSUTF8StringEncoding] forKey: (__bridge_transfer NSString *) kSecValueData]);
		}
	} else {
    DDLogDebug(@"there is not an existing password - adding new new sec item");
    
		// No existing entry (or an existing, improperly entered, and therefore now
		// deleted, entry).  Create a new entry.
    
		NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass, 
                     kSecAttrService, 
                     kSecAttrLabel, 
                     kSecAttrAccount, 
                     kSecValueData, 
                     nil];
    
    /*
		NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword, 
                        serviceName,
                        serviceName,
                        username,
                        [password dataUsingEncoding: NSUTF8StringEncoding],
                        nil];
     */
    NSArray *objects = [[NSArray alloc] initWithObjects: [SFHFKeychainUtils passwordRef],
                        serviceName,
                        serviceName,
                        username,
                        [password dataUsingEncoding: NSUTF8StringEncoding],
                        nil];

    
		NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];			
    CFDictionaryRef cfQuery = (__bridge_retained CFDictionaryRef)query;
    
		status = SecItemAdd(cfQuery, NULL);
    CFRelease(cfQuery);
	}
  
	if (error != nil && status != noErr) {
    DDLogDebug(@"there was a problem adding or updating sec item: %d => %@", (int)status, (error == nil) ? nil : *error);
		// Something went wrong with adding the new item. Return the Keychain error code.
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
    
    return NO;
	}
  
  return YES;
}

+ (BOOL) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error 
{
	if (!username || !serviceName) 
  {
		if (error != nil) 
    {
			*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return NO;
	}
  
	if (error != nil) 
  {
		*error = nil;
	}
  
	NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
	
  //NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword, username, serviceName, kCFBooleanTrue, nil];
  
	NSArray *objects = [[NSArray alloc] initWithObjects:[SFHFKeychainUtils passwordRef], username, serviceName, kCFBooleanTrue, nil];
  

  NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
  CFDictionaryRef cfQuery = (__bridge_retained CFDictionaryRef)query;
	OSStatus status = SecItemDelete(cfQuery);
  CFRelease(cfQuery);
  
	if (error != nil && status != noErr) 
  {
		*error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];		
    
    return NO;
	}
  
  return YES;
}

#endif

@end
