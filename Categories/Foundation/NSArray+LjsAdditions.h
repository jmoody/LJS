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
- (NSArray *) mapcar:(id (^)(id obj)) aBlock;
- (NSArray *) mapc:(void (^)(id obj)) aBlock;
// the threshold for useful concurrency is 10,000 and 50,000 objects
//http://darkdust.net/writings/objective-c/nsarray-enumeration-performance#The_graphs
- (NSArray *) mapc:(void (^)(id obj)) aBlock concurrent:(BOOL) aConcurrent;
- (BOOL) emptyp;
- (NSArray *) arrayByRemovingObjectsInArray:(NSArray *) aArray;
@end
