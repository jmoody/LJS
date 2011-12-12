#import "DDFileLogger+CurrentFile.h"

/**
 A Category on DDFileLogger - because it is hard to dig the current
 file path out of the DDFileLogger.
 */
@implementation DDFileLogger (DDFileLogger_CurrentFile)

/**
 @return the current file path of the receiver using the current log file info
 filePath method
 */
- (NSString *) currentFilePath {
  return [currentLogFileInfo filePath];
}

@end
