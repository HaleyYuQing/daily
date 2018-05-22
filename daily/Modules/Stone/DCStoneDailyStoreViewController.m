//
//  DCStoneDailyStoreViewController.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCStoneDailyStoreViewController.h"
#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"

#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"
#import "UIViewController+DC.h"
#import "DCNotificationManager.h"
#import "DCBaseUpdateEntityViewController.h"

@interface DCStoreStoneEntityTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *operatorNameLabel;
@property (nonatomic, strong) UILabel *stoneWeightLabel;
@end

@implementation DCStoreStoneEntityTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *dateLabel = [DCConstant detailLabel];
        self.dateLabel = dateLabel;
        dateLabel.text = @"5月12日";
        [self.contentView addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *stoneWeightLabel = [DCConstant detailLabel];
        self.stoneWeightLabel = stoneWeightLabel;
        stoneWeightLabel.text = @"石头重量(千克):";
        [self.contentView addSubview:stoneWeightLabel];
        [stoneWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView + 40));
        }];
    }
    return self;
}

- (void)updateCellWithStoreStoneEntity:(StoreStoneEntity *)entity
{
    self.dateLabel.text = [DCConstant hourAndMinuteStringFromDate:entity.createDate];
    self.stoneWeightLabel.text = [entity totalWeightString];
}

@end

@interface DCStoneDailyStoreViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) StoreStoneEntity *currentStoneEntity;

@property(nonatomic, strong) NSArray<NSArray *>*storeStoneArray;
@end

@implementation DCStoneDailyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"石头库存记录"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadStoreStoneData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.storeStoneArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCStoreStoneEntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DCStoreStoneEntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    StoreStoneEntity *entity = (StoreStoneEntity *)self.storeStoneArray[indexPath.section];
    [cell updateCellWithStoreStoneEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TableViewHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    StoreStoneEntity *entity = (StoreStoneEntity *)self.storeStoneArray[section];
    return [self createTableViewHeaderView:entity];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)createTableViewHeaderView:(StoreStoneEntity *)entity
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TableViewHeaderViewHeight)];
    view.backgroundColor = [UIColor colorWithHex:@"0E404E"];
    UILabel *dateLabel = [DCConstant descriptionLabelInHeaderView];
    dateLabel.text = [DCConstant monthAndDayStringFromDate:entity.createDate];
    [view addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *stoneWeightLabel = [DCConstant descriptionLabelInHeaderView];
    stoneWeightLabel.text = @"石头重量(千克):";
    [view addSubview:stoneWeightLabel];
    [stoneWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView + 40));
    }];
    
    return view;
}

- (void)updateData:(NSNotification *)note
{
    [self loadStoreStoneData];
}

- (void)loadStoreStoneData
{
    [[DCCoreDataManager sharedInstance] loadStoreStoneData:^(NSArray *stoneArray) {
        self.storeStoneArray = [NSArray arrayWithArray:stoneArray];
        [self.tableView reloadData];
    }];
}
@end

