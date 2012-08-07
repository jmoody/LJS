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

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface FourEdPodcastManager ()

- (void) populateWithRaces;

@end

@implementation FourEdPodcastManager

@synthesize context;

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
    [self populateWithRaces];
  }
  return self;
}

- (void) populateWithRaces {
  NSArray *races = [NSArray arrayWithObjects:@"Half-Orc", @"Half-Elf",
                    @"Eladrin", @"Human", @"Elf", nil];
  __weak NSManagedObjectContext *weakCon = self.context;
  [races mapc:^(NSString *name, NSUInteger idx, BOOL *stop) {
    DndRace *race = (DndRace *)[DndRace insertInManagedObjectContext:weakCon];
    race.name = name;
    race.key = [[name lowercaseString] makeKeyword];
  }];
}

@end
