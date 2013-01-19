//
//  TradeMeClient.h
//  TradeMe
//
//  Created by Timothy Robb on 20/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface TradeMeClient : AFHTTPClient

+ (TradeMeClient *)getInstance;

@end
