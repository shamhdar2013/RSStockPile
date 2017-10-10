//
//  RSCoreDataController.m
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/7/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSCoreDataController.h"
#import "RSStockEntity.h"

@interface RSCoreDataController ()
@property (strong, nonatomic, readwrite) NSPersistentContainer *persistentContainer;
@end

@implementation RSCoreDataController

+(RSCoreDataController *)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RSCoreDataController alloc] init];
    });
    
    return sharedInstance;

}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"RSStockDisplay"];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *basePath = [paths objectAtIndex:0];
            NSURL *dbURL = [NSURL fileURLWithPath:[basePath stringByAppendingPathComponent:@"RSStockPile.sqlite"] isDirectory:NO];
            NSPersistentStoreDescription   *descp = [NSPersistentStoreDescription  persistentStoreDescriptionWithURL:dbURL];
            
            descp.type = NSSQLiteStoreType;
            descp.shouldInferMappingModelAutomatically = TRUE;
            descp.shouldMigrateStoreAutomatically = TRUE;
            _persistentContainer.persistentStoreDescriptions = @[descp];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    //abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
       // abort();
    }
}

-(void)addEntitiesToStore:(NSArray *)jsonArray {
    if(jsonArray.count>0){
        
        
        NSManagedObjectContext *moc = self.persistentContainer.viewContext; //Primary context on the main queue
        
        NSManagedObjectContext *private = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [private setParentContext:moc];
        
        //__weak typeof(self) weakSelf = self;
        [private performBlock:^{
            for (NSDictionary *jsonObject in jsonArray) {
                NSString *stockSymbol = [jsonObject objectForKey:@"symbol"];
                NSError *Fetcherror;
                NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"RSStockEntity"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol == %@", stockSymbol];
                [fetch setPredicate:predicate];
                NSArray *arr = [private executeFetchRequest:fetch error:&Fetcherror];
                
                if(arr && arr.count > 0){
                    for (NSManagedObject *managedObject in arr) {
                        [private deleteObject:managedObject];
                    }
                }
                
                    RSStockEntity *mo = [NSEntityDescription insertNewObjectForEntityForName:@"RSStockEntity" inManagedObjectContext:private];
                    
                    mo.symbol = [jsonObject objectForKey:@"symbol"];
                    mo.companyName = (NSString *)[jsonObject objectForKey:@"companyName"];
                    mo.currentPrice = [jsonObject objectForKey:@"currentPrice"];
                    mo.closePrice = [jsonObject objectForKey:@"closePrice"];
                    mo.openPrice = [jsonObject objectForKey:@"openPrice"];
                    mo.marketCap = [jsonObject objectForKey:@"marketCap"];
                    mo.primaryExchange = [jsonObject objectForKey:@"primaryExchange"];
                    mo.w52High = [jsonObject objectForKey:@"w52High"];
                    mo.w52Low = [jsonObject objectForKey:@"w52Low"];
                    mo.changePercent = [jsonObject objectForKey:@"changePercent"];
                    mo.peRatio = [jsonObject objectForKey:@"peRatio"];                }
                
                
        
            NSError *error = nil;
            if (![private save:&error]) {
                NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                //abort();
            }
            [moc performBlockAndWait:^{
                NSError *error = nil;
                if (![moc save:&error]) {
                    NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                    //abort();
                }
            }];
        }];
    }

}

-(void)removeEntityWithSymbol:(NSString *)symbol
{
    NSManagedObjectContext *moc = self.persistentContainer.viewContext; //Primary context on the main queue
    
    NSManagedObjectContext *private = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [private setParentContext:moc];
    
    //__weak typeof(self) weakSelf = self;
    [private performBlock:^{
        NSError *Fetcherror;
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"RSStockEntity"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol == %@", symbol];
        [fetch setPredicate:predicate];
        NSArray *arr = [private executeFetchRequest:fetch error:&Fetcherror];
        
        if(arr && arr.count > 0){
            for (NSManagedObject *managedObject in arr) {
                [private deleteObject:managedObject];
            }
        }
        
        NSError *error = nil;
        if (![private save:&error]) {
            NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
            //abort();
        }
        
        [moc performBlockAndWait:^{
            NSError *error = nil;
            if (![moc save:&error]) {
                NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                //abort();
            }
        }];

    }];
}

-(RSStockEntity *)getEntityWithSymbol:(NSString *)symbol
{
    __block RSStockEntity *mo = nil;
    NSManagedObjectContext *moc = self.persistentContainer.viewContext; //Primary context on the main queue
    
    NSManagedObjectContext *private = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [private setParentContext:moc];
    
    //__weak typeof(self) weakSelf = self;
    [private performBlock:^{
        NSError *Fetcherror;
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"RSStockEntity"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbol == %@", symbol];
        [fetch setPredicate:predicate];
        NSArray *arr = [private executeFetchRequest:fetch error:&Fetcherror];
        
        if(arr && arr.count > 0){
            mo = arr[0];
        }
    }];
    
    return mo;
}
@end
