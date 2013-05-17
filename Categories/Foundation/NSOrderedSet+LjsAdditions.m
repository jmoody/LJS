#import "NSOrderedSet+LjsAdditions.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation NSOrderedSet (NSOrderedSet_LjsAdditions)

- (BOOL) not_empty {
  return [self count] != 0;
}

- (BOOL) has_objects {
  return [self count] != 0;
}


#pragma mark - Lisp

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
    return [NSOrderedSet orderedSetWithOrderedSet:self range:NSMakeRange(1, count - 1) copyItems:NO];
  }
}

- (NSOrderedSet *) reverse {
  return [self reversedOrderedSet];
}

- (NSOrderedSet *) append:(id) object {
  if (object == nil) {
    return [NSOrderedSet orderedSetWithOrderedSet:self];
  }
  
  if ([object isKindOfClass:[NSOrderedSet class]]) {
    NSOrderedSet *other = (NSOrderedSet *) object;
    NSMutableOrderedSet *res = [NSMutableOrderedSet orderedSetWithOrderedSet:self];
    for (id obj in other) {
      [res addObject:obj];
    }
    return [NSOrderedSet orderedSetWithOrderedSet:res];
  } else {
    NSMutableOrderedSet *res = [NSMutableOrderedSet orderedSetWithOrderedSet:self];
    [res addObject:object];
    return [NSOrderedSet orderedSetWithOrderedSet:res];
  }
}

#pragma mark - mapping

- (NSOrderedSet *) mapcar:(id (^)(id obj)) aBlock {
  NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSetWithCapacity:[self count]];
  for (id obj in self) {
    [result addObject:aBlock(obj)];
  }
  return [NSOrderedSet orderedSetWithOrderedSet:result];
}

- (NSOrderedSet *) mapc:(void (^)(id obj, NSUInteger idx, BOOL *stop)) aBlock {
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    aBlock(obj, idx, stop);
  }];
  return self;
}

#pragma mark - set operations

- (BOOL) equalsSet:(NSOrderedSet *) aOther {
  return [self isEqualToOrderedSet:aOther];
}


@end
