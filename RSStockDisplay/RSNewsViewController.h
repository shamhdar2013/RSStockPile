//
//  RSNewsViewController.h
//  RSStockDisplay
//
//  Created by RADHIKA SHARMA on 10/22/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSDetailViewController.h"

@interface RSNewsViewController : RSDetailViewController
@property (nonatomic, weak) IBOutlet UITableView *newsTable;
@end
