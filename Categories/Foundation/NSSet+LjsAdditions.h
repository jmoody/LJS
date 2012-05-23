#import <Foundation/Foundation.h>

/**
 NSSet on NSSet_LjsAdditions category.
 */
@interface NSSet (NSSet_LjsAdditions)

- (BOOL) emptyp;
+ (BOOL) setIsEmptyP:(NSSet *) aSet;

- (NSArray *) sortedArrayUsingDescriptor:(NSSortDescriptor *) aSorter;
- (NSSet *) mapcar:(id (^)(id obj)) aBlock;
- (NSSet *) mapc:(void (^)(id obj)) aBlock;
// the threshold for useful concurrency is 10,000 and 50,000 objects
//http://darkdust.net/writings/objective-c/nsarray-enumeration-performance#The_graphs
- (NSSet *) mapc:(void (^)(id obj)) aBlock concurrent:(BOOL) aConcurrent;

@end
