//
//  LJSAppDelegate.h
//  Test-LumberjackHTTPLogging
//
//  Created by Joshua Moody on 10/21/11.
//  Copyright (c) 2011 Little Joy Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LjsHttpLogManager.h"
#import "LjsRepeatingTimerProtocol.h"

@class LJSViewController;

@interface LJSAppDelegate : UIResponder <UIApplicationDelegate, LjsRepeatingTimerProtocol>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) LJSViewController *viewController;
@property (nonatomic, strong) LjsHttpLogManager *httpLogManager;
@property (nonatomic, strong) NSTimer *logTimer;

- (void) handleLogTimerEvent:(NSTimer *) aTimer;

@end
