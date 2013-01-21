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

- (id)init {
    if (self = [super init]) {
        self.delegates = [NSMutableSet set];
    }
    return self;
}

- (dispatch_queue_t)getBackgroundQueue {
	return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

- (void)notifySyncDelegatesSuccess {
	for (id delegate in self.delegates) {
		if ([delegate respondsToSelector:@selector(syncCompleted)]) {
			[delegate syncCompleted];
		}
	}
}

- (void)notifySearchDelegates:(NSArray*)data {
	for (id delegate in self.delegates) {
		if ([delegate respondsToSelector:@selector(searchCompleted:)]) {
			[delegate searchCompleted:data];
		}
	}
}

#pragma mark - Category synchronization

- (void)startSync {
	__block NSMutableArray *existingCategories = [Category getAll];
	
	[[TradeMeClient getInstance] getPath:@"Categories.json"
							  parameters:nil
								 success:^(AFHTTPRequestOperation *operation, id responseObject) {
									 [DATABASE_MANAGER.backgroundContext performBlock:^{
										[self handleCategories:responseObject exisitingCategories:existingCategories];
									 }];
								 }
								 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
									
								 }];
}

- (void)handleCategories:(id)responseObject exisitingCategories:(NSMutableArray*)exisitingCategories {
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
						[exisitingCategories addObject:category];
					}
					
					/* Set category with data recursively */
					category.depth = 0;
					[category setWithNetworkingData:categoryData];
				}
			}
		}
	}
	
	[DATABASE_MANAGER.mainContext performBlock:^{
		[self notifySyncDelegatesSuccess];
	}];
}

@end
