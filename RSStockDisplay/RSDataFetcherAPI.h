//
//  RSDataFetcherAPI.h
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kStockAPIUrl;
typedef void (^QuotesBlock)(NSDictionary *results, NSError *error);
typedef void (^NewsBlock)(NSDictionary *results, NSError *error);
typedef void (^ChartBlock)(NSDictionary *results, NSError *error);

typedef enum {
    kDay,
    kMonth,
    kYear
} RangeType;

@interface RSDataFetcherAPI : NSObject

+(void)getStockQuotesForSymbols:(NSArray *)symbols forRange:(RangeType)range withCompletionBlock:(QuotesBlock)quotesBlock;
+(void)getStockNewsForSymbols:(NSArray *)symbols forRange:(RangeType)range withCompletionBlock:(NewsBlock)newsBlock;

+(void)getStockChartForSymbols:(NSArray *)symbols forRange:(RangeType)range withCompletionBlock:(ChartBlock)chartBlock;




@end
