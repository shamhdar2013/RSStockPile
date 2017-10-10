//
//  RSStockTableViewCell.h
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/7/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSStockTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *stockSymbol;
@property (nonatomic, weak) IBOutlet UILabel *stockPrice;
@property (nonatomic, weak) IBOutlet UILabel *changePercent;

@end
