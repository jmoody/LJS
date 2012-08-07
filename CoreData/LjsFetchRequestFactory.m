#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsFetchRequestFactory.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsFetchRequestFactory ()

@end

@implementation LjsFetchRequestFactory


#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating %@", [self class]);
}

- (id) init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

#pragma mark Requests 

- (NSUInteger) countForEntity:(NSString *) aEntityName
                    predicate:(NSPredicate *) aPredicateOrNil
                      context:(NSManagedObjectContext *) aContext
                        error:(NSError **) error {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:aEntityName];
  request.predicate = aPredicateOrNil;
  NSError *localError = nil;
  NSUInteger count = [aContext countForFetchRequest:request error:&localError];
  if (count == NSNotFound) {
    DDLogError(@"error counting %@ -  %@: %@ - returning NSNotFound", aEntityName,
               [localError localizedDescription], localError);
    if (error != NULL) {
      *error = localError;
    }
  }
  return count;
}


#pragma mark Predicates

- (NSPredicate *) predicateForKey:(NSString *) aKey {
  return [NSPredicate predicateWithFormat:@"key LIKE %@", aKey];
}

- (NSPredicate *) predicateForAttribute:(NSString *)aAttributeName
                                  value:(NSString *)aAttributeValue {
  return [NSPredicate predicateWithFormat:@"%K LIKE %@", aAttributeName,
          aAttributeValue];
}

- (NSPredicate *) predicateForAttribute:(NSString *) aAttributeName
                                  value:(NSString *) aAttributeValue
                                    key:(NSString *) aKey {
  NSPredicate *kPrd = [self predicateForKey:aKey];
  NSPredicate *aPrd = [self predicateForAttribute:aAttributeName
                                                              value:aAttributeValue];
  NSArray *prds = [NSArray arrayWithObjects:kPrd, aPrd, nil];
  return [NSCompoundPredicate andPredicateWithSubpredicates:prds];
}


@end
