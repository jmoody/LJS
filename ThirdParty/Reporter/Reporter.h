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

/**
 Thanks to Tomas Znamenacek for his work on this.

 See http://www.google.com/search?q=should+method+set+nserror for a discussion.
 
 This is an error contruction tool for methods that pass errors back
 to callers.  This class protects you from users passing NULL (instead of nil).
 
 Simply create a reporter for a domain and error and then create an error to
 pass back to the caller.
 
     Reporter *reporter = [Reporter reporterWithDomain:@"some domain" error:someError];
     *someError = [reporter errorWithCode:-1 description:@"bad things happened];
 
 Joshua Moody added the documentation.
 */
@interface Reporter : NSObject {
  NSString *domain;
}

/** @name Creating and Initializing a Reporter*/

/**
 Initializes a new reporter with an error domain and an error
 @param errDomain the error domain
 @param error the error to populate
 @return an initialized reporter
 */
- (id) initWithDomain: (NSString *) errDomain error: (NSError **) error;

/**
 Initializes a new reporter with an error domain and an error
 
 Notes: Joshua Moody changed this method name to be in line with Objective-C
 naming conventions
 @param errDomain the error domain
 @param error the error to populate
 @return an autoreleased initialized reporter
 */
+ (id) reporterWithDomain: (NSString *) errDomain error: (NSError **) error;

/** @name Creating Errors */

/**
 A error with code and the error domain that was set in the init method
 @param code the error code
 @return an autoreleased error with code and the error domain that was set in 
 the init method
 */
- (NSError *) errorWithCode: (NSInteger) code;
 
/**
 A error with code and description and the error domain that was set in the 
 init method
 @param code the error code
 @param msg a description of the error
 @return an autoreleased error with code, description and error domain that was
 set in the init method
 */
- (NSError *) errorWithCode: (NSInteger) code description: (NSString* ) msg;

@end
