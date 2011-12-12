
#import <Foundation/Foundation.h>

/**
 LjsValidator provides class methods for validating all sorts of things.
 */
@interface LjsValidator : NSObject {
    
}


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

@end
