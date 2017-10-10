//
//  RSDetailViewController.h
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/8/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSStockEntity;

@interface RSDetailViewController : UIViewController
@property (assign) NSUInteger pageIndex;
@property (assign) NSString *statSymbol;
@property (strong) RSStockEntity *stockEntity;

@end
