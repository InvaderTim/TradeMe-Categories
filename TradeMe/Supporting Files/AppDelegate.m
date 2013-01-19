//
//  AppDelegate.m
//  TradeMe
//
//  Created by Timothy Robb on 19/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	[LAUNCH_MANAGER preload];
	
	self.controller = [[UINavigationController alloc] initWithRootViewController:[LAUNCH_MANAGER getLaunchController]];
	self.window.rootViewController = self.controller;
    [self.window makeKeyAndVisible];
	
    return YES;
}

@end
