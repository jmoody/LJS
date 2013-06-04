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
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsIdGenerator.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


@implementation LjsIdGenerator


+ (NSString *) generateUUID {
  CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
  NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
  CFRelease(newUniqueId);
  return uuidString;
}


+ (NSString *) generateCouchDbCompatibleUUID {
  NSString *uuid = [LjsIdGenerator generateUUID];
  uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
  return [uuid lowercaseString];
}

+ (NSString *) uuidWithCouchDBUuid:(NSString *)couchdbUuid {
  NSString *result = [couchdbUuid uppercaseString];
  NSString *firstPart = [result substringToIndex:8];
  NSRange range = NSMakeRange (8, 4);
  NSString *secondPart = [result substringWithRange:range];
  range = NSMakeRange(12, 4);
  NSString *thirdPart = [result substringWithRange:range];
  range = NSMakeRange(16, 4);
  NSString *fourthPart = [result substringWithRange:range];
  NSString *fifthPart = [result substringFromIndex:20];
  return [NSString stringWithFormat:@"%@-%@-%@-%@-%@",
          firstPart, secondPart, thirdPart, fourthPart, fifthPart];
}

+ (NSString *) couchDbUuidWithUuid:(NSString *) uuid {
  NSString *result = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
  return [result lowercaseString];
}

@end
