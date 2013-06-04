// Copyright 2012 Little Joy Software. All rights reserved.
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

/**
 Documentation
 */
@protocol LjsBackingStore <NSObject>

/** @name Required Methods */
@required

- (void) removeKeys:(NSArray *) keys;

- (NSString *) stringForKey:(NSString *) aKey 
               defaultValue:(NSString *) aDefault 
             storeIfMissing:(BOOL) aPersistMissing;

- (NSNumber *) numberForKey:(NSString *) aKey 
               defaultValue:(NSNumber *) aDefault
             storeIfMissing:(BOOL) aPersistMissing;

- (BOOL) boolForKey:(NSString *) aKey 
       defaultValue:(BOOL) aDefault
     storeIfMissing:(BOOL) aPersistMissing;

- (NSDate *) dateForKey:(NSString *) aKey
           defaultValue:(NSDate *) aDefault
         storeIfMissing:(BOOL) aPersistMissing;

- (NSData *) dataForKey:(NSString *) aKey
           defaultValue:(NSData *) aDefault
         storeIfMissing:(BOOL) aPersistMissing;

- (NSArray *) arrayForKey:(NSString *) aKey
             defaultValue:(NSArray *) aDefault
           storeIfMissing:(BOOL) aPersistMissing;

- (NSDictionary *) dictionaryForKey:(NSString *) aKey
                  defaultValue:(NSDictionary *) aDefault
                storeIfMissing:(BOOL) aPersistMissing;

- (id) valueForDictionaryNamed:(NSString *) aDictName
                  withValueKey:(NSString *) aValueKey
                  defaultValue:(id) aDefaultValue
                storeIfMissing:(BOOL) aPersistMissing;

- (BOOL) updateValueInDictionaryNamed:(NSString *) aDictName
                         withValueKey:(NSString *) aValueKey
                                value:(id) aValue;



/** @name Optional Methods */

@optional


- (NSArray *) allKeys;
- (BOOL) storeObject:(id) object forKey:(NSString *) aKey;
- (BOOL) storeBool:(BOOL) aBool forKey:(NSString *) aKey;
- (BOOL) removeObjectForKey:(NSString *) aKey;
- (NSString *) filepath;


@end
