//
//  LjsGoogleMacOSAppDelegate.h
//  Test-Google-MacOS
//
//  Created by Joshua Moody on 3/22/12.
//  Copyright (c) 2012 Little Joy Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LjsGoogleMacOSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
