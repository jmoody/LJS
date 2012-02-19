#import "NSArray+LjsAdditions.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation NSArray (NSArray_LjsAdditions)

- (id) nth:(NSUInteger) index {
  NSUInteger count = [self count];
  if (index >= count) {
    return nil;
  } else {
    return [self objectAtIndex:index];
  }
}

- (id) first {
  return [self nth:0];
}

- (id) second {
  return [self nth:1];
}

- (id) last {
  return [self lastObject];
}

- (NSArray *) rest {
  NSUInteger count = [self count];
  if (count < 2) {
    return nil;
  } else {
    return [self subarrayWithRange:NSMakeRange(1, count - 1)];
  }
}

- (NSArray *) reverse {
  return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *) append:(id) object {
  if (object == nil) {
    return [NSArray arrayWithArray:self];
  }
  
  if ([object isKindOfClass:[NSArray class]]) {
    NSArray *other = (NSArray *) object;
    return [self arrayByAddingObjectsFromArray:other];
  } else {
    return [self arrayByAddingObject:object];
  }
}



@end
