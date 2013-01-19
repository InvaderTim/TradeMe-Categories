//
//  Category.m
//  TradeMe
//
//  Created by Timothy Robb on 19/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

#import "Category.h"

#pragma mark - Private Properties Extension

@interface Category ()

@property (nonatomic, retain) NSNumber *itemCountNumber; // Back-end to itemCount
@property (nonatomic, retain) NSNumber *hasClassifiedsNumber; // Back-end to hasClassifieds
@property (nonatomic, retain) NSNumber *hasLegalNoticeNumber; // Back-end to hasLegaLNotice

@property (nonatomic, retain) NSNumber *isRestrictedNumber; // Back-end to isRestricted

@property (nonatomic, retain) NSSet *subCategoriesSet; // Back-end to subCategories

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addSubCategoriesObject:(Category *)value;
- (void)removeSubCategoriesObject:(Category *)value;
- (void)addSubCategories:(NSSet *)values;
- (void)removeSubCategories:(NSSet *)values;

@end

#pragma mark - Main Implementation

@implementation Category

@dynamic name;
@dynamic urlPath;
@dynamic uid;

@dynamic itemCount, itemCountNumber;
@dynamic hasClassifieds, hasClassifiedsNumber;
@dynamic isRestricted, isRestrictedNumber;

@dynamic hasLegalNotice, hasLegalNoticeNumber;
@dynamic legalNotice;

@synthesize subCategories;
@dynamic subCategoriesSet;
@dynamic parentCategory;

+(NSEntityDescription*)entityDescription {
	return [NSEntityDescription entityForName:@"Category" inManagedObjectContext:DATABASE_MANAGER.managedObjectContext];
}

#pragma mark - Initialisation

+(id)createInstance {
	Category *category = (Category*)[Category entityDescription];
	
	return category;
}

#pragma mark - Retrieval

+(id)getCategoryWithUID:(NSString*)uid {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Category"];
	
	[request setEntity:[Category entityDescription]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"uid == %@",uid]];
	[request setFetchBatchSize:1];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[DATABASE_MANAGER.managedObjectContext executeFetchRequest:request
																								error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	Category *category = nil;
	for (Category *object in mutableFetchResults) {
		category = object;
	}
	
	return category;
}

#pragma mark - Networking

-(void)getLegalNotice {
	if ([self.hasLegalNoticeNumber boolValue]) {
		// TODO: Implement Networking	
	}
}

#pragma mark - Setters

-(void)setItemCount:(NSInteger)itemCount {
	self.itemCountNumber = @(itemCount);
}

-(void)setHasClassifieds:(BOOL)hasClassifieds {
	self.hasClassifiedsNumber = @(hasClassifieds);
}

-(void)setIsRestricted:(BOOL)isRestricted {
	self.isRestrictedNumber = @(isRestricted);
}

#pragma mark - Getters

-(NSInteger)itemCount {
	return [self.itemCountNumber integerValue];
}

-(BOOL)hasClassifieds {
	return [self.hasClassifiedsNumber boolValue];
}

-(BOOL)isRestricted {
	return [self.isRestrictedNumber boolValue];
}

#pragma mark - Subcategory Management

-(void)loadCategories {
	NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES];
	self.subCategories = [self.subCategoriesSet sortedArrayUsingDescriptors:@[sorter]].mutableCopy;
}

-(void)addSubCategory:(Category*)category {
	if (!subCategories) {
		[self loadCategories];
	}
	
	[self.subCategories addObject:category];
	[self addSubCategoriesObject:category];
	
	[DATABASE_MANAGER saveContext];
}

-(void)removeSubcategory:(Category*)category {
	if (!subCategories) {
		[self loadCategories];
	}
	
	[self.subCategories removeObject:category];
	[self removeSubCategoriesObject:category];
	
	[DATABASE_MANAGER saveContext];
}


@end
