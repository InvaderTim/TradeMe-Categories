//
//  NetworkingManager.h
//  TradeMe
//
//  Created by Timothy Robb on 20/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#define NETWORKING_MANAGER [NetworkingManager getInstance]

@interface NetworkingManager : NSObject

@property (nonatomic, retain) NSMutableSet *delegates;

+(NetworkingManager *)getInstance;

-(dispatch_queue_t)getBackgroundQueue;
-(void)startSync;

@end
