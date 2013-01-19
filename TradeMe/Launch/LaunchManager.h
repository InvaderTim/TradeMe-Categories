//
//  LaunchManager.h
//  TradeMe
//
//  Created by Timothy Robb on 20/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#define LAUNCH_MANAGER [LaunchManager getInstance]

@interface LaunchManager : NSObject

+(LaunchManager *)getInstance;

-(void)preload;
-(id)getLaunchController;

@end
