//
//  RSGraphViewController.h
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/7/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RSDetailViewController.h"
#import "MPGraphView.h"

@interface RSGraphViewController : RSDetailViewController{
    MPGraphView *graph;
}

@end
