//
//  RSStockDataProvider.h
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^GraphResult)(NSArray *dataPoints, NSError *error);

@interface RSStockDataProvider : NSObject

+(RSStockDataProvider *)sharedInstance;
-(void)start;
-(void)chartDataForSymbol:(NSString *)symbol withCompletionBlock:(GraphResult)graphBlock;

@end
