//From http://www.cocoadev.com/index.pl?FTSWAbstractSingleton

#import <Foundation/Foundation.h>

@interface FTSWAbstractSingleton : NSObject {

}

+ (id)singleton;
+ (id)singletonWithZone:(NSZone*)zone;
+ (id)sharedInstance;

  //designated initializer, subclasses must implement and call supers implementation
- (id)initSingleton; 

@end
