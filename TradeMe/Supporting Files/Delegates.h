//
//  Delegates.h
//  TradeMe
//
//  Created by Timothy Robb on 20/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#ifndef TradeMe_Delegates_h
#define TradeMe_Delegates_h

@protocol NetworkingDelegate <NSObject>

@optional

- (void)syncCompleted;
- (void)searchCompleted:(NSArray*)results;

@end

#endif
