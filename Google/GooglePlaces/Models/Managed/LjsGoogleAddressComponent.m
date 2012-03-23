#import "LjsGoogleAddressComponent.h"
#import "LjsGoogleAddressComponentType.h"
#import "LjsGooglePlace.h"
#import "LjsGooglePlacesNmoAddressComponent.h"
#import "NSArray+LjsAdditions.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsGoogleAddressComponent ()

@end

@implementation LjsGoogleAddressComponent

@dynamic longName;
@dynamic shortName;
@dynamic place;
@dynamic types;

+ (LjsGoogleAddressComponent *) initWithComponent:(LjsGooglePlacesNmoAddressComponent *) aComponent
                                            place:(LjsGooglePlace *) aPlace
                                          context:(NSManagedObjectContext *) aContext {
  LjsGoogleAddressComponent *component;
  
  component = [NSEntityDescription insertNewObjectForEntityForName:@"LjsGoogleAddressComponent"
                                            inManagedObjectContext:aContext];
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
