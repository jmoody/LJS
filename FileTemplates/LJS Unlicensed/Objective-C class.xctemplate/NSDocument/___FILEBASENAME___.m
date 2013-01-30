#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "___FILEBASENAME___.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation ___FILEBASENAMEASIDENTIFIER___

- (id) init {
  //  [self doesNotRecognizeSelector:_cmd];
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  return self;
}

- (NSString *) windowNibName {
  // Implement this to return a nib to load OR implement -makeWindowControllers
  // to manually create your controllers.
  return @"___FILEBASENAMEASIDENTIFIER___";
}

- (NSData *) dataOfType:(NSString *) typeName error:(NSError **) outError {
  // Insert code here to write your document to data of the specified type. 
  // If the given outError != NULL, ensure that you set *outError when returning nil.
  
  // You can also choose to override -fileWrapperOfType:error:, 
  //                                 -writeToURL:ofType:error:, or 
  //                      -writeToURL:ofType:forSaveOperation:originalContentsURL:error: 
  // instead.
  
  // For applications targeted for Panther or earlier systems, you should use 
  // the deprecated API -dataRepresentationOfType:. In this case you can also 
  // choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
  
  return nil;
}

- (BOOL) readFromData:(NSData *) data ofType:(NSString *) typeName error:(NSError **) outError {
  // Insert code here to read your document from the given data of the specified type.  
  // If the given outError != NULL, ensure that you set *outError when returning NO.
  
  // You can also choose to override -readFromFileWrapper:ofType:error: or 
  // -readFromURL:ofType:error: instead. 
  
  // For applications targeted for Panther or earlier systems, you should use the 
  // deprecated API -loadDataRepresentation:ofType. In this case you can also choose
  // to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
  
  return YES;
}

@end
