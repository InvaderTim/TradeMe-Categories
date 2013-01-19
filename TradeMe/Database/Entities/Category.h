//
//  Category.h
//  TradeMe
//
//  Created by Timothy Robb on 19/01/13.
//  Copyright (c) 2013 InvaderTim. All rights reserved.
//

@class Category;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * urlPath;
@property (nonatomic, retain) NSString * uid;

@property NSInteger itemCount; // Front-end to itemCountNumber
@property BOOL hasClassifieds; // Front-end to hasClassifiedsNumber
@property BOOL hasLegalNotice; // Front-end to hasLegalNoticeNumber
@property BOOL isRestricted; // Front-end to isRestrictedNumber

@property (nonatomic, retain) NSString * legalNotice;

@property (nonatomic, retain) NSMutableArray * subCategories;
@property (nonatomic, retain) Category * parentCategory;

+(id)createInstance;
+(id)getCategoryWithUID:(NSString*)uid;

-(void)getLegalNotice;

-(void)addSubCategory:(Category*)category;
-(void)removeSubcategory:(Category*)category;

@end
