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
	__block NSArray *existingCategories = [Category getAll];
	
	[[TradeMeClient getInstance] getPath:@"Categories.json"
							  parameters:nil
								 success:^(AFHTTPRequestOperation *operation, id responseObject) {
									[self handleCategories:responseObject exisitingCategories:existingCategories];
								 }
								 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
									
								 }];
	
	[DATABASE_MANAGER saveContext];
}

- (void)handleCategories:(id)responseObject exisitingCategories:(NSArray*)exisitingCategories {
	if (responseObject && ![responseObject isEqual:[NSNull null]]) {
		id categories = responseObject[@"Subcategories"];
		
		if (categories && categories != [NSNull null]) {
			for (NSDictionary *categoryData in categories) {
				if (categoryData[@"Number"] && categoryData[@"Number"] != [NSNull null]) {
					NSString *uid = categoryData[@"Number"];
					
					/* Capture any exisiting category */
					Category *category = nil;
					for (Category *potentialCategory in exisitingCategories) {
						if ([potentialCategory.uid isEqualToString:uid]) {
							category = potentialCategory;
						}
					}
					if (!category) {
						category = [Category createInstance];
					}
					
					/* Set category with data recursively */
					category.depth = 0;
					[category setWithNetworkingData:categoryData];
				}
			}
		}
	}
}

@end
