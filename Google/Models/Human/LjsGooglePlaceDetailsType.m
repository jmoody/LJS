#import "LjsGooglePlaceDetailsType.h"
#import "LjsGooglePlaceDetails.h"
#import "Lumberjack.h"
#import "NSArray+LjsAdditions.h"
#import "LjsGooglePlaceDetails.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


@implementation LjsGooglePlaceDetailsType


+ (LjsGooglePlaceDetailsType *) findOrCreateWithName:(NSString *) aName
                                               place:(LjsGooglePlaceDetails *)aPlace 
                                             context:(NSManagedObjectContext *) aContext {
  NSString *entityName = [LjsGooglePlaceDetailsType entityName];
  LjsGooglePlaceDetailsType *result = nil;
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
    if ([result.places containsObject:aPlace] == NO) {
      result.places = [result.places setByAddingObject:aPlace];
    }
  } else {
    result = [LjsGooglePlaceDetailsType insertInManagedObjectContext:aContext];
    result.name = aName;
    result.places = [NSSet setWithObject:aPlace];
  }
  return result;
}


@end
