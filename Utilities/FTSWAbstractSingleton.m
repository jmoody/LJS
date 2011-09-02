#import "FTSWAbstractSingleton.h"


@implementation FTSWAbstractSingleton

static NSMutableDictionary  *s_FTSWAbstractSingleton_singletons = nil;

+ (void)initialize
{
  @synchronized([FTSWAbstractSingleton class]) {
    if (s_FTSWAbstractSingleton_singletons == nil) {
      s_FTSWAbstractSingleton_singletons = [[NSMutableDictionary alloc] init];
    }
  }
}

// Should be considered private to the abstract singleton class, 
// wrap with a "sharedXxx" class method
+ (id)singleton
{
  return [self singletonWithZone:[self zone]];
}

+ (id)sharedInstance {
  return [self singletonWithZone:[self zone]];
}


// Should be considered private to the abstract singleton class
+ (id)singletonWithZone:(NSZone*)zone
{
  id singleton = nil;
  Class class = [self class];
  
  if (class == [FTSWAbstractSingleton class]) {
    [NSException raise:NSInternalInconsistencyException
                format:@"Not valid to request the abstract singleton."];
  }
  
  @synchronized([FTSWAbstractSingleton class]) {
    singleton = [s_FTSWAbstractSingleton_singletons objectForKey:class];
    if (singleton == nil) {
      singleton = NSAllocateObject(class, 0U, zone);
      if ((singleton = [singleton initSingleton]) != nil) {
        [s_FTSWAbstractSingleton_singletons setObject:singleton forKey:class];
      }
    }
  }
  
  return singleton;
}

// Designated initializer for instances. If subclasses override they
// must call this implementation.
- (id)initSingleton {
  return [super init];
}

// Disallow the normal default initializer for instances.
- (id)init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

// ------------------------------------------------------------------------------
// The following overrides attempt to enforce singleton behavior.

+ (id)new
{
  return [self singleton];
}

+ (id)allocWithZone:(NSZone *)zone
{
  return [self singletonWithZone:zone];
}

+ (id)alloc
{
  return [self singleton];
}

- (id)copy
{
  //[self doesNotRecognizeSelector:_cmd]; //optional, do if you want to force certain usage pattern
  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  //[self doesNotRecognizeSelector:_cmd]; //optional, do if you want to force certain usage pattern
  return self;
}

- (id)mutableCopy
{
  //[self doesNotRecognizeSelector:_cmd]; //optional, do if you want to force certain usage pattern
  return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
  //[self doesNotRecognizeSelector:_cmd]; //optional, do if you want to force certain usage pattern
  return self;
}

- (oneway void)release
{
}

- (id)retain
{
  return self;
}

- (id)autorelease
{

  return self;
}

- (void)dealloc
{
  //optional, do if you want to force certain usage pattern
  //[self doesNotRecognizeSelector:_cmd];  
  [super dealloc];
  
}
// ------------------------------------------------------------------------------

@end


