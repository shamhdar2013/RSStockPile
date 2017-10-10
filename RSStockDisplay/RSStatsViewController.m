//
//  RSStatsViewController.m
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/7/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSStatsViewController.h"

@interface RSStatsViewController ()

@end

@implementation RSStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"RSStatsTableViewCell" bundle:nil];
    [self.statsTable registerNib:cellNib forCellReuseIdentifier:@"statsCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
