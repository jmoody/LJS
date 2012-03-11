#import <Foundation/Foundation.h>

/**
 NSSet on NSSet_LjsAdditions category.
 */
@interface NSSet (NSSet_LjsAdditions)

- (NSArray *) sortedArrayUsingDescriptor:(NSSortDescriptor *) aSorter;
@end
