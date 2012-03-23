#import "LjsGoogleAddressComponentType.h"
#import "LjsGoogleAddressComponent.h"
#import "NSArray+LjsAdditions.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleAddressComponentType

@dynamic name;
@dynamic components;

+ (LjsGoogleAddressComponentType *) findOrCreateWithName:(NSString *) aName
                                               component:(LjsGoogleAddressComponent *) aComponent
                                                 context:(NSManagedObjectContext *)aContext {
  NSString *entityName = [NSString stringWithFormat:@"%@", [self class]];
  LjsGoogleAddressComponentType *result = nil;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
  request.predicate = [NSPredicate predicateWithFormat:@"name LIKE %@", aName];
  NSError *error = nil;
  NSArray *fetched = [aContext executeFetchRequest:request error:&error];
  if (fetched == nil) {
    DDLogFatal(@"error fetching type for name: %@ - %@: %@", aName, [error localizedDescription], error);
    abort();
  } else if ([fetched count] > 1) {
    DDLogFatal(@"error fetching type for name: %@ - found multiple types: %@", aName, fetched);
    abort();
  } else if ([fetched count] == 1) {
    result = [fetched first];
    if ([result.components containsObject:aComponent] == NO) {
      result.components = [result.components setByAddingObject:aComponent];
    }
  } else {
    result = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                           inManagedObjectContext:aContext];
    result.name = aName;
    result.components = [NSSet setWithObject:aComponent];
  }
  return result;
}


@end
