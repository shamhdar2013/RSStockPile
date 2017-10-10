//
//  RSStockEntity.h
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/7/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface RSStockEntity : NSManagedObject
@property (nonatomic, strong) NSNumber *changePercent;
@property (nonatomic, strong) NSNumber *openPrice;
@property (nonatomic, strong) NSNumber *closePrice;
@property (nonatomic, strong) NSNumber *currentPrice;
@property (nonatomic, strong) NSNumber*w52High;

@property (nonatomic, strong) NSNumber *w52Low;
@property (nonatomic, strong) NSNumber *peRatio;

@property (nonatomic, strong) NSNumber *marketCap;

@property (nonatomic, strong) NSString *primaryExchange;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *companyName;


@end
