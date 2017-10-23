//
//  RSNewsViewController.m
//  RSStockDisplay
//
//  Created by RADHIKA SHARMA on 10/22/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSNewsViewController.h"
#import "RSNewsTableViewCell.h"
#import "RSStockDataProvider.h"
#import "RSStockEntity.h"

@interface RSNewsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) RSStockEntity *newsEntity;
@property (nonatomic, strong) NSArray *newsItems;

@end

@implementation RSNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.newsTable.backgroundColor = [UIColor blackColor];
    self.newsTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.newsTable.separatorColor = [UIColor greenColor];
    // Do any additional setup after loading the view.
    UINib *cellNib = [UINib nibWithNibName:@"RSNewsTableViewCell" bundle:nil];
    [self.newsTable registerNib:cellNib forCellReuseIdentifier:@"NewsCell"];
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

-(void)setStockEntity:(RSStockEntity *)stockEntity{
    if(stockEntity) {
        
        self.newsEntity = stockEntity;
        self.statSymbol = stockEntity.symbol;
        __weak typeof(self) weakSelf = self;
        [[RSStockDataProvider sharedInstance] newsDataForSymbol:self.statSymbol withCompletionBlock:^(NSArray *data, NSError *err){
            if(!err){
                weakSelf.newsItems = data;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.newsTable  reloadData];
                    
                });
                
            }
        }];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RSNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    cell.backgroundColor = [UIColor blackColor];
    
    if(self.newsItems.count > 0){
        NSDictionary *dict = [self.newsItems objectAtIndex:indexPath.row];
    
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor yellowColor],
                             NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:16.0]
                             };
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[dict objectForKey:@"headline"] attributes:attrs];
        cell.newsHeadline.attributedText = attrStr;
        
        attrs = @{ NSForegroundColorAttributeName : [UIColor grayColor],
                   NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14.0]
                   };
        attrStr = [[NSAttributedString alloc] initWithString:[dict objectForKey:@"summary"] attributes:attrs];
        cell.newsDetail.attributedText = attrStr;
    }
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsItems count];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.00;
}


@end
