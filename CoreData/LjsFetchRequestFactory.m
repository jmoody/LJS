#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsFetchRequestFactory.h"
#import "Lumberjack.h"
#import "LjsValidator.h"

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
                        error:(NSError **) aError {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"entity name" ifNilOrEmptyString:aEntityName];
  [reasons addReasonWithVarName:@"context" ifNil:aContext];
  if ([reasons hasReasons]) {
    NSString *message = [reasons explanation:@"could not perform count request"
                                 consequence:@"NSNotFound and populating error"];
    DDLogError(message);
    if (aError != NULL) {
      *aError = [NSError errorWithDomain:[[self class] description]
                                    code:LjsFetchRequestFactoryErrorCodeBadArguments
                    localizedDescription:message];
    }
    return NSNotFound;
  }

  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:aEntityName];
  request.predicate = aPredicateOrNil;
  NSError *localError = nil;
  NSUInteger count = [aContext countForFetchRequest:request error:&localError];
  if (count == NSNotFound) {
    DDLogError(@"error counting %@ -  %@: %@ - returning NSNotFound", aEntityName,
               [localError localizedDescription], localError);
    if (aError != NULL) {
      *aError = localError;
    }
  }
  return count;
}

- (BOOL) entityExistsForKey:(NSString *) aKey
                 entityName:(NSString *) aEntityName
                    context:(NSManagedObjectContext *) aContext
                      count:(NSUInteger *)aCountRef
                      error:(NSError **) aError {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"key" ifNilOrEmptyString:aKey];
  [reasons addReasonWithVarName:@"entity name" ifNilOrEmptyString:aEntityName];
  [reasons addReasonWithVarName:@"context" ifNil:aContext];
  if ([reasons hasReasons]) {
    NSString *message = [reasons explanation:@"could not perform existence check"
                                 consequence:@"NO: populating error and setting count ref to NSNotFound"];
    DDLogError(message);
    if (aError != NULL) {
      *aError = [NSError errorWithDomain:[[self class] description]
                                    code:LjsFetchRequestFactoryErrorCodeBadArguments
                    localizedDescription:message];
    }
    if (aCountRef != NULL) *aCountRef = NSNotFound;
    // return value is meaningless
    return NO;
  }

  NSPredicate *prd = [self predicateForKey:aKey];
  NSError *localError = nil;
  NSUInteger count = [self countForEntity:aEntityName
                                predicate:prd
                                  context:aContext
                                    error:&localError];
  if (count == NSNotFound && aError != NULL) {
    *aError = localError;
    // return value is meaningless if count == NSNotFound
    return NO;
  }
  
  if (aCountRef != NULL) *aCountRef = count;
  
  return count > 0;
}


- (id) entityForKey:(NSString *) aKey
         entityName:(NSString *) aEntityName
              count:(NSUInteger *) aCountRef
            context:(NSManagedObjectContext *) aContext
              error:(NSError **) aError {
  LjsReasons *reasons = [LjsReasons new];
  [reasons addReasonWithVarName:@"key" ifNilOrEmptyString:aKey];
  [reasons addReasonWithVarName:@"entity name" ifNilOrEmptyString:aEntityName];
  [reasons addReasonWithVarName:@"context" ifNil:aContext];
  if ([reasons hasReasons]) {
    NSString *message = [reasons explanation:@"could perform fetch"
                                 consequence:@"nil: populating error and setting count ref to NSNotFound"];
    DDLogError(message);
    if (aError != NULL) {
      *aError = [NSError errorWithDomain:[[self class] description]
                                    code:LjsFetchRequestFactoryErrorCodeBadArguments
                    localizedDescription:message];
    }
    
    if (aCountRef != NULL) *aCountRef = NSNotFound;
    
    return nil;
  }
  
  NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:aEntityName];
  req.predicate = [self predicateForKey:aKey];
  NSError *localError = nil;
  NSArray *fetched = [aContext executeFetchRequest:req
                                             error:&localError];
  if (fetched == nil) {
    DDLogError(@"error fetching %@ -  %@: %@ - returning nil", aEntityName,
               [localError localizedDescription], localError);
    if (aError != NULL) {
      *aError = localError;
    }
    return nil;
  }
  
  if (aCountRef != NULL) *aCountRef = [fetched count];
  // return the first regardless
  return [fetched first];
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
