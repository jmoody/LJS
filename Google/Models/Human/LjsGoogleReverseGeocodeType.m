#import "LjsGoogleReverseGeocodeType.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleReverseGeocodeType

+ (LjsGoogleReverseGeocodeType *) findOrCreateWithName:(NSString *) aName
                                               geocode:(LjsGoogleReverseGeocode *) aGeocode
                                               context:(NSManagedObjectContext *) aContext {
  NSString *entityName = [LjsGoogleReverseGeocodeType entityName];
  LjsGoogleReverseGeocodeType *result = nil;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
  request.predicate = [NSPredicate predicateWithFormat:@"name == %@", aName];
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
    if ([result.geocodes containsObject:aGeocode] == NO) {
      result.geocodes = [result.geocodes setByAddingObject:aGeocode];
    }
  } else {
    result = [LjsGoogleReverseGeocodeType insertInManagedObjectContext:aContext];
    result.name = aName;
    result.geocodes = [NSSet setWithObject:aGeocode];
  }
  return result;
}


@end
