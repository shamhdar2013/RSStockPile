//
//  RSStockDataProvider.h
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^GraphResult)(NSArray *dataPoints, NSError *error);
typedef void (^NewsResult)(NSArray *newsItems, NSError *error);

@interface RSStockDataProvider : NSObject

+(RSStockDataProvider *)sharedInstance;
-(void)start;
-(void)chartDataForSymbol:(NSString *)symbol withCompletionBlock:(GraphResult)graphBlock;
-(void)newsDataForSymbol:(NSString *)symbol withCompletionBlock:(NewsResult)newsBlock;

@end
