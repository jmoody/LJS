//
//  main.m
//  Test-LumberjackHTTPLogging
//
//  Created by Joshua Moody on 10/21/11.
//  Copyright (c) 2011 Little Joy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LJSAppDelegate.h"

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  int retVal =  UIApplicationMain(argc, argv, nil, NSStringFromClass([LJSAppDelegate class]));
  [pool release];
  return retVal;
}
