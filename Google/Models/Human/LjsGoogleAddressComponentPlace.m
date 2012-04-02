#import "LjsGoogleAddressComponentPlace.h"
#import "LjsGoogleAddressComponentType.h"
#import "LjsGooglePlaceDetails.h"
#import "LjsGoogleNmoAddressComponent.h"
#import "LjsGooglePlaceDetails.h"



#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsGoogleAddressComponentPlace

+ (LjsGoogleAddressComponentPlace *) initWithComponent:(LjsGoogleNmoAddressComponent *) aComponent
                                                 place:(LjsGooglePlaceDetails *) aPlace
                                               context:(NSManagedObjectContext *) aContext {
  LjsGoogleAddressComponentPlace *component;
  
  component = [LjsGoogleAddressComponentPlace insertInManagedObjectContext:aContext];
  
  component.longName = aComponent.longName;
  component.shortName = aComponent.shortName;
  
  for (NSString *typeStr in aComponent.types) {
    // adds component to type components Set
    [LjsGoogleAddressComponentType findOrCreateWithName:typeStr
                                              component:component
                                                context:aContext];
    
  }
  component.place = aPlace;
  return component;

}
@end
