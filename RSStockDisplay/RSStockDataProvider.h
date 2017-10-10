//
//  RSStockDataProvider.h
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSStockDataProvider : NSObject

+(RSStockDataProvider *)sharedInstance;
-(void)start;


@end
