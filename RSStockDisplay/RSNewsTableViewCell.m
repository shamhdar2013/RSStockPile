//
//  RSNewsTableViewCell.m
//  RSStockDisplay
//
//  Created by RADHIKA SHARMA on 10/22/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSNewsTableViewCell.h"

@implementation RSNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.newsHeadline.numberOfLines = 2;
    self.newsDetail.numberOfLines = 4;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
