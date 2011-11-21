#import "LjsValidator.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsValidator

#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating LjsValidator");
  [super dealloc];
}

- (id) init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

+ (BOOL) string:(NSString *) aString containsOnlyMembersOfCharacterSet:(NSCharacterSet *) aCharacterSet {
  BOOL result;
  if (aCharacterSet == nil) {
    DDLogError(@"the character set was nil - returning NO");
    result = NO;
  } else {
    if (aString != nil && [aString length] > 0) {
      NSCharacterSet *inverted = [aCharacterSet invertedSet];
      NSArray *array = [aString componentsSeparatedByCharactersInSet:inverted];
      result = [array count] == 1;
    } else {
      DDLogWarn(@"the string was nil or empty - return NO");
      result = NO;
    }
  }
  return result;
}

+ (BOOL) stringContainsOnlyAlphaNumeric:(NSString *) aString {
  BOOL result = NO;
  if (aString != nil && [aString length] > 0) {
    NSCharacterSet *alphaNumeric = [NSCharacterSet alphanumericCharacterSet];
    result = [LjsValidator string:aString containsOnlyMembersOfCharacterSet:alphaNumeric];
    
  }
  return result;
}


+ (BOOL) stringContainsOnlyNumbers:(NSString *) aString {
  BOOL result = NO;
  if (aString != nil && [aString length] > 0) {
    NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
    result = [LjsValidator string:aString containsOnlyMembersOfCharacterSet:decimalSet];
  }
  return result;
}

+ (BOOL) isDictionary:(id) value {
  return [value respondsToSelector:@selector(objectForKey:)];
}

+ (BOOL) isArray:(id)value {
  return [value respondsToSelector:@selector(objectAtIndex:)];
}

+ (BOOL) isString:(id) value {
  return [value respondsToSelector:@selector(componentsSeparatedByString:)];
}

+ (BOOL) dictionary:(NSDictionary *) dictionary containsKey:(NSString *) key {
  return [dictionary objectForKey:key] != nil;
}

+ (BOOL) dictionary:(NSDictionary *) dictionary containsKeys:(NSArray *)keys {
  BOOL result = YES;
  for (NSString *key in keys) {
    if (![LjsValidator dictionary:dictionary containsKey:key]) {
      result = NO;
      break;
    }
  }
  return result;
}


+ (BOOL) dictionary:(NSDictionary *)dictionary 
       containsKeys:(NSArray *) keys
       allowsOthers:(BOOL) allowsOthers {
  BOOL result;
  if (allowsOthers == NO) {
    result = ([keys count] == [[dictionary allKeys] count] &&
              [LjsValidator dictionary:dictionary
                          containsKeys:keys]);
  } else {
    result = [LjsValidator dictionary:dictionary containsKeys:keys];
  }
  return result;
}


@end
