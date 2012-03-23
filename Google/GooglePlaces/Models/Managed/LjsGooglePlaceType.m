#import "LjsGooglePlaceType.h"
#import "LjsGooglePlace.h"
#import "Lumberjack.h"
#import "NSArray+LjsAdditions.h"
#import "LjsGooglePlace.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGooglePlaceType

@dynamic name;
@dynamic places;

+ (LjsGooglePlaceType *) findOrCreateWithName:(NSString *) aName
                                        place:(LjsGooglePlace *)aPlace 
                                      context:(NSManagedObjectContext *) aContext {
  NSString *entityName = [NSString stringWithFormat:@"%@", [self class]];
  LjsGooglePlaceType *result = nil;
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
    if ([result.places containsObject:aPlace] == NO) {
      result.places = [result.places setByAddingObject:aPlace];
    }
  } else {
    result = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                           inManagedObjectContext:aContext];
    result.name = aName;
    result.places = [NSSet setWithObject:aPlace];
  }
  return result;
}


@end
