//
//  DCStoneDailyUseViewController.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCStoneDailyUseViewController.h"
#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"

#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"
#import "UIViewController+DC.h"
#import "DCNotificationManager.h"
#import "DCBaseUpdateEntityViewController.h"

@interface DCUseStoneEntityTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *operatorNameLabel;
@property (nonatomic, strong) UILabel *stoneWeightLabel;
@end

@implementation DCUseStoneEntityTableViewCell
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
        
        UILabel *operatorNameLabel = [DCConstant detailLabel];
        self.operatorNameLabel = operatorNameLabel;
        operatorNameLabel.text = @"操作员:";
        [self.contentView addSubview:operatorNameLabel];
        [operatorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(stoneWeightLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
    }
    return self;
}

- (void)updateCellWithUseStoneEntity:(UseStoneEntity *)entity
{
    self.dateLabel.text = [DCConstant hourAndMinuteStringFromDate:entity.createDate];
    self.operatorNameLabel.text = entity.operatorName;
    self.stoneWeightLabel.text = [entity stoneWeightString];
}

@end

@interface DCUpdateUseStoneEntityViewController: DCBaseUpdateEntityViewController<UITextFieldDelegate>
@property (nonatomic, strong) UseStoneEntity *UseStoneEntity;
//Add new stone
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) UITextField *operatorNameField;
@property (nonatomic, strong) UITextField *stoneWeightField;

@end

@implementation DCUpdateUseStoneEntityViewController

- (instancetype)initWithUseStoneEntity:(UseStoneEntity *)UseStoneEntity
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.UseStoneEntity = UseStoneEntity;
        [self dc_setPresentAsPopup:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    UILabel *newLabel = [DCConstant descriptionLabel];
    newLabel.text = self.UseStoneEntity ? @"更新记录" : @"新增记录：";
    [self.bgView addSubview:newLabel];
    [newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(EdgeMargin);
        make.left.equalTo(self.bgView.mas_left).offset(EdgeMargin);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [BUTTON_COLOR CGColor];
    cancelButton.layer.cornerRadius = 40 * 0.5;
    [cancelButton addTarget:self action:@selector(cancelButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newLabel.mas_centerY);
        make.right.equalTo(self.bgView.mas_right).offset(-EdgeMargin);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    UIView *newStoneBGView = [[UIView alloc] initWithFrame:CGRectZero];
    newStoneBGView.backgroundColor = [UIColor whiteColor];
    newStoneBGView.layer.borderWidth = 1;
    newStoneBGView.layer.borderColor = [BUTTON_COLOR CGColor];
    [self.bgView addSubview:newStoneBGView];
    [newStoneBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newLabel.mas_bottom).offset(EdgeMargin);
        make.left.equalTo(self.bgView.mas_left).offset(EdgeMargin);
        make.right.equalTo(self.bgView.mas_right).offset(-EdgeMargin);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-EdgeMargin);
    }];
    
    UILabel *dateLabel = [DCConstant descriptionLabel];
    dateLabel.text = @"日期:";
    [newStoneBGView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newStoneBGView.mas_top).offset(EdgeMargin);
        make.left.equalTo(newStoneBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.dateField = [DCConstant detailField:self isNumber:NO];
    self.dateField.enabled = NO;
    self.dateField.placeholder = @"点击生成日期";
    [newStoneBGView addSubview:self.dateField];
    [self.dateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(dateLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *stoneWeightLabel = [DCConstant descriptionLabel];
    stoneWeightLabel.text = @"石头重量(千克):";
    [newStoneBGView addSubview:stoneWeightLabel];
    [stoneWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newStoneBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.stoneWeightField = [DCConstant detailField:self isNumber:YES];
    self.stoneWeightField.placeholder = @"请输入石头重量";
    [newStoneBGView addSubview:self.stoneWeightField];
    [self.stoneWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (stoneWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(stoneWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *operatorNameLabel = [DCConstant descriptionLabel];
    operatorNameLabel.text = @"操作员:";
    [newStoneBGView addSubview:operatorNameLabel];
    [operatorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(stoneWeightLabel.mas_centerY);
        make.left.equalTo(self.stoneWeightField.mas_right).offset(80);
        make.width.equalTo(@(80));
    }];
    
    self.operatorNameField = [DCConstant detailField:self isNumber:NO];
    self.operatorNameField.placeholder = @"请输入操作员姓名";
    [newStoneBGView addSubview:self.operatorNameField];
    [self.operatorNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (operatorNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(operatorNameLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
        make.right.equalTo(newStoneBGView.mas_right).offset(-EdgeMargin);
    }];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [newStoneBGView addSubview:saveButton];
    saveButton.layer.borderWidth = 1;
    saveButton.layer.borderColor = [BUTTON_COLOR CGColor];
    saveButton.layer.cornerRadius = 40 * 0.5;
    [saveButton addTarget:self action:@selector(saveEntity:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stoneWeightLabel.mas_bottom).offset(40);
        make.left.equalTo(newStoneBGView.mas_left).offset(EdgeMargin);
        make.bottom.equalTo(newStoneBGView.mas_bottom).offset(-EdgeMargin);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [newStoneBGView addSubview:deleteButton];
    deleteButton.layer.borderWidth = 1;
    deleteButton.layer.borderColor = [BUTTON_COLOR CGColor];
    deleteButton.layer.cornerRadius = 40 * 0.5;
    [deleteButton addTarget:self action:@selector(deleteEntity:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (saveButton.mas_right).offset(80);
        make.centerY.equalTo(saveButton.mas_centerY);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    
    if (self.UseStoneEntity) {
        self.dateField.text = [DCConstant stringFromDate:self.UseStoneEntity.createDate];
        self.operatorNameField.text = self.UseStoneEntity.operatorName;
        self.stoneWeightField.text = self.UseStoneEntity.stoneWeightString;
    }
    else{
        self.dateField.text = [DCConstant stringFromDate:[NSDate date]];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)saveEntity:(id)sender
{
    if (self.stoneWeightField.text.length == 0) {
        UIAlertController *alert = [UIAlertController dc_alertControllerWithTitle:@"请输入石头重量" message:nil actionTitle:@"OK" handler:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    BOOL isNewRecord = NO;
    if (!self.UseStoneEntity) {
        self.UseStoneEntity = [[UseStoneEntity alloc] init];
        isNewRecord = YES;
    }
    
    if (!self.UseStoneEntity.createDate) {
        self.UseStoneEntity.createDate = [NSDate date];
    }
    
    self.UseStoneEntity.operatorName = self.operatorNameField.text;
    self.UseStoneEntity.stoneWeight = [self.stoneWeightField.text integerValue];
    
    if (isNewRecord) {
        [[DCCoreDataManager sharedInstance] addUseStoneData:self.UseStoneEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
    else{
        [[DCCoreDataManager sharedInstance] updateUseStoneData:self.UseStoneEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
}

- (void)deleteEntity:(id)sender
{
    [[DCCoreDataManager sharedInstance] deleteUseStoneData:self.UseStoneEntity complete:^(NSString *errorString) {
        [self finishAction:errorString];
    }];
}

- (void)finishAction:(NSString *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            UIAlertController *alert = [UIAlertController dc_alertControllerWithTitle:nil message:error actionTitle:@"OK" handler:nil];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUseStoneEntityNotificationKey object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

- (void)cancelButtonDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

@interface DCStoneDailyUseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UseStoneEntity *currentStoneEntity;

@property(nonatomic, strong) NSArray<NSArray *>*buyStoneArray;
@end

@implementation DCStoneDailyUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"石头使用记录"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addLeftBarItemWithTitle:@"新增记录" target:self action:@selector(createNewRecord:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadUseStoneData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:UpdateUseStoneEntityNotificationKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createNewRecord:(id)sender
{
    DCUpdateUseStoneEntityViewController *updateVC = [[DCUpdateUseStoneEntityViewController alloc] initWithUseStoneEntity:nil];
    [self presentViewController:updateVC animated:YES completion:nil];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.buyStoneArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subArray = self.buyStoneArray[section];
    return subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCUseStoneEntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DCUseStoneEntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *subArray = self.buyStoneArray[indexPath.section];
    UseStoneEntity *entity = subArray[indexPath.row];
    [cell updateCellWithUseStoneEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArray = self.buyStoneArray[indexPath.section];
    UseStoneEntity *entity = subArray[indexPath.row];
    DCUpdateUseStoneEntityViewController *updateVC = [[DCUpdateUseStoneEntityViewController alloc] initWithUseStoneEntity:entity];
    [self presentViewController:updateVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TableViewHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *subArray = self.buyStoneArray[section];
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

- (UIView *)createTableViewHeaderView:(NSArray *)buyStoneArray
{
    UseStoneEntity *entity = [buyStoneArray firstObject];
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
    
    UILabel *operatorNameLabel = [DCConstant descriptionLabelInHeaderView];
    operatorNameLabel.text = @"操作员:";
    [view addSubview:operatorNameLabel];
    [operatorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stoneWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    return view;
}

- (void)updateData:(NSNotification *)note
{
    [self loadUseStoneData];
}

- (void)loadUseStoneData
{
    [[DCCoreDataManager sharedInstance] loadUseStoneData:^(NSArray *stoneArray) {
        self.buyStoneArray = [NSArray arrayWithArray:stoneArray];
        [self.tableView reloadData];
    }];
}
@end

