#import <Foundation/Foundation.h>

/**
 NSSet on NSSet_LjsAdditions category.
 */
@interface NSSet (NSSet_LjsAdditions)

- (BOOL) emptyp;
+ (BOOL) setIsEmptyP:(NSSet *) aSet;

- (NSArray *) sortedArrayUsingDescriptor:(NSSortDescriptor *) aSorter;

@end
