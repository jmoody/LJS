//
//  LjsGlobals.h
//  ProjectTemplate
//
//  Created by Joshua Moody on 11/10/10.
//  Copyright 2010 The Little Joy Software Company. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *LjsEmptyString;
extern BOOL const LjsTestStringsLowercase;
extern BOOL const LjsTestStringsAsTheyAre;
extern NSInteger const LjsBadIntegerValue;
extern double const LjsBadDoubleValue;

extern NSString *LjsUsingDistributedObjectsServerName;
extern NSString *LjsDistributedNotificationExampleNotificationName;
extern NSString *LjsDistributedNotificationExampleNameOfSender;
extern NSString *LjsDistributedNotificationExampleHelperObjectKey;

extern NSString *Ljs_ISO8601_DateFormatWithMillis;
extern NSString *Ljs_ISO8601_DateFormat;

@interface LjsGlobals : NSObject {

}

@end
