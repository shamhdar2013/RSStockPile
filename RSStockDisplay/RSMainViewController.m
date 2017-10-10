//
//  RSMainViewController.m
//  RSStockDisplay
//
//  Created by RADHIKA SHARMA on 10/8/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSMainViewController.h"
#import "RSStockDataProvider.h"
#import "RSCoreDataController.h"
#import "RSStockEntity.h"
#import "RSStockTableViewCell.h"
#import "RSDetailViewController.h"

@interface RSMainViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (assign) BOOL userDrivenChange;
@property (nonatomic, strong) NSMutableArray *pageControllers;
@property (assign) NSUInteger selectionIdx;
@property (nonatomic, strong) RSStockEntity *currentEntity;
@end

@implementation RSMainViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    [[RSStockDataProvider sharedInstance] start];
    self.userDrivenChange = NO;
    [self initializeFetchedResultsController];
    self.pageControllers = [NSMutableArray arrayWithCapacity:2];
    self.selectionIdx = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"RSStockTableViewCell" bundle:nil];
    [self.stockTable registerNib:cellNib forCellReuseIdentifier:@"stock"];
    self.stockTable.backgroundColor = [UIColor blackColor];
    self.detailsPageContainer.backgroundColor = [UIColor blackColor];
    
    //Adding Details View
    self.stockPageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.stockPageController.dataSource = self;
    [[self.stockPageController view] setFrame:[self.detailsPageContainer bounds]];
    
    RSDetailViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.stockPageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.stockPageController];
    
    [self.detailsPageContainer addSubview:self.stockPageController.view];
    
    [self.stockPageController didMoveToParentViewController:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stock"];
    
    RSStockEntity *object = (RSStockEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    // Configure the cell from the object
    
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:object.symbol attributes:attrs];
    cell.stockSymbol.attributedText = attrStr;
    
    attrStr = [[NSAttributedString alloc] initWithString:[object.currentPrice stringValue] attributes:attrs];
    cell.stockPrice.attributedText = attrStr;
    
    cell.backgroundColor = [UIColor blackColor];
    float change = [object.changePercent floatValue]*100;
    UIColor *color = nil;
    if( change < 0.0){
        color = [UIColor redColor];
    } else {
        color = [UIColor greenColor];
    }
    
    
    attrs = @{ NSForegroundColorAttributeName : color };
    attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%f", change] attributes:attrs];
    cell.changePercent.attributedText = attrStr;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id< NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections][section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.00;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectionIdx == indexPath.row) {
        [cell setSelected:YES animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectionIdx = indexPath.row;
    
    if(indexPath.row != 0){
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [self.stockTable cellForRowAtIndexPath:path];
        [cell setSelected:NO animated:NO];
    }
        [self updateDetailViewForIndex:indexPath];
   }

-(void)updateDetailViewForIndex:(NSIndexPath *)indexPath{
    RSStockEntity *object = (RSStockEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(object){
        self.currentEntity = object;
        for(RSDetailViewController *dvc in self.pageControllers){
            dvc.statSymbol = object.symbol;
            dvc.stockEntity = object;
        }
    }

}

#pragma mark -coreData
- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RSStockEntity"];
    
    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES];
    
    [request setSortDescriptors:@[lastNameSort]];
    
    NSManagedObjectContext *moc = [RSCoreDataController sharedInstance].persistentContainer.viewContext;
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        //abort();
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    if(!self.userDrivenChange){
        [self.stockTable reloadData];
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.selectionIdx inSection:0];
        [self updateDetailViewForIndex:path];
    }
}



#pragma mark PageViewControllers

- (RSDetailViewController *)viewControllerAtIndex:(NSUInteger)index {
    RSDetailViewController *childViewController = nil;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *symbol = nil;
   
    
        switch(index){
        case 0:
        {
            childViewController = (RSDetailViewController *)[sb instantiateViewControllerWithIdentifier:@"stats_vc"];
            
            break;
        }
        case 1:
        {
            childViewController = (RSDetailViewController *)[sb instantiateViewControllerWithIdentifier:@"graph_vc"];
            break;
            
        }
        default:
            break;
            
    }
    
    @synchronized (self) {
        childViewController.stockEntity = self.currentEntity;
        [self.pageControllers insertObject:childViewController atIndex:index];
    }
    
    return childViewController;
}
#pragma mark -UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [(RSDetailViewController *)viewController pageIndex];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(RSDetailViewController *)viewController pageIndex];
    
    
    index++;
    
    if (index == 2) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}



@end
