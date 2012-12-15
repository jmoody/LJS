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

#import "LjsCurrentWeather.h"
#import "Lumberjack.h"
#import "LjsLocationManager.h"
#import "SBJson.h"
#import "LjsValidator.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSInteger const LjsCurrentWeatherNotFoundInteger = -999;
CGFloat const LjsCurrentWeatherNotFoundFloat = -999.0;

NSString *LjsCurrentWeatherRequestDidFinishNotification = @"com.littlejoysoftware.LJS Current Weather Request Did Finish Notification";

static NSString *LjsCurrentWeatherDataKey = @"data";
static NSString *LjsCurrentWeatherCurrentConditionKey = @"current_condition";
static NSString *LjsCurrentWeatherErrorKey = @"error";
static NSString *LjsCurrentWeatherRequestKey = @"request";
static NSString *LjsCurrentWeatherValueKey = @"value";
static NSString *LjsCurrentWeatherCloudCoverKey = @"cloudcover";
static NSString *LjsCurrentWeatherHumidtyKey = @"humidity";
static NSString *LjsCurrentWeatherTimeKey = @"\"observation_time\"";
static NSString *LjsCurrentWeatherPrecipMMKey = @"precipMM";
static NSString *LjsCurrentWeatherPressureKey = @"pressure";
static NSString *LjsCurrentWeatherTempCKey = @"temp_C";
static NSString *LjsCurrentWeatherTempFKey = @"temp_F";
static NSString *LjsCurrentWeatherVisibilityKey = @"visibility";
static NSString *LjsCurrentWeatherCodeKey = @"weatherCode";
static NSString *LjsCurrentWeatherDescriptionKey = @"weatherDesc";
static NSString *LjsCurrentWeatherIconURLKey = @"weatherIconUrl";
static NSString *LjsCurrentWeatherWind16pointKey = @"winddir16Point";
static NSString *LjsCurrentWeatherWindDegreeKey = @"winddirDegree";
static NSString *LjsCurrentWeatherWindKmphKey = @"windspeedKmph";
static NSString *LjsCurrentWeatherWindMphKey = @"windspeedMiles";

static NSString *LjsCurrentWeatherUrlFormatString = @"http://free.worldweatheronline.com/feed/weather.ashx?q=%@,%@&format=json&num_of_days=1&key=%@";
static NSString *LjsCurrentWeatherApiKeyPlist = @"weather-api-key";
static NSString *LjsCurrentWeatherApiKeyKey = @"free.worldweatheronline.com.LJS Key";


@implementation LjsCurrentWeather

@synthesize latitude, longitude;
@synthesize responseUtils;
@synthesize currentConditions;
@synthesize requestURL;




#pragma mark Memory Management
- (void) dealloc {
   DDLogDebug(@"deallocating %@", [self class]);
}

- (id) initWithLatitude:(NSDecimalNumber *)aLatitude longitude:(NSDecimalNumber *)aLongitude {
  self = [super init];
  if (self != nil) {
    BOOL isValidLat = [LjsLocationManager isValidLatitude:aLatitude];
    BOOL isValidLong = [LjsLocationManager isValidLongitude:aLongitude];
    NSAssert1(isValidLat, @"latitude < %@ > must be valid", aLatitude);
    NSAssert1(isValidLong, @"longitude < %@ > must be valid", aLongitude);
    
    if (!isValidLat || !isValidLong) {
      DDLogError(@"lat and lon must be valid: (%@, %@)", aLatitude, aLongitude);
      return nil;
    }
    self.latitude = aLatitude;
    self.longitude = aLongitude;
    self.responseUtils = [[ASIHTTPResponseUtils alloc] init];
    self.currentConditions = nil;
  }
  return self;
}


- (BOOL) startRequest {
  NSBundle *main = [NSBundle mainBundle];
  NSString *path = [main pathForResource:LjsCurrentWeatherApiKeyPlist ofType:@"plist"];
  NSDictionary *apiDict = [NSDictionary dictionaryWithContentsOfFile:path];
  BOOL success = NO;
  if (apiDict == nil || [apiDict count] == 0) {
    DDLogError(@"could not find < %@.plist > at path %@ - nothing to do < %@ >", 
               LjsCurrentWeatherApiKeyPlist, path, apiDict);
  } else {
    NSString *apiKey = [apiDict objectForKey:LjsCurrentWeatherApiKeyKey];
    if (apiKey == nil || [apiKey length] == 0) {
      DDLogError(@"could not find an api key in %@ - nothing to do", apiDict);
    } else {
      NSString *urlPath = [NSString stringWithFormat:LjsCurrentWeatherUrlFormatString,
                        self.latitude, self.longitude, apiKey];
      self.requestURL = [NSURL URLWithString:[urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
      ASIHTTPRequest *request = [[ASIHTTPRequest alloc]
                                  initWithURL:self.requestURL];
      [request setRequestMethod:@"GET"]; 
      [request setDelegate:self];
      [request setDidFailSelector:@selector(handleWeatherRequestDidFail:)];
      [request setDidFinishSelector:@selector(handleWeatherRequestDidFinish:)];
      [request startAsynchronous];
      success = YES;
    }
  }
  return success;
}


- (void) handleWeatherRequestDidFail:(ASIHTTPRequest *) aRequest {
  DDLogDebug(@"handle weather request did fail");
  if ([self.responseUtils requestDidTimeOut:aRequest]) {
    DDLogError(@"request timed out - nothing to do");
  } else {
    DDLogError(@"weather request failed: %@", [self.responseUtils responseDescriptionForRequest:aRequest]);
    DDLogError(@"error was: %@", [self.responseUtils errorMessageForFailedRequest:aRequest]);
  }
  [self postRequestDidFinishNotification];
}

- (void) handleWeatherRequestDidFinish:(ASIHTTPRequest *) aRequest {
  DDLogDebug(@"handling weather request did finish"); 
  if (![self.responseUtils requestWas200or201Successful:aRequest]) {
    DDLogError(@"request finished but was not 200 or 201 successful: %@", 
               [self.responseUtils responseDescriptionForRequest:aRequest]);
  } else {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *dict = [parser objectWithString:aRequest.responseString error:&error];
    if (error != nil) {
      DDLogError(@"could not parse response error: %@ : %@", error, aRequest.responseString);
    } else {
      //{ "data": { "error": [ {"msg": "User account does not exist. Please go to http:\/\/www.worldweatheronline.com\/register.aspx and register for an API Key or contact support team at info@worldweatheronline.com" } ] }}
      //{ "data": { "request": [ {"query": "Lat 23.00 and Lon 500.00", "type": "LatLon" } ] }}
      if (![LjsValidator dictionary:dict containsKey:LjsCurrentWeatherDataKey]) {
        DDLogError(@"expected dictionary to contain key: %@ : %@", LjsCurrentWeatherDataKey, dict);
      } else {
        NSDictionary *inner = [dict objectForKey:LjsCurrentWeatherDataKey];
        
        DDLogDebug(@"inner = %@", inner);
        if ([LjsValidator dictionary:inner containsKey:LjsCurrentWeatherErrorKey]) {
          DDLogError(@"found error in dict: %@ : %@", [inner objectForKey:LjsCurrentWeatherErrorKey], inner);
        } else if (![LjsValidator dictionary:inner containsKey:LjsCurrentWeatherCurrentConditionKey]) {
          DDLogError(@"expected %@ in %@", LjsCurrentWeatherCurrentConditionKey, inner);
        } else {
          NSArray *array = [inner objectForKey:LjsCurrentWeatherCurrentConditionKey];
          self.currentConditions = [array objectAtIndex:0];
        
        }
      }
    }
  }
  [self postRequestDidFinishNotification];
}

- (void) postRequestDidFinishNotification {
  [[NSNotificationCenter defaultCenter]
   postNotificationName:LjsCurrentWeatherRequestDidFinishNotification object:self];
}

- (BOOL) weatherAvailable {
  return self.currentConditions != nil;
}

- (NSInteger) cloudCover {
  NSInteger result = LjsCurrentWeatherNotFoundInteger;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherCloudCoverKey];
  if (value != nil) {
    result = [value integerValue];
  }
  return result;
}

- (NSInteger ) humidity {
  NSInteger result = LjsCurrentWeatherNotFoundInteger;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherHumidtyKey];
  if (value != nil) {
    result = [value integerValue];
  }
  return result;  
}

- (NSString *) observationTime {
  return [self.currentConditions objectForKey:LjsCurrentWeatherHumidtyKey];
}

- (CGFloat) precipitationMM {
  CGFloat result = LjsCurrentWeatherNotFoundFloat;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherPrecipMMKey];
  if (value != nil) {
    result = [value doubleValue];
  }
  return result;  
}

- (NSInteger) pressure {
  NSInteger result = LjsCurrentWeatherNotFoundInteger;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherPressureKey];
  if (value != nil) {
    result = [value integerValue];
  }
  return result;  
}

- (NSInteger) temperatureC {
  NSInteger result = LjsCurrentWeatherNotFoundInteger;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherTempCKey];
  if (value != nil) {
    result = [value integerValue];
  }
  return result;  
}

- (NSInteger) temperatureF {
  NSInteger result = LjsCurrentWeatherNotFoundInteger;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherTempFKey];
  if (value != nil) {
    result = [value integerValue];
  }
  return result;  
}

- (NSInteger) visibility {
  NSInteger result = LjsCurrentWeatherNotFoundInteger;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherVisibilityKey];
  if (value != nil) {
    result = [value integerValue];
  }
  return result;  
}

- (NSInteger) weatherCode {
  NSInteger result = LjsCurrentWeatherNotFoundInteger;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherCodeKey];
  if (value != nil) {
    result = [value integerValue];
  }
  return result;  
}

- (NSString *) weatherDescription {
  NSArray *array = [self.currentConditions objectForKey:LjsCurrentWeatherDescriptionKey];
  NSDictionary *dict = [array objectAtIndex:0];
  return [dict objectForKey:LjsCurrentWeatherValueKey];
}

- (NSURL *) weatherIconURL {
  NSURL *result = nil;
  NSArray *array = [self.currentConditions objectForKey:LjsCurrentWeatherIconURLKey];
  if (array != nil && [array count] != 0) {
    NSDictionary *dict = [array objectAtIndex:0];
    if (dict != nil && [dict count] != 0) {
      NSString *path = [dict objectForKey:LjsCurrentWeatherValueKey];
      NSString *escaped = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      result = [NSURL URLWithString:escaped];
    }
  }
  return result;
}

- (NSString *) windDirection16Point {
  return [self.currentConditions objectForKey:LjsCurrentWeatherWind16pointKey];
}
- (NSInteger) windDirectionDegree {
  NSInteger result = LjsCurrentWeatherNotFoundInteger;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherWindDegreeKey];
  if (value != nil) {
    result = [value integerValue];
  }
  return result;  
}

- (NSInteger) windSpeedKmph {
  NSInteger result = LjsCurrentWeatherNotFoundInteger;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherWindKmphKey];
  if (value != nil) {
    result = [value integerValue];
  }
  return result;  
}

- (NSInteger) windSpeedMph {
  NSInteger result = LjsCurrentWeatherNotFoundInteger;
  NSString *value = [self.currentConditions objectForKey:LjsCurrentWeatherWindMphKey];
  if (value != nil) {
    result = [value integerValue];
  }
  return result;  
}


- (NSString *) briefDescription {
  NSString *result = nil;
  if ([self weatherAvailable]) {
    result = [NSString stringWithFormat:@"%@ T:%ld/%ld W:%@ %ld/%ld Precip:%.2fmm",
              [self weatherDescription], 
              (long)[self temperatureC],
              (long)[self temperatureF],
              [self windDirection16Point],
              (long)[self windSpeedKmph],
              (long)[self windSpeedMph],
              [self precipitationMM]];
  }
  return result;
}

#pragma mark DEAD SEA
//- (void) handleCurrentWeatherNotification:(NSNotification *) aNote {
//  DDLogDebug(@"handling current weather notification");
//  DDLogDebug(@"found conditions: %@", self.currentWeather.currentConditions);
//  
//  DDLogDebug(@"available %d", [self.currentWeather weatherAvailable]);
//  DDLogDebug(@"cloud cover %d", [self.currentWeather cloudCover]);
//  DDLogDebug(@"humidty %d", [self.currentWeather humidity]);
//  DDLogDebug(@"time %@", [self.currentWeather observationTime]);
//  DDLogDebug(@"precip %f", [self.currentWeather precipitationMM]);
//  DDLogDebug(@"pressure %d", [self.currentWeather pressure]);
//  DDLogDebug(@"temp C %d", [self.currentWeather temperatureC]);
//  DDLogDebug(@"temp F %d", [self.currentWeather temperatureF]);
//  DDLogDebug(@"vis %d", [self.currentWeather visibility]);
//  DDLogDebug(@"code %d", [self.currentWeather weatherCode]);
//  DDLogDebug(@"descript %@", [self.currentWeather  weatherDescription]);
//  DDLogDebug(@"icon %@", [self.currentWeather  weatherIconURL]);
//  DDLogDebug(@"wind 16 point %@", [self.currentWeather   windDirection16Point]);
//  DDLogDebug(@"wind degree %d", [self.currentWeather windDirectionDegree]);
//  DDLogDebug(@"wind kph %d", [self.currentWeather windSpeedKmph]);
//  DDLogDebug(@"wind mph %d", [self.currentWeather windSpeedMph]);
//  
//}


@end
