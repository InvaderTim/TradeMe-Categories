//
//  Listing.h
//  TradeMe
//
//  Created by Timothy Robb on 21/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

@interface Listing : NSObject <EntityNetworking>

@property (nonatomic, assign) NSInteger backendID;

@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *title;

@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL hasPayNow;

@property (nonatomic, retain) NSString *bidPrice;
@property (nonatomic, retain) NSString *buyNowPrice;

@property (nonatomic, assign) NSInteger timeLeftInt;
@property (nonatomic, retain) NSString *timeLeft;
@property (nonatomic, retain) NSString *totalBids;
@property (nonatomic, retain) NSString *location;

@end
