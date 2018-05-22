//
//  DCStoneMenuViewController.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCStoneMenuViewController.h"
#import "DCStoneDailyUseViewController.h"
#import "DCBaseSplitViewController.h"
#import "DCStoneDailyBuyViewController.h"
#import "DCStoneDailyStoreViewController.h"

@interface DCStoneMenuViewController ()
@end

@implementation DCStoneMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"石头"];
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
        cell.textLabel.text =  @"使用";
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"购买";
    }
    else if(indexPath.section == 2)
    {
        cell.textLabel.text = @"库存";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.currentMenuIndex = DCStoneMenu_Use;
        DCStoneDailyUseViewController *dailyVC = [[DCStoneDailyUseViewController alloc] init];
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:dailyVC];
    }
    else if (indexPath.section == 1)
    {
        self.currentMenuIndex = DCStoneMenu_Buy;
        DCStoneDailyBuyViewController *dailyVC = [[DCStoneDailyBuyViewController alloc] init];
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:dailyVC];
    }
    else if(indexPath.section == 2)
    {
        self.currentMenuIndex = DCStoneMenu_Store;
        DCStoneDailyStoreViewController *dailyVC = [[DCStoneDailyStoreViewController alloc] init];
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:dailyVC];
    }
}

- (void)showViewControllerWithMenu:(DCMenu_type)type
{
    self.currentMenuIndex = type;
    NSIndexPath *currentIndexPath = nil;
    if (self.currentMenuIndex == DCStoneMenu_Buy) {
        currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        DCStoneDailyBuyViewController *dailyVC = [[DCStoneDailyBuyViewController alloc] init];
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:dailyVC];
    }
    else if (self.currentMenuIndex == DCStoneMenu_Use)
    {
        currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        DCStoneDailyUseViewController *dailyVC = [[DCStoneDailyUseViewController alloc] init];
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:dailyVC];
    }
    else if(self.currentMenuIndex == DCStoneMenu_Store)
    {
        currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        DCStoneDailyStoreViewController *dailyVC = [[DCStoneDailyStoreViewController alloc] init];
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:dailyVC];
    }
    
    if (currentIndexPath) {
        [self.tableView selectRowAtIndexPath:currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

@end
