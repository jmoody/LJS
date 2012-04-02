#import "LjsGoogleAddressComponentGeocode.h"
#import "Lumberjack.h"
#import "LjsGoogleAddressComponentType.h"
#import "LjsGoogleReverseGeocode.h"
#import "LjsGoogleNmoAddressComponent.h"


#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif


@implementation LjsGoogleAddressComponentGeocode

+ (LjsGoogleAddressComponentGeocode *) initWithComponent:(LjsGoogleNmoAddressComponent *) aComponent
                                                  gecode:(LjsGoogleReverseGeocode *) aGeocode
                                                 context:(NSManagedObjectContext *) aContext {
  LjsGoogleAddressComponentGeocode *component;
  
  component = [LjsGoogleAddressComponentGeocode insertInManagedObjectContext:aContext];
  
  component.longName = aComponent.longName;
  component.shortName = aComponent.shortName;
  
  for (NSString *typeStr in aComponent.types) {
    // adds component to type components Set
    [LjsGoogleAddressComponentType findOrCreateWithName:typeStr
                                              component:component
                                                context:aContext];
    
  }
  component.geocode = aGeocode;
  return component;
}


@end
