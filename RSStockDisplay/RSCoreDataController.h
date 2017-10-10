//
//  RSCoreDataController.h
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/7/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^CallbackBlock)(void);

@interface RSCoreDataController : NSObject
@property (strong, nonatomic, readonly) NSPersistentContainer *persistentContainer;

+(RSCoreDataController *)sharedInstance;

- (void)saveContext;

-(void)addEntitiesToStore:(NSArray *)jsonArray;
-(void)removeEntityWithSymbol:(NSString *)symbol;



@end
