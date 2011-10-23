
#import "DDFileLogger+CurrentFile.h"


@implementation DDFileLogger (DDFileLogger_CurrentFile)

- (NSString *) currentFilePath {
  return [currentLogFileInfo filePath];
}

@end
