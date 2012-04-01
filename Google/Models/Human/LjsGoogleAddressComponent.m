#import "LjsGoogleAddressComponent.h"
#import "LjsGoogleAddressComponentType.h"
#import "LjsGooglePlace.h"
#import "LjsGoogleNmoAddressComponent.h"
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

+ (LjsGoogleAddressComponent *) initWithComponent:(LjsGoogleNmoAddressComponent *) aComponent
                                            place:(LjsGooglePlace *) aPlace
                                          context:(NSManagedObjectContext *) aContext {
  LjsGoogleAddressComponent *component;
  
  component = [LjsGoogleAddressComponent insertInManagedObjectContext:aContext];
  
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
