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
		self.name = [data[@"Name"] capitalizedString];
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
	if (data[@"IsRestricted"] && data[@"IsRestricted"] != [NSNull null]) {
		self.isRestricted = [data[@"IsRestricted"] boolValue];
	}
	
	
	if (data[@"Subcategories"] && data[@"Subcategories"] != [NSNull null]) {
		id array = data[@"Subcategories"];
		
		if (array && array != [NSNull null]) {
			for (NSDictionary *subCategoryData in array) {
				if (subCategoryData[@"Number"] && subCategoryData[@"Number"] != [NSNull null]) {
					NSString *uid = subCategoryData[@"Number"];
					
					Category *subcategory = nil;
					for (Category *potentialSubcategory in self.subCategories) {
						if ([potentialSubcategory.uid isEqualToString:uid]) {
							subcategory = potentialSubcategory;
						}
					}
					if (!subcategory) {
						subcategory = [Category createInstance];
					}
					
					[self addSubCategoriesObject:subcategory];
					subcategory.parentCategory = self;
					subcategory.depth = self.depth + 1;
					[subcategory setWithNetworkingData:subCategoryData];
				}
			}
		}
	}
}

@end
