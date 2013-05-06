#import <Foundation/Foundation.h>

/**

 */
@interface NSArray (NSArray_LjsAdditions)

// avoiding emptyp because we want this to respond NO when called on nil
- (BOOL) not_empty;
- (BOOL) has_objects;

#pragma mark - Lisp

- (id) nth:(NSUInteger) index;
- (id) first;
- (id) second;
- (id) last;
- (NSArray *) rest;
- (NSArray *) reverse;
- (NSArray *) append:(id) object;

- (NSArray *) mapcar:(id (^)(id obj)) aBlock;
- (NSArray *) mapc:(void (^)(id obj, NSUInteger idx, BOOL *stop)) aBlock;
// the threshold for useful concurrency is 10,000 and 50,000 objects
//http://darkdust.net/writings/objective-c/nsarray-enumeration-performance#The_graphs
- (NSArray *) mapc:(void (^)(id obj, NSUInteger idx, BOOL *stop)) aBlock concurrent:(BOOL) aConcurrent;

#pragma mark - Sorting

- (NSArray *) sortedArrayUsingDescriptor:(NSSortDescriptor *) aSorter;

#pragma mark - Filtering

- (NSArray *) arrayByRemovingObjectsInArray:(NSArray *) aArray;
// https://github.com/Gabro/NSArray-filter-using-block.git
- (NSArray *) filteredArrayUsingPassingBlock:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

#pragma mark - Strings <==> Enumerations

// http://stackoverflow.com/questions/1242914/converting-between-c-enum-and-xml/1243622#1243622
- (NSString *) stringWithEnum:(NSUInteger) enumVal;
- (NSUInteger) enumFromString:(NSString *) strVal default: (NSUInteger) def;
- (NSUInteger) enumFromString:(NSString *) strVal;

@end
