// Copyright 2011 The Little Joy Software Company. All rights reserved.
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


#import <Foundation/Foundation.h>

@interface LjsIdGenerator : NSObject {
}


/**
 Cribbed from here:
 http://vgable.com/blog/2008/02/24/creating-a-uuid-guid-in-cocoa/
 @return a valid UUID
 */
+ (NSString *) generateUUID;

/**
 generates a couchdb compatible uuid which is simply a uuid stripped of its
 hypens and downcased which makes the string 32 vs 36 characters
 @return a 32 character uuid
 */
+ (NSString *) generateCouchDbCompatibleUUID;

/**
 Converts a couchdb 32 character uuid to a cocoa 36 character uuid
 by adding the approriate hypens and up-casing the letters
 @param couchdbUuid the uuid to convert
 @return a 36 character uuid
 */
+ (NSString *) uuidWithCouchDBUuid:(NSString *) couchdbUuid;

/**
 Converts a 36 character cocoa uuid to a couchdb 32 character uuid by removing
 the hypens and downcasing the letters
 @param uuid the uuid to convert
 @return a 32 character uuid
 */
+ (NSString *) couchDbUuidWithUuid:(NSString *) uuid;


@end
