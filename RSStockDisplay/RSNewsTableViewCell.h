//
//  RSNewsTableViewCell.h
//  RSStockDisplay
//
//  Created by RADHIKA SHARMA on 10/22/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSNewsTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *newsHeadline;
@property (nonatomic, weak) IBOutlet UILabel *newsDetail;

@end
