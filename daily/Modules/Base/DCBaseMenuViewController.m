//
//  DCBaseMenuViewController.m
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCBaseMenuViewController.h"
#import "DCBaseSplitViewController.h"
#import "DCStoneDailyUseViewController.h"
#import "DCStoneDailyBuyViewController.h"
#import "DCStoneDailyStoreViewController.h"
#import "DCLimeDailySellViewController.h"
#import "DCLimeDailyPreorderViewController.h"
#import "DCCoalDailyUseViewController.h"
#import "DCCoalDailyBuyViewController.h"
#import "DCCoalDailyStoreViewController.h"

@interface DCBaseMenuViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation DCBaseMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentMenuIndex = DCMenu_NotFound;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuIndexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.menuIndexArray[indexPath.section] integerValue] == self.currentMenuIndex) {
        return;
    }
    self.currentMenuIndex = [self.menuIndexArray[indexPath.section] integerValue];
    [self showViewController:self.currentMenuIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (DCMenu_type)currentMenu
{
    return self.currentMenuIndex;
}

- (void)showViewControllerWithMenu:(DCMenu_type)type
{
    self.currentMenuIndex = type;
    NSIndexPath *currentIndexPath = [self showViewController:type];
    if (currentIndexPath) {
        [self.tableView selectRowAtIndexPath:currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (NSIndexPath *)showViewController:(DCMenu_type)type
{
    self.currentMenuIndex = type;
    DCBaseViewController *vc = nil;
    NSIndexPath *currentIndexPath = nil;
    
    switch (self.currentMenuIndex) {
        case DCStoneMenu_Use:
        {
            currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            vc = [[DCStoneDailyUseViewController alloc] init];
            break;
        }
        case DCStoneMenu_Buy:
            {
                currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                vc = [[DCStoneDailyBuyViewController alloc] init];
                break;
            }
        case DCStoneMenu_Store:
        {
            currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            vc = [[DCStoneDailyStoreViewController alloc] init];
            break;
        }
        case DCLimeMenu_Sell:
        {
            currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            vc = [[DCLimeDailySellViewController alloc] init];
            break;
        }
        case DCLimeMenu_Store:
        {
            currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            vc = [[DCLimeDailyPreorderViewController alloc] init];
            break;
        }
        case DCCoalMenu_Use:
        {
            currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            vc = [[DCCoalDailyUseViewController alloc] init];
            break;
        }
        case DCCoalMenu_Buy:
        {
            currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            vc = [[DCCoalDailyBuyViewController alloc] init];
            break;
        }
        case DCCoalMenu_Store:
        {
            currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            vc = [[DCCoalDailyStoreViewController alloc] init];
            break;
        }
        default:
            break;
    }
    if (vc)
    {
        [(DCBaseSplitViewController *)self.splitViewController showRightViewController:vc];
    }
    
    return currentIndexPath;
}
@end
