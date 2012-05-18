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

#import "LjsTestCase.h"
#import "Lumberjack.h"
#import "LjsFileUtilities.h"
#import "LjsGestalt.h"



#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#if TARGET_OS_IPHONE
@implementation UIView (UIView_TESTING)

- (NSMutableDictionary *)fullDescription {
  NSDictionary *frame =
  [NSDictionary dictionaryWithObjectsAndKeys:
   [NSNumber numberWithFloat:self.frame.origin.x], @"x",
   [NSNumber numberWithFloat:self.frame.origin.y], @"y",
   [NSNumber numberWithFloat:self.frame.size.width], @"width",
   [NSNumber numberWithFloat:self.frame.size.height], @"height",
   nil];
  NSMutableDictionary *description =
  [NSMutableDictionary dictionaryWithObjectsAndKeys:
   [NSNumber numberWithInteger:(NSInteger)self], @"address",
   NSStringFromClass([self class]), @"className",
   frame, @"frame",
   [NSNumber numberWithInteger:[self tag]], @"tag",
   [self valueForKeyPath:@"subviews.fullDescription"], @"subviews",
   nil];
  
  if ([self respondsToSelector:@selector(text)])
  {
    [description
     setValue:[self performSelector:@selector(text)]
     forKey:@"text"];
  }
  if ([self respondsToSelector:@selector(title)])
  {
    [description
     setValue:[self performSelector:@selector(title)]
     forKey:@"title"];
  }
  if ([self respondsToSelector:@selector(currentTitle)])
  {
    [description
     setValue:[self performSelector:@selector(currentTitle)]
     forKey:@"currentTitle"];
  }
  
  return description;
}

@end
#endif


@implementation LjsTestCase

@synthesize gestalt;
@synthesize findDocumentDirectoryPathMock, findDocumentDirectoryPathOriginal;
@synthesize findLibraryPreferencesPathMock, findLibraryPreferencesPathOriginal;


- (id) init {
  self = [super init];
  if (self) {
    
    self.gestalt = [[LjsGestalt alloc] init];
    
    self.findDocumentDirectoryPathOriginal = 
    class_getClassMethod([LjsFileUtilities class],
                         @selector(findDocumentDirectoryPath));
    self.findDocumentDirectoryPathMock = 
    class_getInstanceMethod([self class],
                            @selector(findDocumentDirectoryPathSwizzled));
    
    self.findLibraryPreferencesPathOriginal =
    class_getClassMethod([LjsFileUtilities class], 
                         @selector(findLibraryPreferencesPath:));
    self.findLibraryPreferencesPathMock =
    class_getInstanceMethod([LjsFileUtilities class], 
                            @selector(findLibraryPreferencesPathSwizzled));
  }
  return self;
}


- (void) setUpClass {
  // Run at start of all tests in the class
  [super setUpClass];
  if (getenv("GHUNIT_CLI")) {
    [self swizzleFindDocumentDirectoryPath];
    [self swizzleFindLibraryPreferencesPath];
  }
}

- (void) tearDownClass {
  // Run at end of all tests in the class  
  if (getenv("GHUNIT_CLI")) {
    [self restoreFindDocumentDirectoryPath];
    [self restoreFindLibraryPreferencesPath];
  }
  [super tearDownClass];
}



- (NSString *) emptyStringOrNil {
  NSString *result = nil;
  if ([LjsVariates flip]) {
    result = @"";
  }
  return result;
}

- (BOOL) flip {
  return [LjsVariates flip];
}

// must swizzle for command line builds because Application does not exist
// on the CLI so document path is /dev/null/Documents
- (NSString *) findDocumentDirectoryPathSwizzled {
  NSString *path = @"./build/sandbox/Documents";
  NSError *error = nil;
  BOOL success = [LjsFileUtilities ensureDirectory:path error:&error];
  if (success == NO) {
    GHTestLog(@"could not create directory at path: %@\n%@ : %@",
              [error localizedDescription], error);
    abort();
  }
  return path;
}

- (void) swizzleFindDocumentDirectoryPath {
  method_exchangeImplementations(self.findDocumentDirectoryPathOriginal,
                                 self.findDocumentDirectoryPathMock);
}

- (void) restoreFindDocumentDirectoryPath {
  method_exchangeImplementations(self.findDocumentDirectoryPathMock,
                                 self.findDocumentDirectoryPathOriginal);

}

- (NSString *) findLibraryPreferencesPathSwizzled:(BOOL) ignorable {
  NSString *path = @"./build/sandbox/Library/Preferences";
  NSError *error = nil;
  BOOL success = [LjsFileUtilities ensureDirectory:path error:&error];
  if (success == NO) {
    GHTestLog(@"could not create directory at path: %@\n%@ : %@",
              [error localizedDescription], error);
    abort();
  }
  return path;
}

- (void) swizzleFindLibraryPreferencesPath {
  method_exchangeImplementations(self.findLibraryPreferencesPathOriginal,
                                 self.findLibraryPreferencesPathMock);
}

- (void) restoreFindLibraryPreferencesPath {
  method_exchangeImplementations(self.findLibraryPreferencesPathMock, 
                                 self.findLibraryPreferencesPathOriginal);
}


- (void) dummyControlSelector:(id) sender {
  return;
}


- (NSDate *) dateForTimeOutWithSeconds:(NSTimeInterval) aSeconds {
  return [[NSDate date] dateByAddingTimeInterval:aSeconds];
}

- (NSDate *) dateForDefaultTimeOut {
  return [self dateForTimeOutWithSeconds:1.5];
}

#pragma mark LJS Table View Owner Protocol

#if TARGET_OS_IPHONE
- (void) scrollTableViewToIndexPath:(NSIndexPath *) aIndexPath
                   atScrollPosition:(UITableViewScrollPosition) aPostion {
  return;
}

- (void) reloadTableView {
  return;
}

- (UITableViewCell *) cellForIndexPath:(NSIndexPath *) aIndexPath {
  return nil;
}

- (UITableViewCell *) cellForSelectedRow {
  return nil;
}

- (NSIndexPath *) indexPathForSelectedRow {
  return nil;
}

- (void) deselectSelectedRow:(BOOL) animated {
  return;
}

- (void) selectCellAtIndexPath:(NSIndexPath *) aIndexPath 
                      animated:(BOOL) animated 
                scrollPosition:(UITableViewScrollPosition) scrollPosition {
  return;
}

- (NSArray *) visibleCells {
  return nil;
}
#endif


@end
