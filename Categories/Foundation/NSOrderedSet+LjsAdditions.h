#import <Foundation/Foundation.h>

/**
 NSOrderedSet on NSOrderedSet_LjsAdditions category.
 */
@interface NSOrderedSet (NSOrderedSet_LjsAdditions)

- (BOOL) not_empty;
- (BOOL) has_objects;

- (id) nth:(NSUInteger) index;
- (id) first;
- (id) second;
- (id) last;
- (NSOrderedSet *) append:(id) object;
- (NSOrderedSet *) reverse;
- (NSOrderedSet *) mapcar:(id (^)(id obj)) aBlock;
- (NSOrderedSet *) mapc:(void (^)(id obj, NSUInteger idx, BOOL *stop)) aBlock;
- (BOOL) equalsSet:(NSOrderedSet *) aOther;
@end
