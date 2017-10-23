//
//  RSStockDataProvider.m
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSStockDataProvider.h"
#import "RSDataFetcherAPI.h"
#import "RSCoreDataController.h"

@interface RSStockDataProvider ()
@property (nonatomic, strong) NSArray *stockSymbols; //
@property (nonatomic, copy) NSMutableDictionary *stockData;
@property (nonatomic, copy) NSMutableDictionary *newsData;
@property (nonatomic, copy) NSMutableDictionary *chartData;
@end

@implementation RSStockDataProvider

+(RSStockDataProvider *)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RSStockDataProvider alloc] init];
    });
    
    return sharedInstance;

}

-(void)start{
    self.stockSymbols  =  @[@"AAPL",@"FB",@"SYMC", @"GOOG",@"MSFT"];
    __weak typeof(self) weakSelf = self;
    [RSDataFetcherAPI getStockQuotesForSymbols:self.stockSymbols forRange:kDay withCompletionBlock:^(NSDictionary *result, NSError *error){
        if(!error){
           // NSLog(@" quotes = %@", result);
            [weakSelf parsePriceQuotes:result];
            
        }
        
    }];
    
}

-(void)chartDataForSymbol:(NSString *)symbol withCompletionBlock:(GraphResult)graphBlock{
    NSArray *symbols = @[symbol];
    __weak typeof(self) weakSelf = self;
    [RSDataFetcherAPI getStockChartForSymbols:symbols forRange:kDay withCompletionBlock:^(NSDictionary *result, NSError *error){
        if(!error){
            //NSLog(@" charts = %@", result);
            NSArray *graph = [weakSelf parseChartQuotes:result];
            //NSLog(@" Chart Results = %@", graph);

            if(graphBlock){
                graphBlock(graph, error);
            }
            
        }
        
    }];
}

-(void)newsDataForSymbol:(NSString *)symbol withCompletionBlock:(NewsResult)newsBlock{
    
    NSArray *symbols = @[symbol];
    __weak typeof(self) weakSelf = self;
    [RSDataFetcherAPI getStockNewsForSymbols:symbols forRange:kDay withCompletionBlock:^(NSDictionary *result, NSError *error){
        if(!error){
            NSArray *newsItems = [weakSelf parseNewsItems:result];
            if(newsBlock){
                newsBlock(newsItems, nil);
            }
        }
    }];
    
}

-(NSArray *)parseChartQuotes:(NSDictionary *)dictionary{
    
    NSArray *keys = [dictionary allKeys];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:10];
    for(NSString *key in keys){
        NSArray *charts = [[dictionary objectForKey:key] objectForKey:@"chart"];
        float val = 0.0;
        for(NSDictionary *chart in charts ){
            val = [[chart objectForKey:@"high"] floatValue];
            if(val > 0.0) {
                [results addObject:[chart objectForKey:@"high"]];
            }
        }
    }
    

    return results;
}

-(NSArray *)parseNewsItems:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSArray *results = nil;
    
    for(NSString *key in keys){
        
        NSArray *newsDict = [[dictionary objectForKey:key] objectForKey:@"news"];
        
        results = newsDict;
    }
    return results;
}

-(void) parsePriceQuotes:(NSDictionary *)dictionary {
    
    
    NSArray *keys = [dictionary allKeys];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:keys.count];
    for(NSString *key in keys){
        NSDictionary *quote = [[dictionary objectForKey:key] objectForKey:@"quote"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:11];
        
        [dict setObject:[quote objectForKey:@"companyName"] forKey:@"companyName"];
        [dict setObject:[quote objectForKey:@"changePercent"]  forKey:@"changePercent" ];
        [dict setObject:[quote objectForKey:@"week52Low"] forKey:@"w52Low"];
        [dict setObject:[quote objectForKey:@"week52High"] forKey:@"w52High"];
        [dict setObject:[quote objectForKey:@"open"] forKey:@"openPrice"];
        [dict setObject:[quote objectForKey:@"close"] forKey:@"closePrice"];
        [dict setObject:[quote objectForKey:@"peRatio"] forKey:@"peRatio"];
        [dict setObject:[quote objectForKey:@"primaryExchange"] forKey:@"primaryExchange"];
        [dict setObject:[quote objectForKey:@"symbol"] forKey:@"symbol"];
        [dict setObject:[quote objectForKey:@"marketCap"] forKey:@"marketCap"];
        [dict setObject:[quote objectForKey:@"latestPrice"] forKey:@"currentPrice"];
        
        [results addObject:dict];
    }
    
    [[RSCoreDataController sharedInstance] addEntitiesToStore:results];
    //NSLog(@" results = %@", results);
}


@end
