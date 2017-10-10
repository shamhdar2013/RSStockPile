//
//  RSStatsViewController.m
//  RSStockPile
//
//  Created by RADHIKA SHARMA on 10/7/17.
//  Copyright © 2017 RADHIKA SHARMA. All rights reserved.
//

#import "RSStatsViewController.h"
#import "RSStatsTableViewCell.h"
#import "RSCoreDataController.h"
#import "RSStockEntity.h"


@interface RSStatsViewController ()
@property (nonatomic, strong) RSStockEntity *statEntity;

@end

@implementation RSStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.statsTable.backgroundColor = [UIColor blackColor];
    UINib *cellNib = [UINib nibWithNibName:@"RSStatsTableViewCell" bundle:nil];
    [self.statsTable registerNib:cellNib forCellReuseIdentifier:@"statsCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   RSStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statsCell"];
    
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    /*NSAttributedString *attrStrEmpty = [[NSAttributedString alloc] initWithString:@"__" attributes:attrs];*/
    NSAttributedString *attrStr = nil;
    
        switch(indexPath.row){
            case 0:
            {
                NSString *val1 = self.statEntity ? [self.statEntity.openPrice stringValue] : @"__";
                NSString *val2 = self.statEntity ? [self.statEntity.closePrice stringValue] : @"__";
                
                attrStr = [[NSAttributedString alloc] initWithString:val1 attributes:attrs];
                cell.value1.attributedText =  attrStr;
                
                attrStr = [[NSAttributedString alloc] initWithString:@"open" attributes:attrs];
                
                cell.title1.attributedText = attrStr;
                
                attrStr = [[NSAttributedString alloc] initWithString:@"close" attributes:attrs];
                cell.title2.attributedText = attrStr;
                
                attrStr = [[NSAttributedString alloc] initWithString:val2 attributes:attrs];
                cell.value2.attributedText = attrStr;
                break;
            }
            case 1:
            {
                NSString *val1 = self.statEntity ? [self.statEntity.w52Low stringValue] : @"__";
                NSString *val2 = self.statEntity ? [self.statEntity.w52High stringValue] : @"__";
                
                attrStr = [[NSAttributedString alloc] initWithString:val2 attributes:attrs];
                cell.value1.attributedText =  attrStr;
                
                attrStr = [[NSAttributedString alloc] initWithString:@"52W HIGH" attributes:attrs];
                
                cell.title1.attributedText = attrStr;
                
                attrStr = [[NSAttributedString alloc] initWithString:@"52W LOW" attributes:attrs];
                cell.title2.attributedText = attrStr;
                
                attrStr = [[NSAttributedString alloc] initWithString:val1 attributes:attrs];
                cell.value2.attributedText = attrStr;
                break;
            }
            default:
                break;
        
        
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.00;
}

-(void)setStockEntity:(RSStockEntity *)entity{
    if(entity){
        self.statSymbol = entity.symbol;
        self.statEntity = entity;
        
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:entity.companyName attributes:attrs];
        self.companyName.attributedText = attrStr;
        [self.statsTable reloadData];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
