// Copyright 2011 Little Joy Software. All rights reserved.
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

#if TARGET_OS_IPHONE
#import <GHUnitIOS/GHUnit.h>
#else
#import <GHUnit/GHUnit.h>
#endif

#import "LjsVariates.h"
#import "LjsValidator.h"
#import <objc/runtime.h>

#if TARGET_OS_IPHONE
#import "LjsTableViewOwnerProtocol.h"

@interface UIView (UIView_TESTING)

- (NSMutableDictionary *)fullDescription;

@end

#endif



@class LjsGestalt;

@interface LjsTestCase : GHTestCase 
#if TARGET_OS_IPHONE
<LjsTableViewOwnerProtocol>
#endif

@property (nonatomic, strong) LjsGestalt *gestalt;

@property (assign) Method findDocumentDirectoryPathOriginal;
@property (assign) Method findDocumentDirectoryPathMock;

@property (assign) Method findLibraryPreferencesPathOriginal;
@property (assign) Method findLibraryPreferencesPathMock;

- (NSString *) findDocumentDirectoryPathSwizzled;
- (void) swizzleFindDocumentDirectoryPath;
- (void) restoreFindDocumentDirectoryPath;

- (NSString *) findLibraryPreferencesPathSwizzled:(BOOL) ignorable;
- (void) swizzleFindLibraryPreferencesPath;
- (void) restoreFindLibraryPreferencesPath;

- (NSString *) emptyStringOrNil;
- (BOOL) flip;
- (void) dummyControlSelector:(id) sender;

- (NSDate *) dateForTimeOutWithSeconds:(NSTimeInterval) aSeconds;
- (NSDate *) dateForDefaultTimeOut;

@end
