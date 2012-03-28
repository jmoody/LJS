#import "LjsGoogleAttribution.h"
#import "Lumberjack.h"
#import "LjsGooglePlacesNmoAttribution.h"
#import "NSArray+LjsAdditions.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleAttribution

+ (LjsGoogleAttribution *) findOrCreateWithAtribution:(LjsGooglePlacesNmoAttribution *) aAttribution
                                                place:(LjsGooglePlace *) aPlace
                                              context:(NSManagedObjectContext *) aContext {
  NSString *entityName = [NSString stringWithFormat:@"%@", [self class]];
  NSString *html = aAttribution.html;
  LjsGoogleAttribution *result = nil;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
  request.predicate = [NSPredicate predicateWithFormat:@"html LIKE %@", html];
  NSError *error = nil;
  NSArray *fetched = [aContext executeFetchRequest:request error:&error];
  if (fetched == nil) {
    DDLogFatal(@"error fetching attribute for html: %@ - %@: %@", html, [error localizedDescription], error);
    abort();
  } else if ([fetched count] > 1) {
    DDLogFatal(@"error fetching type for name: %@ - found multiple types: %@", html, fetched);
    abort();
  } else if ([fetched count] == 1) {
    result = [fetched first];
    if ([result.places containsObject:aPlace] == NO) {
      result.places = [result.places setByAddingObject:aPlace];
    }
  } else {
    result = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                           inManagedObjectContext:aContext];
    result.html = html;
    result.places = [NSSet setWithObject:aPlace];
  }
  return result;
  
}

@end
