
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "DataFetcher.h"


@interface DataFetcher ()

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (NSString *)applicationDocumentsDirectory;

@end

@implementation DataFetcher
@synthesize persistentStoreCoordinator;

+ (instancetype)sharedInstance
{
	static id master = nil;
	
	@synchronized(self)
	{
		if (master == nil)
			master = [self new];
	}
    
    return master;
}


- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate sortField:(NSString*)fieldName {
    return [self fetchedResultsControllerForEntity:entityName withPredicate:predicate sortField:fieldName inContext:self.managedObjectContext];
}

- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate sortField:(NSString*)fieldName inContext:(NSManagedObjectContext *)context {
    NSFetchedResultsController *fetchedResultsController;
    
    /*
	 Set up the fetched results controller.
     */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
    // Add a predicate if we're filtering
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
	
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	
	return [fetchedResultsController autorelease];
}


- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate sortField:(NSString*)fieldName sectionNameKeyPath:(NSString*)keyPath {
    return [self fetchedResultsControllerForEntity:entityName withPredicate:predicate sortField:fieldName sectionNameKeyPath:keyPath inContext:self.managedObjectContext];
}

- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate sortField:(NSString*)fieldName sectionNameKeyPath:(NSString*)keyPath inContext:(NSManagedObjectContext *)context {
    NSFetchedResultsController *fetchedResultsController;
    
    /*
	 Set up the fetched results controller.
     */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
    NSSortDescriptor *primarySortKeyDescriptor = [[NSSortDescriptor alloc] initWithKey:keyPath ascending:YES];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:primarySortKeyDescriptor,sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
    
    // Add a predicate
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
    
	fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:keyPath cacheName:nil];
	
	[fetchRequest release];
	[primarySortKeyDescriptor release];
	[sortDescriptor release];
	[sortDescriptors release];
	
	return [fetchedResultsController autorelease];
}


- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate {
    return [self fetchManagedObjectsForEntity:entityName withPredicate:predicate inContext:self.managedObjectContext];
}

- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext *)context
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	
	NSFetchRequest	*request = [[NSFetchRequest alloc] init];
	request.entity = entity;
	request.predicate = predicate;
	
	NSArray	*results = [context executeFetchRequest:request error:nil];
	[request release];
	
	return results;
}

- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate withSortField:(NSString*)sortField {
    return [self fetchManagedObjectsForEntity:entityName withPredicate:predicate withSortField:sortField inContext:self.managedObjectContext];
}

- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate withSortField:(NSString*)sortField inContext:(NSManagedObjectContext *)context
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	NSFetchRequest	*request = [[NSFetchRequest alloc] init];
	request.entity = entity;
	request.predicate = predicate;
    
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortField ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[request setSortDescriptors:sortDescriptors];
	
	NSArray	*results = [context executeFetchRequest:request error:nil];
	[sortDescriptor release];
	[sortDescriptors release];
	[request release];
	
	return results;
}


#pragma mark -
#pragma mark Core Data stack


- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}



- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    return managedObjectModel;
}

- (NSString *)databasePath
{
	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"temp.sqlite"];
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSString	*path = [self databasePath];
    NSURL *storeUrl = [NSURL fileURLWithPath:path];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
	
    return persistentStoreCoordinator;
}

- (BOOL)databaseExists
{
	NSString	*path = [self databasePath];
	BOOL		databaseExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
	
	return databaseExists;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [super dealloc];
}

@end
