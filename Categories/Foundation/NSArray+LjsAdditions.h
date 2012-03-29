#import <Foundation/Foundation.h>

/**
 NSArray on NSArray_Lisp category.
 
 It is a start.
 */
@interface NSArray (NSArray_LjsAdditions)


- (id) nth:(NSUInteger) index;
- (id) first;
- (id) second;
- (id) last;
- (NSArray *) rest;
- (NSArray *) reverse;
- (NSArray *) append:(id) object;
- (NSArray *) sortedArrayUsingDescriptor:(NSSortDescriptor *) aSorter;
- (NSArray *) pushObject:(id) object;

@end
