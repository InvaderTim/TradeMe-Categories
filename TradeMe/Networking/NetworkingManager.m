//
//  NetworkingManager.m
//  TradeMe
//
//  Created by Timothy Robb on 20/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import "NetworkingManager.h"
#import "TradeMeClient.h"

@implementation NetworkingManager

static NetworkingManager *instance;

+ (NetworkingManager *) getInstance {
	@synchronized(self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
	}
	
	return instance;
}

- (id)init{
    if (self = [super init]) {
        // Something!
    }
    return self;
}

- (void)startSync {
	[[TradeMeClient getInstance] getPath:@"Categories.json"
							  parameters:nil
								 success:^(AFHTTPRequestOperation *operation, id responseObject) {
									 if (responseObject && ![responseObject isEqual:[NSNull null]]) {
										 id categories = responseObject[@"Subcategories"];
										 
										 if (categories && categories != [NSNull null]) {
											 for (NSDictionary *categoryData in categories) {
												 if (categoryData[@"Number"] && categoryData[@"Number"] != [NSNull null]) {
													 NSString *uid = categoryData[@"Number"];
													 
													 Category *category = [Category getCategoryWithUID:uid];
													 if (!category) {
														 category = [Category createInstance];
														 [DATABASE_MANAGER saveContext];
													 }
													 
													 category.depth = 0;
													 [category setWithNetworkingData:categoryData];
												 }
											 }
										 }
									 }
									 [DATABASE_MANAGER saveContext];
								 }
								 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
									
								 }];
}

@end
