//
//  NetworkingManager.h
//  TradeMe
//
//  Created by Timothy Robb on 20/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#define NETWORKING_MANAGER [NetworkingManager getInstance]

@interface NetworkingManager : NSObject

+(NetworkingManager *)getInstance;

- (void)startSync;

@end
