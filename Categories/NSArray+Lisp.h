#import <Foundation/Foundation.h>

/**
 NSArray on NSArray_Lisp category.
 */
@interface NSArray (NSArray_Lisp)

- (id) nth:(NSUInteger) index;

- (id) first;
- (id) second;
- (id) last;
- (NSArray *) rest;

@end
