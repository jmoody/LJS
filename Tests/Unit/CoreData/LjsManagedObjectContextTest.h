#import "LjsTestCase.h"


@interface LjsManagedObjectContextTest: LjsTestCase {}

- (void) saveContext:(NSManagedObjectContext *) aContext;
- (NSManagedObjectContext *) contextWithStoreNamed:(NSString *) aStoreName;
- (NSManagedObjectContext *) inMemoryContextWithModelName:(NSString *) aModelName;

@end
