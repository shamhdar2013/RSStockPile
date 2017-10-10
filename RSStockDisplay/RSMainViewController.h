//
//  RSMainViewController.h
//  RSStockDisplay
//
//  Created by RADHIKA SHARMA on 10/8/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface RSMainViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, NSFetchedResultsControllerDelegate>


@property (nonatomic, weak) IBOutlet UITableView *stockTable;
@property (nonatomic, weak) IBOutlet UIView *detailsPageContainer;
@property(nonatomic, strong)  UIPageViewController *stockPageController;
@end

