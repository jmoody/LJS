// Copyright 2012 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "FourEdPodcastManager.h"
#import "Lumberjack.h"
#import "4ePodcastsModel.h"
#import "LjsFetchRequestFactory.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface FourEdPodcastManager ()

@property (nonatomic, strong) LjsFetchRequestFactory *fac;
- (void) populateWithRaces;
- (void) populateWithRoles;
- (void) populateWithClasses;
- (void) populateWithPlayers;
- (void) populateWithPodcasts;
- (void) populateWithCriticalHit;

- (DndCharacter *) characterWithName:(NSString *) characterName
                   andKeysForPodcast:(NSString *) aPodcast
                              player:(NSString *) aPlayer
                                role:(NSString *) aRole
                               class:(NSString *) aClass
                                race:(NSString *) aRace;


@end

@implementation FourEdPodcastManager

@synthesize context;
@synthesize fac;

#pragma mark Memory Management
- (void) dealloc {
   DDLogDebug(@"deallocating %@", [self class]);
}

- (id) init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id) initWithContext:(NSManagedObjectContext *)aContext {
  self = [super init];
  if (self) {
    self.context = aContext;
    self.fac = [LjsFetchRequestFactory new];
    [self populateWithRaces];
    [self populateWithRoles];
    [self populateWithClasses];
    [self populateWithPlayers];
    [self populateWithPodcasts];
    [self populateWithCriticalHit];
  }
  return self;
}

- (void) populateWithRaces {
  NSArray *races = [NSArray arrayWithObjects:@"Half-Orc", @"Half-Elf",
                    @"Eladrin", @"Human", @"Elf", nil];
  __weak NSManagedObjectContext *weakCon = self.context;
  [races mapc:^(NSString *name, NSUInteger idx, BOOL *stop) {
    DndRace *race = (DndRace *)[DndRace insertInManagedObjectContext:weakCon];
    race.displayName = name;
    race.key = [[name lowercaseString] makeKeyword];
  }];
  [self saveContext:self.context];
}

- (void) populateWithRoles {
  NSArray *roles = [NSArray arrayWithObjects:@"Striker", @"Leader",
                    @"Defender", @"Controller", nil];
  __weak NSManagedObjectContext *weakCon = self.context;
  [roles mapc:^(NSString *name, NSUInteger idx, BOOL *stop) {
    DndRole *role = (DndRole *)[DndRole insertInManagedObjectContext:weakCon];
    role.displayName = name;
    role.key = [[name lowercaseString] makeKeyword];
  }];
  [self saveContext:self.context];
}

- (void) populateWithClasses {
  NSArray *classes = [NSArray arrayWithObjects:@"Sword Mage", @"Warlock",
                    @"Artificer", @"Fighter", @"Ranger", nil];
  __weak NSManagedObjectContext *weakCon = self.context;
  [classes mapc:^(NSString *name, NSUInteger idx, BOOL *stop) {
    DndClass *charClass = (DndClass *)[DndClass insertInManagedObjectContext:weakCon];
    charClass.displayName = name;
    charClass.key = [[name lowercaseString] makeKeyword];
  }];
  [self saveContext:self.context];
}

- (void) populateWithPlayers {
  NSArray *players = [NSArray arrayWithObjects:@"Stephen", @"Rob",
                      @"Matthew", @"Brian", @"Adriana", nil];
  __weak NSManagedObjectContext *weakCon = self.context;
  [players mapc:^(NSString *name, NSUInteger idx, BOOL *stop) {
    DndPlayer *player = (DndPlayer *)[DndPlayer insertInManagedObjectContext:weakCon];
    player.firstName = name;
    player.key = [[name lowercaseString] makeKeyword];
  }];
  [self saveContext:self.context];
}

- (void) populateWithPodcasts {
  NSArray *podcasts = [NSArray arrayWithObjects:@"Critical Hit", @"Crimison Bastards", nil];
  __weak NSManagedObjectContext *weakCon = self.context;
  [podcasts mapc:^(NSString *name, NSUInteger idx, BOOL *stop) {
    DndPodcast *podcast = (DndPodcast *)[DndPodcast insertInManagedObjectContext:weakCon];
    podcast.displayName = name;
    podcast.key = [[[name lowercaseString] makeKeyword] stringByReplacingOccurrencesOfString:@" "
                                                                                  withString:@"-"];
  }];
  [self saveContext:self.context];
}

- (DndCharacter *) characterWithName:(NSString *) aCharacterName
                   andKeysForPodcast:(NSString *) aPodcast
                              player:(NSString *) aPlayer
                                role:(NSString *) aRole
                               class:(NSString *) aClass
                                race:(NSString *) aRace {
  NSError *error = nil;
  NSFetchRequest *req;
  NSArray *fetched;
  
  // get podcast
  error = nil;
  req = [NSFetchRequest fetchRequestWithEntityName:[DndPodcast entityName]];
  req.predicate = [self.fac predicateForKey:aPodcast];
  fetched = [self.context executeFetchRequest:req error:&error];
  DndPodcast *podcast = [fetched first];
  
  // get matthew
  error = nil;
  req = [NSFetchRequest fetchRequestWithEntityName:[DndPlayer entityName]];
  req.predicate = [self.fac predicateForKey:aPlayer];
  fetched = [self.context executeFetchRequest:req error:&error];
  DndPlayer *player = [fetched first];
  player.podcast = podcast;
  
  error = nil;
  req = [NSFetchRequest fetchRequestWithEntityName:[DndRole entityName]];
  req.predicate = [self.fac predicateForKey:aRole];
  fetched = [self.context executeFetchRequest:req error:&error];
  DndRole *role = [fetched first];
  
  error = nil;
  req = [NSFetchRequest fetchRequestWithEntityName:[DndClass entityName]];
  req.predicate = [self.fac predicateForKey:aClass];
  fetched = [self.context executeFetchRequest:req error:&error];
  DndClass *charClass = [fetched first];
  
  error = nil;
  req = [NSFetchRequest fetchRequestWithEntityName:[DndRace entityName]];
  req.predicate = [self.fac predicateForKey:aRace];
  fetched = [self.context executeFetchRequest:req error:&error];
  DndRace *race = [fetched first];
  
  DndCharacter *character = (DndCharacter *)[DndCharacter insertInManagedObjectContext:self.context];
  character.name = aCharacterName;
  character.key = [[aCharacterName lowercaseString] makeKeyword];
  character.player = player;
  character.role = role;
  character.charClass = charClass;
  character.race = race;
  [self saveContext:self.context];
  return character;

}

- (void) populateWithCriticalHit {
  [self characterWithName:@"Torque"
        andKeysForPodcast:@":critical-hit"
                   player:@":matthew"
                     role:@":defender"
                    class:@":fighter"
                     race:@":half-orc"];

  [self characterWithName:@"Orem"
        andKeysForPodcast:@":critical-hit"
                   player:@":stephen"
                     role:@":stricker"
                    class:@":sword-mage"
                     race:@":eladrin"];

  [self characterWithName:@"Randis"
        andKeysForPodcast:@":critical-hit"
                   player:@":brian"
                     role:@":controller"
                    class:@":artificer"
                     race:@":human"];

  [self characterWithName:@"Ket"
        andKeysForPodcast:@":critical-hit"
                   player:@":rob"
                     role:@":controller"
                    class:@":warlock"
                     race:@":half-elf"];

  [self characterWithName:@"Trell"
        andKeysForPodcast:@":critical-hit"
                   player:@":adriana"
                     role:@":stricker"
                    class:@":ranger"
                     race:@":elf"];
  [self saveContext:self.context];
}

- (void) saveContext:(NSManagedObjectContext *)aContext {
  NSError *error = nil;
  if (aContext != nil) {
    if ([aContext hasChanges] && ![aContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate.
      // You should not use this function in a shipping application, although it
      // may be useful during development.
      DDLogFatal(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}


@end
