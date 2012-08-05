// Copyright (c) 2010, Little Joy Software
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

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsLogFileManager.h"
#import "Lumberjack.h"
#import "LjsFileUtilities.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface DDLogFileManagerDefault (Ljs_Additions)

- (NSString *) defaultLogsDirectory;

@end

/**
 This class overrides one method fromt the superclass DDLogFileManagerDefault:
 `createNewLogFile` and limits the number of log files to one (1).  
 
 This is desirable to do in cases where you want to generate one log file per
 application run and with a more meaningful name than the one that 
 CocoaLumberjackLogging provides.
 */
@implementation LjsLogFileManager

/** @name Initialization */
/**
 @return an initialized receiver with maximumNumberOfLogFiles = 1
 */
- (id) init {
	self = [super init];
	if (self != nil) {
		self.maximumNumberOfLogFiles = 1;
	}
	return self;
}

/** @name Creating a New Log File */

/**
 * Returns the path to the default logs directory.
 * If the logs directory doesn't exist, this method automatically creates it.
 **/
- (NSString *) defaultLogsDirectory
{
#if TARGET_OS_IPHONE

//  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//	NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//	NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"Logs"];
  NSString *docPath = [LjsFileUtilities findDocumentDirectory];
  NSString *logsDirectory = [docPath stringByAppendingPathComponent:@"Logs"];
  
#else
  NSString *logsDirectory = [super  defaultLogsDirectory];
#endif
  
	return logsDirectory;
}



/**
 * Generates a new unique log file path, and creates the corresponding log file.
 */
- (NSString *)createNewLogFile {
	NSString *logsDirectory = [self logsDirectory];
	do {
    
    NSString *OrderedDateFormatWithMillis = @"yyyy_MM_dd_HH_mm_SSS";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:OrderedDateFormatWithMillis];
    NSString *datestring = [formatter stringFromDate:[NSDate date]];
    
    NSString *fileName = [NSString stringWithFormat:@"log-%@.txt", datestring];
		NSString *filePath = [logsDirectory stringByAppendingPathComponent:fileName];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
			NSLog(@"DDLogFileManagerDefault: Creating new log file: %@", fileName);
			
			[[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
			
      return filePath;
		}
		
	} while(YES);
}


@end
