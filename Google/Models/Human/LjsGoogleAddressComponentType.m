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

+ (LjsGoogleAddressComponentType *) findOrCreateWithName:(NSString *) aName
                                               component:(LjsGoogleAddressComponent *) aComponent
                                                 context:(NSManagedObjectContext *)aContext {
  NSString *entityName = [LjsGoogleAddressComponentType entityName];
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
    result = [LjsGoogleAddressComponentType insertInManagedObjectContext:aContext];
    result.name = aName;
    result.components = [NSSet setWithObject:aComponent];
  }
  return result;
}

- (NSString *) description {
  return [NSString stringWithFormat:@"#%@", self.name];
}

@end
