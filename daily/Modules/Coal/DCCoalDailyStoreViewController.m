//
//  DCCoalDailyStoreViewController.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCCoalDailyStoreViewController.h"
#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"

#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"
#import "UIViewController+DC.h"
#import "DCNotificationManager.h"
#import "DCBaseUpdateEntityViewController.h"

@interface DCStoreCoalEntityTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *operatorNameLabel;
@property (nonatomic, strong) UILabel *coalWeightLabel;
@end

@implementation DCStoreCoalEntityTableViewCell
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
        
        UILabel *coalWeightLabel = [DCConstant detailLabel];
        self.coalWeightLabel = coalWeightLabel;
        coalWeightLabel.text = @"煤重量(千克):";
        [self.contentView addSubview:coalWeightLabel];
        [coalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView + 40));
        }];
        
        UILabel *operatorNameLabel = [DCConstant detailLabel];
        self.operatorNameLabel = operatorNameLabel;
        operatorNameLabel.text = @"操作员:";
        [self.contentView addSubview:operatorNameLabel];
        [operatorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coalWeightLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
    }
    return self;
}

- (void)updateCellWithStoreCoalEntity:(StoreCoalEntity *)entity
{
    self.dateLabel.text = [DCConstant hourAndMinuteStringFromDate:entity.createDate];
    self.coalWeightLabel.text = [entity totalWeightString];
}

@end

@interface DCCoalDailyStoreViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) StoreCoalEntity *currentCoalEntity;

@property(nonatomic, strong) NSArray<NSArray *>*buyCoalArray;
@end

@implementation DCCoalDailyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"煤炭使用记录"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadStoreCoalData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.buyCoalArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subArray = self.buyCoalArray[section];
    return subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCStoreCoalEntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DCStoreCoalEntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *subArray = self.buyCoalArray[indexPath.section];
    StoreCoalEntity *entity = subArray[indexPath.row];
    [cell updateCellWithStoreCoalEntity:entity];
    
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
    NSArray *subArray = self.buyCoalArray[section];
    return [self createTableViewHeaderView:subArray];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)createTableViewHeaderView:(NSArray *)buyCoalArray
{
    StoreCoalEntity *entity = [buyCoalArray firstObject];
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
    
    UILabel *coalWeightLabel = [DCConstant descriptionLabelInHeaderView];
    coalWeightLabel.text = @"煤重量(千克):";
    [view addSubview:coalWeightLabel];
    [coalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView + 40));
    }];
    
    UILabel *operatorNameLabel = [DCConstant descriptionLabelInHeaderView];
    operatorNameLabel.text = @"操作员:";
    [view addSubview:operatorNameLabel];
    [operatorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coalWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    return view;
}

- (void)updateData:(NSNotification *)note
{
    [self loadStoreCoalData];
}

- (void)loadStoreCoalData
{
    [[DCCoreDataManager sharedInstance] loadStoreCoalData:^(NSArray *coalArray) {
        self.buyCoalArray = [NSArray arrayWithArray:coalArray];
        [self.tableView reloadData];
    }];
}
@end
