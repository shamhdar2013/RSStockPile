//
//  RSStatsViewController.h
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/7/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RSDetailViewController.h"

@interface RSStatsViewController : RSDetailViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *statsTable;
@property (nonatomic, weak) IBOutlet UILabel *companyName;


@end
