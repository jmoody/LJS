// Copyright 2011 The Little Joy Software Company. All rights reserved.
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

#import "LjsReachabilityObserver.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *LjsReachabilityObserverTimedOutNotification = @"com.littlejoysoftware.LJS Reachability Observer Timed Out Notification";
NSString *LjsReachabilityObserverStatusChangedNotification = @"com.littlejoysoftware.LJS Reachability Observer Status Changed Notification";
NSString *LjsReachabilityObserverStatusUserInfoKey = @"com.littlejoysoftware.LJS Reachability Observer Status UserInfo Key";

static NSString *LjsReachabilityObserverDefaultHost = @"www.google.com";

@implementation LjsReachabilityObserver

@synthesize internetReachability;
@synthesize hostReachability;
@synthesize reachabilityRequest;
@synthesize hostName;
@synthesize reachabilityUrl;
@synthesize connectivityStatus;

#pragma mark Memory Management

- (void) stopAndReleaseRepeatingTimers {
  [super stopAndReleaseRepeatingTimers];
  if (self.reachabilityRequest != nil) {
    [self.reachabilityRequest cancel];
    self.reachabilityRequest = nil;
  }
}

- (void) startAndRetainRepeatingTimers {
  [super startAndRetainRepeatingTimers];
  self.connectivityStatus = LjsConnectivityStatusNoInternet;
  if (self.reachabilityRequest != nil) {
    [self.reachabilityRequest cancel];
    self.reachabilityRequest = nil;
  }
}


- (void) dealloc {
  DDLogDebug(@"deallocating LjsReachabilityObserver");
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self stopAndReleaseRepeatingTimers];
  self.internetReachability = nil;
  self.hostReachability = nil;
  self.hostName = nil;
  self.reachabilityUrl = nil;
  [super dealloc];
}


- (id) initWithTimerFrequency:(NSTimeInterval)aTimerFrequency {
  self = [super initWithTimerFrequency:aTimerFrequency];
  if (self != nil) {
    self.hostName = LjsReachabilityObserverDefaultHost;
    [self configure];
  }
  return self;
}


- (id) initWithTimerFrequency:(NSTimeInterval) aTimerFrequency
                timesToRepeat:(NSUInteger) aTimesToRepeat {
  self = [super initWithTimerFrequency:aTimerFrequency timesToRepeat:aTimesToRepeat]; 
  if (self != nil) {
    self.hostName = LjsReachabilityObserverDefaultHost;
    [self configure];
  }
  return self;
}
  
- (id) initWithTimerFrequency:(NSTimeInterval) aTimerFrequency
                timesToRepeat:(NSUInteger) aTimesToRepeat
                     hostName:(NSString *) aHostName {
  self = [super initWithTimerFrequency:aTimerFrequency]; 
  if (self != nil) {
    self.hostName = aHostName;
    [self configure];
  }
  return self;
}


- (id) initWithTimerFrequency:(NSTimeInterval)aTimerFrequency
                     hostName:(NSString *) aHostName {
  self = [super initWithTimerFrequency:aTimerFrequency];
  if (self != nil) {
    self.hostName = aHostName;
    [self configure];
  }
  return self;
}


- (void) configure {
  NSString *escapedHost =
  [self.hostName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  [[NSNotificationCenter defaultCenter] 
   addObserver:self 
   selector:@selector(handleReachabilityStatusChanged:)
   name:kReachabilityChangedNotification object:nil];
  
  self.internetReachability = [Reachability reachabilityForInternetConnection];
  [self.internetReachability startNotifier];
  
  self.hostReachability = [Reachability reachabilityWithHostName:escapedHost];
  [self.hostReachability startNotifier];
  
  self.reachabilityUrl = [NSURL URLWithString:[@"http://" stringByAppendingString:escapedHost]];
  
  self.reachabilityRequest = nil;
  
  self.connectivityStatus = LjsConnectivityStatusNoInternet;
}

- (void) handleHostReachabilityRequest:(ASIHTTPRequest *) aRequest {
  DDLogDebug(@"handling host reachability request");
  self.reachabilityRequest = nil;
}


- (void) doRepeatedAction:(NSTimer *)aTimer {
  if (self.repeatCount < self.numberOfTimesToRepeat) {
    if (self.reachabilityRequest == nil) {
      ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:self.reachabilityUrl] autorelease];
      [request setRequestMethod:@"GET"]; 
      [request setDelegate:self];
      [request setDidFailSelector:@selector(handleHostReachabilityRequest:)];
      [request setDidFinishSelector:@selector(handleHostReachabilityRequest:)];
      [request startAsynchronous];

      self.repeatCount = self.repeatCount + 1;
    } else {
      DDLogDebug(@"throttling request because previous has not finished.");
    }
  } else {
    DDLogDebug(@"timer has completed - stopping and releasing");
    
    [self stopAndReleaseRepeatingTimers];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:LjsReachabilityObserverTimedOutNotification 
     object:nil
     userInfo:[self userInfoWithConnectivityStatus:self.connectivityStatus]];
  }
}

- (void) handleReachabilityStatusChanged:(NSNotification *) aNotification {
  DDLogDebug(@"handling reachability status changed notification");
  
  BOOL internetReachable, hostReachable;
  NetworkStatus internetStatus = [self.internetReachability currentReachabilityStatus];
  NetworkStatus hostStatus = [self.hostReachability currentReachabilityStatus];
  
  switch (internetStatus) {
    case NotReachable:
      internetReachable = NO;
      break;
    case ReachableViaWiFi:
      internetReachable = YES;
      break;
    case ReachableViaWWAN:
      internetReachable = YES;
      break;
    default:
      DDLogError(@"fell through internet status switch statement");
      internetReachable = NO;
      break;
  }
  
  switch (hostStatus) {
    case NotReachable:
      hostReachable = NO;
      break;
    case ReachableViaWiFi:
      hostReachable = YES;
      break;
    case ReachableViaWWAN:
      hostReachable = YES;
      break;
    default:
      DDLogError(@"fell through host status switch statement");
      hostReachable = NO; 
      break;
  }
  
  LjsConnectivityStatus oldStatus = self.connectivityStatus;
  if (internetReachable == NO && hostReachable == NO) {
    self.connectivityStatus = LjsConnectivityStatusNoInternet;
  } else if (internetReachable == YES && hostReachable == NO) {
    self.connectivityStatus = LjsConnectivityStatusInternetAndNoHost;
  } else if (internetReachable == YES && hostReachable == YES) {
    self.connectivityStatus = LjsConnectivityStatusInternetAndHost;
  } else {
    // impossible - host cannot be reachable and the internet down
    DDLogError(@"reached an impossible state - host is reachable but the internet is not");
    self.connectivityStatus = LjsConnectivityStatusNoInternet;
  }
  
  if (oldStatus != self.connectivityStatus) {
    NSDictionary *userInfo = [self userInfoWithConnectivityStatus:self.connectivityStatus];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LjsReachabilityObserverStatusChangedNotification
                                                        object:nil 
                                                      userInfo:userInfo];
  } else {
    DDLogDebug(@"old status is the same as current status < %d > no need to post a notification");
  }
}

- (NSDictionary *) userInfoWithConnectivityStatus:(LjsConnectivityStatus) aStatus {
  return [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:aStatus]
                                     forKey:LjsReachabilityObserverStatusUserInfoKey];
}


@end
