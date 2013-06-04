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
#import <Foundation/Foundation.h>

/**
 LjsValidator provides class methods for validating all sorts of things.  The 
 methods here may appear trivial and redundant - why go through the effort of
 wrapping well-known and well-used operations?  Validation is repeatative
 and tedious work and it helps me to have a consistent interface.
 */
@interface LjsValidator : NSObject 


/**
 @returns true iff aString contains only characters from aCharacterSet
 @param aString the reference string
 @param aCharacterSet the set of characters to test against
 */
+ (BOOL) string:(NSString *) aString containsOnlyMembersOfCharacterSet:(NSCharacterSet *) aCharacterSet;

/**
 @returns true iff aString contains only alpha-numeric characters
 @param aString the reference string
 */
+ (BOOL) stringContainsOnlyAlphaNumeric:(NSString *) aString;

/**
 Method for checking if a string contains only numbers.  Does not check to see
 if the number is a valid deciment - e.g. 0454.  Will return false if there are
 commas or decimal places.
 @param aString the string to test
 @return true iff string contains only numeric characters
 */
+ (BOOL) stringContainsOnlyNumbers:(NSString *) aString;

/**
 Method for checking if a value is an NSDictionary
 @param value some value
 @return true iff value is an NSDictionary
 */
+ (BOOL) isDictionary:(id) value;

/**
 Method for checking if a value is an NSArray.
 @param value some value
 @return true iff value is an NSArray
 */
+ (BOOL) isArray:(id) value;

/**
 Method for checking if a value is an NSString
 @param value some value
 @return true iff value is an NSString
 */
+ (BOOL) isString:(id) value;

/**
 Method for checking the number of elements in an array.
 @param aArray the array to test
 @param aCount the target number of elements
 @return true iff array contains `count` number of elements
 */
+ (BOOL) array:(NSArray *) aArray hasCount:(NSUInteger) aCount;

/**
 Method for checking if an array contains a string
 @param aArray the array to test
 @param aString the string to search for
 @return true iff array contains the string
 */
+ (BOOL) array:(NSArray *) aArray containsString:(NSString *) aString;

/**
 Method for checking if an array contains a list of strings
 @param aArray the array to test
 @param aSetOfStrings a set of strings to test
 @return true iff array contains every member in set of strings
 */
+ (BOOL) array:(NSArray *) aArray containsStrings:(NSSet *) aSetOfStrings;


/**
 Method for checking if an array contains a list of strings and no others
 @param aArray the array to test
 @param aSetOfStrings a set of strings to test
 @param aAllowsOthers if true, aArray must only contain those strings found in
 aSetOfStrings
 @return true iff array contains every member in set of strings
 */
+ (BOOL) array:(NSArray *) aArray containsStrings:(NSSet *) aSetOfStrings
  allowsOthers:(BOOL) aAllowsOthers;


/**
 Method for checking if a dictionary contains a key.
 @param dictionary a dictionary
 @param key the key to search for
 @return true iff the dictionary contains the key
 */
+ (BOOL) dictionary:(NSDictionary *) dictionary containsKey:(NSString *) key;

/**
 Method for checking if a dictionary contains a list of keys - other keys are
 allowed.
 @param dictionary the reference dictionary
 @param keys the list of keys to find
 @return true iff the dictionary contains every key from keys
 */
+ (BOOL) dictionary:(NSDictionary *) dictionary containsKeys:(NSArray *)keys;

/**
 Method for checking if a dictionary contains a list of keys.  If allowsOthers is
 YES then other keys are allowed, otherwise other keys are not allowed.
 @param dictionary the reference dictionary
 @param keys the list of keys to find
 @param allowsOthers if YES, other keys are allowed, otherwise they are not
 @return true iff the dictionary contains every key from keys - if allowOthers is
 YES then other keys are allowed, otherwise other keys are not allowed.
 */
+ (BOOL) dictionary:(NSDictionary *)dictionary 
       containsKeys:(NSArray *) keys
       allowsOthers:(BOOL) allowsOthers;

/**
 @return true iff checkString is valid email address
 Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
 @param checkString the string to check
 */
+ (BOOL) isValidEmail:(NSString *)checkString;

+ (BOOL) isFloat:(CGFloat) aFloat
   onIntervalMin:(CGFloat) aMin
             max:(CGFloat) aMax;

#if TARGET_OS_IPHONE
+ (BOOL) isZeroRect:(CGRect) aRect;
#endif

@end

@interface LjsReasons : NSObject

- (BOOL) hasReasons;
- (void) addReason:(NSString *) aReason;
- (void) addReasonWithVarName:(NSString *)aVarName ifNil:(id) aObject;
- (void) ifNil:(id) aObject addReasonWithVarName:(NSString *) aVarName;

- (void) addReasonWithVarName:(NSString *)aVarName ifEmptyString:(NSString *) aString;
- (void) ifEmptyString:(NSString *) aString addReasonWithVarName:(NSString *) aVarName;

- (void) addReasonWithVarName:(NSString *)aVarName ifNilOrEmptyString:(NSString *) aString;
- (void) ifNilOrEmptyString:(NSString *) aString addReasonWithVarName:(NSString *) aVarName;

- (void) ifEmptyArray:(NSArray *) aArray addReasonWithVarName:(NSString *) aVarName;

- (void) addReasonWithVarName:(NSString *)aVarName ifElement:(id) aObject notInList:(id) aFirst, ...NS_REQUIRES_NIL_TERMINATION;
- (void) addReasonWithVarName:(NSString *)aVarName ifElement:(id) aObject notInArray:(NSArray *) aArray;
- (void) addReasonWithVarName:(NSString *)aVarName ifElement:(id)aObject inList:(id) aFirst, ...NS_REQUIRES_NIL_TERMINATION;
- (void) addReasonWithVarName:(NSString *)aVarName ifElement:(id) aObject inArray:(NSArray *) aArray;
- (void) addReasonWithVarName:(NSString *)aVarName ifNilSelector:(SEL) aSel;
- (void) addReasonWithVarName:(NSString *)aVarName
                    ifInteger:(NSInteger) aValue
              isNotOnInterval:(NSRange) aRange;
- (void) addReasonWithVarName:(NSString *)aVarName
                    ifInteger:(NSInteger) aValue
              isNotOnInterval:(NSRange) aRange
                    orEqualTo:(NSInteger) aOutOfRangeValue;


- (NSString *) explanation:(NSString *) aExplanation;
- (NSString *) explanation:(NSString *) aExplanation
           consequence:(NSString *) aConsequence;

@end
