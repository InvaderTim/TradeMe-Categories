//
//  Category+Networking.m
//
//  Created by Timothy Robb on 4/12/12.
//  Copyright (c) 2012 Timothy Robb. All rights reserved.
//

#import "Category+Networking.h"

@implementation Category (Networking)

-(NSDictionary *)getNetworkingData {
	// Categories are not uploaded
	return @{};
}

-(void)setWithNetworkingData:(NSDictionary *)data {
	if (data[@"Name"] && data[@"Name"] != [NSNull null]) {
		self.name = data[@"Name"];
	}
	if (data[@"Path"] && data[@"Path"] != [NSNull null]) {
		self.urlPath = data[@"Path"];
	}
	if (data[@"Number"] && data[@"Number"] != [NSNull null]) {
		self.uid = data[@"Number"];
	}
	
	
	if (data[@"Count"] && data[@"Count"] != [NSNull null]) {
		self.itemCount = [data[@"Count"] intValue];
	}
	if (data[@"HasClassifieds"] && data[@"HasClassifieds"] != [NSNull null]) {
		self.hasClassifieds = [data[@"HasClassifieds"] boolValue];
	}
	if (data[@"HasLegalNotice"] && data[@"HasLegalNotice"] != [NSNull null]) {
		self.hasLegalNotice = [data[@"HasLegalNotice"] boolValue];
	}
	if (data[@"IsRestricted"] && data[@"IsRestricted"] != [NSNull null]) {
		self.isRestricted = [data[@"IsRestricted"] boolValue];
	}
	
	
	if (data[@"Subcategories"] && data[@"Subcategories"] != [NSNull null]) {
		id array = data[@"Subcategories"];
		
		if (array && array != [NSNull null]) {
			for (NSDictionary *subCategoryData in array) {
				if (data[@"Number"] && data[@"Number"] != [NSNull null]) {
					NSString *uid = data[@"Number"];
					
					Category *subcategory = [Category getCategoryWithUID:uid];
					if (!subcategory) {
						subcategory = [Category createInstance];
						[DATABASE_MANAGER saveContext];
					}
					
					subcategory.parentCategory = self;
					[subcategory setWithNetworkingData:subCategoryData];
				}
			}
		}
	}
}

@end