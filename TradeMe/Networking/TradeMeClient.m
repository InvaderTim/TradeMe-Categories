//
//  TradeMeClient.m
//  TradeMe
//
//  Created by Timothy Robb on 20/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import "TradeMeClient.h"

@implementation TradeMeClient

static TradeMeClient *instance;

+ (TradeMeClient *) getInstance {
	@synchronized(self) {
		if (instance == nil) {
			instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.trademe.co.nz/v1/"]];
		}
	}
	
	return instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
		
		// Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
		[self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

@end
