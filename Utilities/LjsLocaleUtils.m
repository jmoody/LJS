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

#import "LjsLocaleUtils.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsLocaleUtils

+ (BOOL) currentLocaleUsesMetricSystem {
  NSLocale *current = [NSLocale currentLocale];
  return [[current objectForKey:NSLocaleUsesMetricSystem] boolValue];
}

+ (NSString *) groupSepForCurrentLocale {
  return [LjsLocaleUtils groupSepForLocale:[NSLocale currentLocale]];
}

+ (NSString *) groupSepForLocale:(NSLocale *) aLocale {
  return [aLocale objectForKey:NSLocaleGroupingSeparator];
}

+ (NSString *) decimalSepForCurrentLocale {
  return [LjsLocaleUtils decimalSepForLocale:[NSLocale currentLocale]];
}

+ (NSString *) decimalSepForLocale:(NSLocale *) aLocale {
  return [aLocale objectForKey:NSLocaleDecimalSeparator];
}


+ (NSNumberFormatter *) numberFormatterForCurrentLocale {
  return [LjsLocaleUtils numberFormatterWithLocale:[NSLocale currentLocale]];
}

+ (NSNumberFormatter *) numberFormatterWithLocale:(NSLocale *) aLocale {
  NSString *groupSep = [LjsLocaleUtils groupSepForLocale:aLocale];
  NSString *decimalSep = [LjsLocaleUtils decimalSepForLocale:aLocale];
  return [LjsLocaleUtils numberFormatterWithGroupingSep:groupSep
                                             demicalSep:decimalSep];
}


+ (NSNumberFormatter *) numberFormatterWithGroupingSep:(NSString *) groupingSep
                                            demicalSep:(NSString *) decimalSep {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  
  [formatter setGroupingSeparator:groupingSep];
  [formatter setGroupingSize:3];
  [formatter setUsesGroupingSeparator:YES];
  
  [formatter setDecimalSeparator:decimalSep];
  [formatter setAlwaysShowsDecimalSeparator:YES];
  
  [formatter setMinimumFractionDigits:2];
  [formatter setMaximumFractionDigits:2];
  [formatter setRoundingMode:NSNumberFormatterRoundFloor];
  return formatter;
}

+ (NSLocale *) localeWith12hourClock {
  return  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

}

+ (NSLocale *) localeWith24hourClock {
  return  [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
}


@end
