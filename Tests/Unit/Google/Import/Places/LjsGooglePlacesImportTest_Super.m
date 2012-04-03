#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif


#import "LjsGooglePlacesImportTest_Super.h"


@implementation LjsGooglePlacesImportTest_Super
@synthesize jsonResource;
@synthesize resourceName;

- (id) init {
  self = [super init];
  if (self) {
    // Initialization code here.
    self.resourceName = nil;
    self.jsonResource = nil;
  }
  return self;
}


- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  if (self.resourceName != nil) {
    NSBundle *main = [NSBundle mainBundle];
    NSString *path = [main pathForResource:self.resourceName
                                    ofType:@"json"];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSData *data = [fm contentsAtPath:path];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.jsonResource = str;
  } 
}

- (void) tearDownClass {
  // Run at end of all tests in the class
}

- (void) setUp {
  // Run before each test method
}

- (void) tearDown {
  // Run after each test method
}  

//- (void)testGHLog {
//  GHTestLog(@"GH test logging is working");
//}

@end
