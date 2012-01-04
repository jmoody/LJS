//Copyright (c) 2009, 2010 Tomáš Znamenáček
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the ‚ÄúSoftware‚Äù), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "TZReporter.h"

/**
  The dummyError trick is here to safely initialize
  the NSError** output variable passed to various methods
  that use the Reporter class. Discussion here:
  http://google.com/search?q=should+method+set+nserror
*/
static NSError *dummyError = nil;

@implementation TZReporter

@synthesize domain;

#pragma mark Initialization

- (id) initWithDomain: (NSString*) errDomain error: (NSError**) error {
  self = [super init];
  if (self != nil) {
    self.domain = errDomain;
    if (error == NULL) {
      *error = dummyError;
    }
  }
  return self;
}

+ (id) reporterWithDomain: (NSString*) errDomain error: (NSError**) error
{
    return [[self alloc] initWithDomain:errDomain error:error];
}


#pragma mark Error Reporting

- (NSError*) errorWithCode: (NSInteger) code
{
    return [NSError errorWithDomain:domain code:code userInfo:nil];
}

- (NSError*) errorWithCode: (NSInteger) code description: (NSString*) msg
{
  
  NSDictionary *userInfo = 
  [NSDictionary dictionaryWithObjectsAndKeys:
   msg, NSLocalizedDescriptionKey,
   [NSNumber numberWithInteger:NSUTF8StringEncoding], NSStringEncodingErrorKey,
   nil];
 
  
  return [NSError errorWithDomain:domain 
                             code:code
                         userInfo:userInfo];
}

@end
