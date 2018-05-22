//
//  DCLimeMenuViewController.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCLimeMenuViewController.h"
#import "DCBaseSplitViewController.h"
#import "DCLimeDailySellViewController.h"
#import "DCLimeDailyPreorderViewController.h"

@interface DCLimeMenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DCLimeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"石灰"];
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.text =  @"出售";
    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = @"预定";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.currentMenuIndex = DCLimeMenu_Sell;
        DCLimeDailySellViewController *dailyVC = [[DCLimeDailySellViewController alloc] init];
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:dailyVC];
    }
    else if (indexPath.section == 1)
    {
        self.currentMenuIndex = DCLimeMenu_Store;
        DCLimeDailyPreorderViewController *dailyVC = [[DCLimeDailyPreorderViewController alloc] init];
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:dailyVC];
    }
}

- (void)showViewControllerWithMenu:(DCMenu_type)type
{
    self.currentMenuIndex = type;
    NSIndexPath *currentIndexPath = nil;
    if (self.currentMenuIndex == DCLimeMenu_Sell) {
        currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        DCLimeDailySellViewController *dailyVC = [[DCLimeDailySellViewController alloc] init];
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:dailyVC];
    }
    else if(self.currentMenuIndex == DCLimeMenu_Store)
    {
        currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        DCLimeDailyPreorderViewController *dailyVC = [[DCLimeDailyPreorderViewController alloc] init];
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:dailyVC];
    }
    
    if (currentIndexPath) {
        [self.tableView selectRowAtIndexPath:currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}
@end
