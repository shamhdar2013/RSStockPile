//
//  RSDataFetcherAPI.m
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/6/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSDataFetcherAPI.h"

NSString *const kStockAPIUrl = @"https://api.iextrading.com/1.0/stock/market/batch";



//?symbols=aapl,fb&types=quote,news,chart&range=1m&last=5

@interface RSDataFetcherAPI ()
+(NSURL *)getUrlOfType:(NSString *)type forSymbols:(NSArray *)symbols forRange:(RangeType)range;
@end

@implementation RSDataFetcherAPI



+(void)getStockQuotesForSymbols:(NSArray *)symbols forRange:(RangeType)range withCompletionBlock:(QuotesBlock)quotesBlock{
    
    NSURLSession  *session = [NSURLSession sharedSession];
    
    NSURL *url = [RSDataFetcherAPI getUrlOfType:@"quote" forSymbols:symbols forRange:range];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(!error) {
            NSError *jsonError;
            NSDictionary *stocks = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if(quotesBlock){
                quotesBlock(stocks,nil);
                
            }
        }
    }] resume];
}

+(void)getStockNewsForSymbols:(NSArray *)symbols forRange:(RangeType)range withCompletionBlock:(NewsBlock)newsBlock{
    NSURLSession  *session = [NSURLSession sharedSession];
    
    NSURL *url = [RSDataFetcherAPI getUrlOfType:@"news" forSymbols:symbols forRange:range];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(!error) {
            NSError *jsonError;
            NSDictionary *newsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if(newsBlock){
                newsBlock(newsDict,nil);
                
            }

        }
    }] resume];
}

+(void)getStockChartForSymbols:(NSArray *)symbols forRange:(RangeType)range withCompletionBlock:(ChartBlock)chartBlock{
    
    NSURLSession  *session = [NSURLSession sharedSession];
    
    NSURL *url = [RSDataFetcherAPI getUrlOfType:@"chart" forSymbols:symbols forRange:range];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(!error) {
            NSError *jsonError;
            NSDictionary *stocks = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if(chartBlock){
                chartBlock(stocks,nil);
                
            }
        }
    }] resume];
    
}

+(void)getStockChartForSymbol:(NSString *)symbols forRange:(RangeType)range withCompletionBlock:(ChartBlock)chartBlock{
    
}

#pragma mark -internal
+(NSURL *)getUrlOfType:(NSString *)type forSymbols:(NSArray *)symbols forRange:(RangeType)range {
    
    NSURL *stockUrl = nil;
    NSMutableString *symbolsStr = [NSMutableString stringWithCapacity:symbols.count];
    if(!symbols ||!symbols.count){
        
        [symbolsStr appendString:[NSString stringWithFormat:@"?symbols=%@&types=%@", @"AAPL",type]];
    } else {
        
        [symbolsStr appendString:[NSString stringWithFormat:@"?symbols=%@", symbols[0]]];
        
        for(int i = 1; i< symbols.count; i++ ){
            [symbolsStr appendString:[NSString stringWithFormat:@",%@", symbols[i]]];
        }
        [symbolsStr appendString:[NSString stringWithFormat:@"&types=%@",type]];
    }
    switch(range){
        case kDay:
        {
            [symbolsStr appendString:[NSString stringWithFormat:@"&range=1%@",@"d"]];
            break;
        }
        case kMonth:
        {
            [symbolsStr appendString:[NSString stringWithFormat:@"&range=1%@",@"m"]];
            break;
        }
        case kYear:
        {
            [symbolsStr appendString:[NSString stringWithFormat:@"&range=1%@",@"y"]];
            break;
        }
        default:
        {
            [symbolsStr appendString:[NSString stringWithFormat:@"&range=1%@",@"d"]];
            break;
        }
            
    } //end switch
    [symbolsStr appendString:@"&last=10"];
    
    stockUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kStockAPIUrl, symbolsStr]];
    return stockUrl;
}
@end
