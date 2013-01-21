//
//  CoreData.m
//
//  Created by Timothy Robb on 16/06/12.
//  Copyright (c) 2012 Timothy Robb. All rights reserved.
//

#import "DatabaseManager.h"

#define DATABASE_NAME @"TradeMe"

@implementation DatabaseManager

@synthesize mainContext = __mainContext;
@synthesize backgroundContext = __backgroundContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

static DatabaseManager *instance;

+ (DatabaseManager *) getInstance { 
	@synchronized(self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
	}
	
	return instance;
}

#pragma mark - Error Handling

- (void)handleError:(NSError*)error {
	// Handle Errors in a detailed fashion
	NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
	NSArray* detailedErrors = [error userInfo][NSDetailedErrorsKey];
	if(detailedErrors != nil && [detailedErrors count] > 0) {
		for(NSError* detailedError in detailedErrors) {
			NSLog(@"  DetailedError: %@", [detailedError userInfo]);
		}
	}
	else {
		NSLog(@"  %@", [error userInfo]);
	}
	abort();
}

#pragma mark - Core Data stack

- (void)saveMainContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.mainContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			[self handleError:error];
        }
    }
}

- (void)saveBackgroundContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			[self handleError:error];
        }
    }
}

- (NSManagedObjectContext *)mainContext {
    if (__mainContext != nil) {
        return __mainContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [__mainContext setPersistentStoreCoordinator:coordinator];
    }
    return __mainContext;
}

- (NSManagedObjectContext *)backgroundContext {
    if (__backgroundContext != nil) {
        return __backgroundContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [__backgroundContext setParentContext:self.mainContext];
    }
    return __backgroundContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DATABASE_NAME withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
	NSString *storeString = [DATABASE_NAME stringByAppendingString:@".sqlite"];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeString];
    
    NSError *error = nil;
	NSDictionary *options = nil;
	// Perform automatic lightweight migrations
    options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, 
                            NSInferMappingModelAutomaticallyOption: @YES};
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
		[self handleError:error];
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's documents directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
