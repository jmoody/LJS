#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif


#import "LjsGoogleImportTest_Super.h"


@implementation LjsGoogleImportTest_Super
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
  [super setUpClass];
}

- (void) tearDownClass {
  // Run at end of all tests in the class
  [super tearDownClass];
}

- (void) setUp {
  [super setUp];
  GHAssertNotNil(self.resourceName, @"resource name cannot be nil");
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

- (void) tearDown {
  // Run after each test method
  self.jsonResource = nil;
  self.resourceName = nil;
  [super tearDown];
}  


@end
