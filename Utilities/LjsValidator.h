
#import <Foundation/Foundation.h>

/**
 LjsValidator provides class methods for validating all sorts of things.
 */
@interface LjsValidator : NSObject {
    
}

+ (BOOL) string:(NSString *) aString containsOnlyMembersOfCharacterSet:(NSCharacterSet *) aCharacterSet;


+ (BOOL) stringContainsOnlyAlphaNumeric:(NSString *) aString;

/**
 Method for checking if a string contains only numbers.  Does not check to see
 if the number is a valid deciment - e.g. 0454.  Will return false if there are
 commas or decimal places.
 @param string the string to test
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

@end
