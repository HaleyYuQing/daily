//
//  DCStoneDailyBuyViewController.m
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCStoneDailyBuyViewController.h"
#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"
#import "UIViewController+DC.h"
#import "DCNotificationManager.h"
#import "DCBaseUpdateEntityViewController.h"
#import "DCPlateKeyBoardView.h"

@interface DCBuyStoneEntityTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *carOwnerNameLabel;
@property (nonatomic, strong) UILabel *stoneWeightLabel;
@property (nonatomic, strong) UILabel *stoneTotalPriceLabel;
@property (nonatomic, strong) UILabel *stoneAndCarWeightLabel;
@end

@implementation DCBuyStoneEntityTableViewCell
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
        
        UILabel *carOwnerNameLabel = [DCConstant detailLabel];
        self.carOwnerNameLabel = carOwnerNameLabel;
        carOwnerNameLabel.text = @"客户:";
        [self.contentView addSubview:carOwnerNameLabel];
        [carOwnerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *stoneWeightLabel = [DCConstant detailLabel];
        self.stoneWeightLabel = stoneWeightLabel;
        stoneWeightLabel.text = @"净重量(千克):";
        [self.contentView addSubview:stoneWeightLabel];
        [stoneWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(carOwnerNameLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *stoneTotalPriceLabel = [DCConstant detailLabel];
        self.stoneTotalPriceLabel = stoneTotalPriceLabel;
        stoneTotalPriceLabel.text = @"总价(元):";
        [self.contentView addSubview:stoneTotalPriceLabel];
        [stoneTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(stoneWeightLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *stoneAndCarWeightLabel = [DCConstant detailLabel];
        self.stoneAndCarWeightLabel = stoneAndCarWeightLabel;
        stoneAndCarWeightLabel.text = @"总重量(千克):";
        [self.contentView addSubview:stoneAndCarWeightLabel];
        [stoneAndCarWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(stoneTotalPriceLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
    }
    return self;
}

- (void)updateCellWithBuyStoneEntity:(BuyStoneEntity *)entity
{
    self.dateLabel.text = [DCConstant hourAndMinuteStringFromDate:entity.createDate];
    self.carOwnerNameLabel.text = entity.carOwnerName;
    self.stoneWeightLabel.text = [entity stoneWeightString];
    self.stoneTotalPriceLabel.text = [entity stoneTotalPriceString];
    self.stoneAndCarWeightLabel.text = [entity carAndStoneWeightString];
}

@end

@interface DCUpdateBuyStoneEntityViewController: DCBaseUpdateEntityViewController<UITextFieldDelegate>
@property (nonatomic, strong) BuyStoneEntity *buyStoneEntity;
//Add new stone
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) UITextField *carNumberField;
@property (nonatomic, strong) UITextField *carOwnerNameField;
@property (nonatomic, strong) UITextField *carWeightField;
@property (nonatomic, strong) UITextField *carAndStoneWeightField;
@property (nonatomic, strong) UITextField *stoneWeightField;
@property (nonatomic, strong) UITextField *stonePricePerKGField;
@property (nonatomic, strong) UITextField *stoneTotalPriceField;

@property (nonatomic, strong) DCPlateKeyBoardView *keyBoardView;
@end

@implementation DCUpdateBuyStoneEntityViewController

- (instancetype)initWithBuyStoneEntity:(BuyStoneEntity *)buyStoneEntity
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.buyStoneEntity = buyStoneEntity;
        [self dc_setPresentAsPopup:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *newLabel = [DCConstant descriptionLabel];
    newLabel.text = self.buyStoneEntity ? @"更新记录" : @"新增记录：";
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
    
    self.dateField = [DCConstant detailField:self];
    self.dateField.enabled = NO;
    self.dateField.placeholder = @"点击生成日期";
    [newStoneBGView addSubview:self.dateField];
    [self.dateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(dateLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carNumberLabel = [DCConstant descriptionLabel];
    carNumberLabel.text = @"车牌:";
    [newStoneBGView addSubview:carNumberLabel];
    [carNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newStoneBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carNumberField = [DCConstant detailField:self];
    self.carNumberField.placeholder = @"请输入车牌";
    [newStoneBGView addSubview:self.carNumberField];
    [self.carNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carNumberLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    self.keyBoardView = [[DCPlateKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.33)];
    
    __weak typeof(self) weakSelf = self;
    self.keyBoardView.selectHandle = ^(NSString *string, BOOL isProvinceString) {
        if ([string isEqualToString: @""] && weakSelf.carNumberField.text.length > 0) {
            weakSelf.carNumberField.text = [weakSelf.carNumberField.text substringToIndex:(weakSelf.carNumberField.text.length - 1)];
            if (weakSelf.carNumberField.text.length == 0) {
                [weakSelf.keyBoardView deleteEnd];
            }
        }
        else if (string == nil)
        {
            [weakSelf.carNumberField resignFirstResponder];
        }
        else
        {
            if (isProvinceString)
            {
                weakSelf.carNumberField.text = string;
            }
            else
            {
                weakSelf.carNumberField.text = [weakSelf.carNumberField.text stringByAppendingString:string];
                if (weakSelf.carNumberField.text.length == 7)
                {
                    [weakSelf.carNumberField resignFirstResponder];
                }
            }
        }
    };
    
    self.carNumberField.inputView = self.keyBoardView;
    
    UILabel *carOwnerNameLabel = [DCConstant descriptionLabel];
    carOwnerNameLabel.text = @"客户:";
    [newStoneBGView addSubview:carOwnerNameLabel];
    [carOwnerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carNumberField.mas_right).offset(80);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carOwnerNameField = [DCConstant detailField:self];
    self.carOwnerNameField.placeholder = @"请输入客户姓名";
    [newStoneBGView addSubview:self.carOwnerNameField];
    [self.carOwnerNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carOwnerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
        make.right.equalTo(newStoneBGView.mas_right).offset(-EdgeMargin);
    }];
    
    UILabel *carAndStoneWeightLabel = [DCConstant descriptionLabel];
    carAndStoneWeightLabel.text = @"总重量(千克):";
    [newStoneBGView addSubview:carAndStoneWeightLabel];
    [carAndStoneWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carNumberLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newStoneBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carAndStoneWeightField = [DCConstant detailField:self];
    self.carAndStoneWeightField.placeholder = @"请输入总重量";
    [newStoneBGView addSubview:self.carAndStoneWeightField];
    [self.carAndStoneWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carAndStoneWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndStoneWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carWeightLabel = [DCConstant descriptionLabel];
    carWeightLabel.text = @"车皮重量(千克):";
    [newStoneBGView addSubview:carWeightLabel];
    [carWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carAndStoneWeightField.mas_right).offset(80);
        make.centerY.equalTo(carAndStoneWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carWeightField = [DCConstant detailField:self];
    self.carWeightField.placeholder = @"请输入车皮重量";
    [newStoneBGView addSubview:self.carWeightField];
    [self.carWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo (carWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndStoneWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *stoneWeightLabel = [DCConstant descriptionLabel];
    stoneWeightLabel.text = @"净重量(千克):";
    [newStoneBGView addSubview:stoneWeightLabel];
    [stoneWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newStoneBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.stoneWeightField = [DCConstant detailField:self];
    self.stoneWeightField.placeholder = @"请输入净重量";
    [newStoneBGView addSubview:self.stoneWeightField];
    [self.stoneWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (stoneWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(stoneWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *stonePricePerKGLabel = [DCConstant descriptionLabel];
    stonePricePerKGLabel.text = @"单价(元/吨):";
    [newStoneBGView addSubview:stonePricePerKGLabel];
    [stonePricePerKGLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.stoneWeightField.mas_right).offset(80);
        make.centerY.equalTo(stoneWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.stonePricePerKGField = [DCConstant detailField:self];
    self.stonePricePerKGField.placeholder = @"请输入石头单价";
    [newStoneBGView addSubview:self.stonePricePerKGField];
    [self.stonePricePerKGField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (stonePricePerKGLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(stoneWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *stoneTotalPriceLabel = [DCConstant descriptionLabel];
    stoneTotalPriceLabel.text = @"总价格(元):";
    [newStoneBGView addSubview:stoneTotalPriceLabel];
    [stoneTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stoneWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newStoneBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.stoneTotalPriceField = [DCConstant detailField:self];
    self.stoneTotalPriceField.placeholder = @"请输入总价格";
    [newStoneBGView addSubview:self.stoneTotalPriceField];
    [self.stoneTotalPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (stoneTotalPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(stoneTotalPriceLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
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
        make.top.equalTo(stoneTotalPriceLabel.mas_bottom).offset(40);
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
    
    if (self.buyStoneEntity) {
        self.dateField.text = [DCConstant stringFromDate:self.buyStoneEntity.createDate];
        self.carNumberField.text = self.buyStoneEntity.carNumber;
        self.carOwnerNameField.text = self.buyStoneEntity.carOwnerName;
        self.stoneWeightField.text = self.buyStoneEntity.stoneWeightString;
        self.carAndStoneWeightField.text = self.buyStoneEntity.carAndStoneWeightString;
        self.carWeightField.text = self.buyStoneEntity.carWeightString;
        self.stonePricePerKGField.text = self.buyStoneEntity.stonePricePerKGString;
        self.stoneTotalPriceField.text = self.buyStoneEntity.stoneTotalPriceString;
    }
    else{
        self.dateField.text = [DCConstant stringFromDate:[NSDate date]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.carAndStoneWeightField || textField == self.carWeightField) {
        if (self.carWeightField.text.length > 0 && self.carAndStoneWeightField.text.length > 0) {
            self.stoneWeightField.text = [NSString stringWithFormat:@"%@",@([self.carAndStoneWeightField.text integerValue] - [self.carWeightField.text integerValue])];
            if (self.stonePricePerKGField.text.length >0 ) {
                self.stoneTotalPriceField.text = [NSString stringWithFormat:@"%@", @(self.stoneWeightField.text.integerValue * self.stonePricePerKGField.text.integerValue * 0.001)];
            }
        }
    }
    
    if (textField == self.stonePricePerKGField && self.stoneWeightField.text.length >0) {
        self.stoneTotalPriceField.text = [NSString stringWithFormat:@"%@", @(self.stoneWeightField.text.integerValue * self.stonePricePerKGField.text.integerValue /1000)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)saveEntity:(id)sender
{
    if (self.carNumberField.text.length == 0) {
        UIAlertController *alert = [UIAlertController dc_alertControllerWithTitle:@"Please input car number" message:nil actionTitle:@"OK" handler:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    BOOL isNewRecord = NO;
    if (!self.buyStoneEntity) {
        self.buyStoneEntity = [[BuyStoneEntity alloc] init];
        isNewRecord = YES;
    }
    
    if (!self.buyStoneEntity.createDate) {
        self.buyStoneEntity.createDate = [NSDate date];
    }
    
    self.buyStoneEntity.carNumber = self.carNumberField.text;
    self.buyStoneEntity.carOwnerName = self.carOwnerNameField.text;
    self.buyStoneEntity.stoneWeight = [self.stoneWeightField.text integerValue];
    self.buyStoneEntity.carWeight = [self.carWeightField.text integerValue];
    self.buyStoneEntity.carAndStoneWeight = [self.carAndStoneWeightField.text integerValue];
    self.buyStoneEntity.stonePricePerKG = [self.stonePricePerKGField.text integerValue];
    self.buyStoneEntity.stoneTotalPrice = [self.stoneTotalPriceField.text integerValue];
    
    if (isNewRecord) {
        [[DCCoreDataManager sharedInstance] addBuyStoneData:self.buyStoneEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
    else{
        [[DCCoreDataManager sharedInstance] updateBuyStoneData:self.buyStoneEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
}

- (void)deleteEntity:(id)sender
{
    [[DCCoreDataManager sharedInstance] deleteBuyStoneData:self.buyStoneEntity complete:^(NSString *errorString) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateBuyStoneEntityNotificationKey object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

- (void)cancelButtonDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

@interface DCStoneDailyBuyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BuyStoneEntity *currentStoneEntity;

@property(nonatomic, strong) NSArray<NSArray *>*buyStoneArray;
@end

@implementation DCStoneDailyBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"石头购买记录"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addLeftBarItemWithTitle:@"新增记录" target:self action:@selector(createNewRecord:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadBuyStoneData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:UpdateBuyStoneEntityNotificationKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createNewRecord:(id)sender
{
    DCUpdateBuyStoneEntityViewController *updateVC = [[DCUpdateBuyStoneEntityViewController alloc] initWithBuyStoneEntity:nil];
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
    DCBuyStoneEntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DCBuyStoneEntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *subArray = self.buyStoneArray[indexPath.section];
    BuyStoneEntity *entity = subArray[indexPath.row];
    [cell updateCellWithBuyStoneEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArray = self.buyStoneArray[indexPath.section];
    BuyStoneEntity *entity = subArray[indexPath.row];
    DCUpdateBuyStoneEntityViewController *updateVC = [[DCUpdateBuyStoneEntityViewController alloc] initWithBuyStoneEntity:entity];
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
    BuyStoneEntity *entity = [buyStoneArray firstObject];
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
    
    UILabel *carOwnerNameLabel = [DCConstant descriptionLabelInHeaderView];
    carOwnerNameLabel.text = @"客户:";
    [view addSubview:carOwnerNameLabel];
    [carOwnerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *stoneWeightLabel = [DCConstant descriptionLabelInHeaderView];
    stoneWeightLabel.text = @"净重量(千克):";
    [view addSubview:stoneWeightLabel];
    [stoneWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(carOwnerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *stoneTotalPriceLabel = [DCConstant descriptionLabelInHeaderView];
    stoneTotalPriceLabel.text = @"总价(元):";
    [view addSubview:stoneTotalPriceLabel];
    [stoneTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stoneWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *stoneAndCarWeightLabel = [DCConstant descriptionLabelInHeaderView];
    stoneAndCarWeightLabel.text = @"总重量(千克):";
    [view addSubview:stoneAndCarWeightLabel];
    [stoneAndCarWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stoneTotalPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    return view;
}

- (void)updateData:(NSNotification *)note
{
    [self loadBuyStoneData];
}

- (void)loadBuyStoneData
{
    [[DCCoreDataManager sharedInstance] loadBuyStoneData:^(NSArray *stoneArray) {
        self.buyStoneArray = [NSArray arrayWithArray:stoneArray];
        [self.tableView reloadData];
    }];
}
@end

