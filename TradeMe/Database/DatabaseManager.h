//
//  CoreData.h
//
//  Created by Timothy Robb on 16/06/12.
//  Copyright (c) 2012 Timothy Robb. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATABASE_MANAGER [DatabaseManager getInstance]

@interface DatabaseManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DatabaseManager *)getInstance;

- (void)saveMainContext;
- (void)saveBackgroundContext;
- (NSURL *)applicationDocumentsDirectory;

@end
