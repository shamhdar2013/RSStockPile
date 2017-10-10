//
//  RSGraphViewController.m
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/7/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSGraphViewController.h"
#import "RSStockDataProvider.h"
#import "RSStockEntity.h"

@interface RSGraphViewController ()
@property (nonatomic, strong) RSStockEntity *chartEntity;
@end

@implementation RSGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setStockEntity:(RSStockEntity *)stockEntity{
    if(graph){
        [graph removeFromSuperview];
    }
    if(stockEntity) {
      
        self.chartEntity = stockEntity;
        self.statSymbol = stockEntity.symbol;
        __weak typeof(self) weakSelf = self;
        [[RSStockDataProvider sharedInstance] chartDataForSymbol:self.statSymbol withCompletionBlock:^(NSArray *data, NSError *err){
            
            if(!err){
                dispatch_async(dispatch_get_main_queue(), ^ {
                    graph = [MPPlot plotWithType:MPPlotTypeGraph frame:CGRectMake(0, 30, self.view.width, 150)];
                    
                    graph.waitToUpdate = YES;
                    graph.values = data;
                    
                    graph.graphColor = [UIColor redColor];
                    graph.curved = YES;
                    
                    
                    [weakSelf.view addSubview:graph];
                    [graph animate];
                });
            }
            
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
