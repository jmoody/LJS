#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation NSSet (NSSet_LjsAdditions)

- (BOOL) not_empty {
  return [self count] != 0;
}

- (BOOL) has_objects {
  return [self count] != 0;
}

- (NSArray *) sortedArrayUsingDescriptor:(NSSortDescriptor *) aSorter {
  NSArray *array = [NSArray arrayWithObject:aSorter];
  return [self sortedArrayUsingDescriptors:array];
}

- (NSSet *) mapcar:(id (^)(id obj)) aBlock {
  NSMutableSet *result = [NSMutableSet setWithCapacity:[self count]];
  for (id obj in self) {
    [result addObject:aBlock(obj)];
  }
  return [NSSet setWithSet:result];
}

- (NSSet *) mapc:(void (^)(id obj, BOOL *stop)) aBlock  {
  return [self mapc:aBlock concurrent:NO];
}

- (NSSet *) mapc:(void (^)(id obj, BOOL *stop)) aBlock concurrent:(BOOL) aConcurrent {
  if (aConcurrent == YES) {
    [self enumerateObjectsWithOptions:NSEnumerationConcurrent
                           usingBlock:^(id obj, BOOL *stop) {
                             aBlock(obj, stop);
                           }];
  
  } else {
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
      aBlock(obj, stop);
    }];
  }
  return self;
}

@end
