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

#if !TARGET_OS_IPHONE
typedef enum {
  LjsGestaltMinor_v_10_0 = 0,
  LjsGestaltMinor_v_10_1,
  LjsGestaltMinor_v_10_2,
  LjsGestaltMinor_v_10_3,
  LjsGestaltMinor_v_10_4,
  LjsGestaltMinor_v_10_5,
  LjsGestaltMinor_v_10_6,
  LjsGestaltMinor_v_10_7
} LjsGestaltMinorVersion;


@interface LjsGestalt : NSObject 

@property (nonatomic, assign) NSUInteger majorVersion;
@property (nonatomic, assign) NSUInteger minorVersion;
@property (nonatomic, assign) NSUInteger bugVersion;


- (BOOL)getSystemVersionMajor:(unsigned *)major
                        minor:(unsigned *)minor
                       bugFix:(unsigned *)bugFix;

@end

#else
//#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_5_0
//#define kCFCoreFoundationVersionNumber_iPhoneOS_5_0 675.000000
//#endif
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
//#define IF_IOS5_OR_GREATER(...) \
//if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_5_0) \
//{ \
//__VA_ARGS__ \
//}
//#else
//#define IF_IOS5_OR_GREATER(...)
//#endif
//
//
//#define IF_PRE_IOS5(...) \
//if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iPhoneOS_5_0) \
//{ \
//  __VA_ARGS__ \
//}

#endif



