//
//  DCCoalDailyUseViewController.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCCoalDailyUseViewController.h"
#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"

#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"
#import "UIViewController+DC.h"
#import "DCNotificationManager.h"
#import "DCBaseUpdateEntityViewController.h"

@interface DCUseCoalEntityTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *operatorNameLabel;
@property (nonatomic, strong) UILabel *coalWeightLabel;
@end

@implementation DCUseCoalEntityTableViewCell
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

- (void)updateCellWithUseCoalEntity:(UseCoalEntity *)entity
{
    self.dateLabel.text = [DCConstant hourAndMinuteStringFromDate:entity.createDate];
    self.operatorNameLabel.text = entity.operatorName;
    self.coalWeightLabel.text = [entity coalWeightString];
}

@end

@interface DCUpdateUseCoalEntityViewController: DCBaseUpdateEntityViewController<UITextFieldDelegate>
@property (nonatomic, strong) UseCoalEntity *UseCoalEntity;
//Add new coal
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) UITextField *operatorNameField;
@property (nonatomic, strong) UITextField *coalWeightField;

@end

@implementation DCUpdateUseCoalEntityViewController

- (instancetype)initWithUseCoalEntity:(UseCoalEntity *)UseCoalEntity
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.UseCoalEntity = UseCoalEntity;
        [self dc_setPresentAsPopup:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *newLabel = [DCConstant descriptionLabel];
    newLabel.text = self.UseCoalEntity ? @"更新记录" : @"新增记录：";
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
    
    UIView *newCoalBGView = [[UIView alloc] initWithFrame:CGRectZero];
    newCoalBGView.backgroundColor = [UIColor whiteColor];
    newCoalBGView.layer.borderWidth = 1;
    newCoalBGView.layer.borderColor = [BUTTON_COLOR CGColor];
    [self.bgView addSubview:newCoalBGView];
    [newCoalBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newLabel.mas_bottom).offset(EdgeMargin);
        make.left.equalTo(self.bgView.mas_left).offset(EdgeMargin);
        make.right.equalTo(self.bgView.mas_right).offset(-EdgeMargin);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-EdgeMargin);
    }];
    
    UILabel *dateLabel = [DCConstant descriptionLabel];
    dateLabel.text = @"日期:";
    [newCoalBGView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newCoalBGView.mas_top).offset(EdgeMargin);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.dateField = [DCConstant detailField:self];
    self.dateField.enabled = NO;
    self.dateField.placeholder = @"点击生成日期";
    [newCoalBGView addSubview:self.dateField];
    [self.dateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(dateLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *coalWeightLabel = [DCConstant descriptionLabel];
    coalWeightLabel.text = @"煤重量(千克):";
    [newCoalBGView addSubview:coalWeightLabel];
    [coalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.coalWeightField = [DCConstant detailField:self];
    self.coalWeightField.placeholder = @"请输入煤重量";
    [newCoalBGView addSubview:self.coalWeightField];
    [self.coalWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (coalWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *operatorNameLabel = [DCConstant descriptionLabel];
    operatorNameLabel.text = @"操作员:";
    [newCoalBGView addSubview:operatorNameLabel];
    [operatorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.left.equalTo(self.coalWeightField.mas_right).offset(80);
        make.width.equalTo(@(80));
    }];
    
    self.operatorNameField = [DCConstant detailField:self];
    self.operatorNameField.placeholder = @"请输入操作员姓名";
    [newCoalBGView addSubview:self.operatorNameField];
    [self.operatorNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (operatorNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(operatorNameLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
        make.right.equalTo(newCoalBGView.mas_right).offset(-EdgeMargin);
    }];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [newCoalBGView addSubview:saveButton];
    saveButton.layer.borderWidth = 1;
    saveButton.layer.borderColor = [BUTTON_COLOR CGColor];
    saveButton.layer.cornerRadius = 40 * 0.5;
    [saveButton addTarget:self action:@selector(saveEntity:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coalWeightLabel.mas_bottom).offset(40);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.bottom.equalTo(newCoalBGView.mas_bottom).offset(-EdgeMargin);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [newCoalBGView addSubview:deleteButton];
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
    
    if (self.UseCoalEntity) {
        self.dateField.text = [DCConstant stringFromDate:self.UseCoalEntity.createDate];
        self.operatorNameField.text = self.UseCoalEntity.operatorName;
        self.coalWeightField.text = self.UseCoalEntity.coalWeightString;
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
    if (self.coalWeightField.text.length == 0) {
        UIAlertController *alert = [UIAlertController dc_alertControllerWithTitle:@"请输入煤重量" message:nil actionTitle:@"OK" handler:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    BOOL isNewRecord = NO;
    if (!self.UseCoalEntity) {
        self.UseCoalEntity = [[UseCoalEntity alloc] init];
        isNewRecord = YES;
    }
    
    if (!self.UseCoalEntity.createDate) {
        self.UseCoalEntity.createDate = [NSDate date];
    }
    
    self.UseCoalEntity.operatorName = self.operatorNameField.text;
    self.UseCoalEntity.coalWeight = [self.coalWeightField.text integerValue];
    
    if (isNewRecord) {
        [[DCCoreDataManager sharedInstance] addUseCoalData:self.UseCoalEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
    else{
        [[DCCoreDataManager sharedInstance] updateUseCoalData:self.UseCoalEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
}

- (void)deleteEntity:(id)sender
{
    [[DCCoreDataManager sharedInstance] deleteUseCoalData:self.UseCoalEntity complete:^(NSString *errorString) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUseCoalEntityNotificationKey object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

- (void)cancelButtonDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

@interface DCCoalDailyUseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UseCoalEntity *currentCoalEntity;

@property(nonatomic, strong) NSArray<NSArray *>*buyCoalArray;
@end

@implementation DCCoalDailyUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"煤炭使用记录"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addLeftBarItemWithTitle:@"新增记录" target:self action:@selector(createNewRecord:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadUseCoalData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:UpdateUseCoalEntityNotificationKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createNewRecord:(id)sender
{
    DCUpdateUseCoalEntityViewController *updateVC = [[DCUpdateUseCoalEntityViewController alloc] initWithUseCoalEntity:nil];
    [self presentViewController:updateVC animated:YES completion:nil];
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
    DCUseCoalEntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DCUseCoalEntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *subArray = self.buyCoalArray[indexPath.section];
    UseCoalEntity *entity = subArray[indexPath.row];
    [cell updateCellWithUseCoalEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArray = self.buyCoalArray[indexPath.section];
    UseCoalEntity *entity = subArray[indexPath.row];
    DCUpdateUseCoalEntityViewController *updateVC = [[DCUpdateUseCoalEntityViewController alloc] initWithUseCoalEntity:entity];
    [self presentViewController:updateVC animated:YES completion:nil];
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
    UseCoalEntity *entity = [buyCoalArray firstObject];
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
    [self loadUseCoalData];
}

- (void)loadUseCoalData
{
    [[DCCoreDataManager sharedInstance] loadUseCoalData:^(NSArray *coalArray) {
        self.buyCoalArray = [NSArray arrayWithArray:coalArray];
        [self.tableView reloadData];
    }];
}
@end

