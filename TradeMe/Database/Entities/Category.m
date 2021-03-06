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

@property (nonatomic, retain) NSNumber *orderNumber; // Back-end to depth
@property (nonatomic, retain) NSNumber *depthNumber; // Back-end to depth
@property (nonatomic, retain) NSNumber *itemCountNumber; // Back-end to itemCount
@property (nonatomic, retain) NSNumber *hasClassifiedsNumber; // Back-end to hasClassifieds

@property (nonatomic, retain) NSNumber *isRestrictedNumber; // Back-end to isRestricted

@end

#pragma mark - Main Implementation

@implementation Category

@dynamic name;
@dynamic urlPath;
@dynamic uid;

@dynamic order, orderNumber;
@dynamic depth, depthNumber;
@dynamic itemCount, itemCountNumber;
@dynamic hasClassifieds, hasClassifiedsNumber;
@dynamic isRestricted, isRestrictedNumber;

@dynamic subCategories;
@dynamic parentCategory;

#pragma mark - Initialisation

+(Category*)createInstance {
	Category *category = (Category*)[NSEntityDescription insertNewObjectForEntityForName:@"Category"
																  inManagedObjectContext:DATABASE_MANAGER.mainContext];
	return category;
}

#pragma mark - Retrieval

+(id)getCategoryWithUID:(NSString*)uid {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category"
											  inManagedObjectContext:DATABASE_MANAGER.mainContext];
	
	[request setEntity:entity];
	[request setPredicate:[NSPredicate predicateWithFormat:@"uid == %@",uid]];
	[request setFetchBatchSize:1];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[DATABASE_MANAGER.mainContext executeFetchRequest:request
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

+(NSMutableArray*)getAll {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category"
											  inManagedObjectContext:DATABASE_MANAGER.mainContext];
	
	[request setEntity:entity];
	[request setPredicate:[NSPredicate predicateWithFormat:@"depthNumber == 0"]];
	[request setFetchBatchSize:1];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[DATABASE_MANAGER.mainContext executeFetchRequest:request
																								error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	
	NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
	[mutableFetchResults sortUsingDescriptors:@[sorter]];
	
	return mutableFetchResults;
}

#pragma mark - Setters

-(void)setOrder:(NSInteger)order {
	self.orderNumber = @(order);
}

-(void)setDepth:(NSInteger)depth {
	self.depthNumber = @(depth);
}

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

-(NSInteger)order {
	return [self.orderNumber integerValue];
}

-(NSInteger)depth {
	return [self.depthNumber integerValue];
}

-(NSInteger)itemCount {
	return [self.itemCountNumber integerValue];
}

-(BOOL)hasClassifieds {
	return [self.hasClassifiedsNumber boolValue];
}

-(BOOL)isRestricted {
	return [self.isRestrictedNumber boolValue];
}

-(NSArray *)getOrderedSubCategories {
	NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
	NSArray *orderedCategories = [self.subCategories sortedArrayUsingDescriptors:@[sorter]];
	return orderedCategories;
}

@end
