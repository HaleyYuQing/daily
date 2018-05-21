//
//  DCCoalDailyBuyViewController.m
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCCoalDailyBuyViewController.h"
#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"
#import "UIViewController+DC.h"
#import "DCNotificationManager.h"
#import "DCBaseUpdateEntityViewController.h"
#import "DCPlateKeyBoardView.h"

@interface DCBuyCoalEntityTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *carOwnerNameLabel;
@property (nonatomic, strong) UILabel *coalWeightLabel;
@property (nonatomic, strong) UILabel *coalTotalPriceLabel;
@property (nonatomic, strong) UILabel *coalAndCarWeightLabel;
@end

@implementation DCBuyCoalEntityTableViewCell
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
        
        UILabel *coalWeightLabel = [DCConstant detailLabel];
        self.coalWeightLabel = coalWeightLabel;
        coalWeightLabel.text = @"净重量(千克):";
        [self.contentView addSubview:coalWeightLabel];
        [coalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(carOwnerNameLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *coalTotalPriceLabel = [DCConstant detailLabel];
        self.coalTotalPriceLabel = coalTotalPriceLabel;
        coalTotalPriceLabel.text = @"总价(元):";
        [self.contentView addSubview:coalTotalPriceLabel];
        [coalTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coalWeightLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *coalAndCarWeightLabel = [DCConstant detailLabel];
        self.coalAndCarWeightLabel = coalAndCarWeightLabel;
        coalAndCarWeightLabel.text = @"总重量(千克):";
        [self.contentView addSubview:coalAndCarWeightLabel];
        [coalAndCarWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coalTotalPriceLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
    }
    return self;
}

- (void)updateCellWithBuyCoalEntity:(BuyCoalEntity *)entity
{
    self.dateLabel.text = [DCConstant hourAndMinuteStringFromDate:entity.createDate];
    self.carOwnerNameLabel.text = entity.carOwnerName;
    self.coalWeightLabel.text = [entity coalWeightString];
    self.coalTotalPriceLabel.text = [entity coalTotalPriceString];
    self.coalAndCarWeightLabel.text = [entity carAndCoalWeightString];
}

@end

@interface DCUpdateBuyCoalEntityViewController: DCBaseUpdateEntityViewController<UITextFieldDelegate>
@property (nonatomic, strong) BuyCoalEntity *buyCoalEntity;
//Add new coal
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) DCHistoryTextField *carNumberField;
@property (nonatomic, strong) DCHistoryTextField *carOwnerNameField;
@property (nonatomic, strong) UITextField *carWeightField;
@property (nonatomic, strong) UITextField *carAndCoalWeightField;
@property (nonatomic, strong) UITextField *coalWeightField;
@property (nonatomic, strong) UITextField *coalPricePerKGField;
@property (nonatomic, strong) UITextField *coalTotalPriceField;

@property (nonatomic, strong) DCPlateKeyBoardView *keyBoardView;
@end

@implementation DCUpdateBuyCoalEntityViewController

- (instancetype)initWithBuyCoalEntity:(BuyCoalEntity *)buyCoalEntity
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.buyCoalEntity = buyCoalEntity;
        [self dc_setPresentAsPopup:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *newLabel = [DCConstant descriptionLabel];
    newLabel.text = self.buyCoalEntity ? @"更新记录" : @"新增记录：";
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
    
    self.dateField = [DCConstant detailField:self isNumber:NO];
    self.dateField.enabled = NO;
    self.dateField.placeholder = @"点击生成日期";
    [newCoalBGView addSubview:self.dateField];
    [self.dateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(dateLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carNumberLabel = [DCConstant descriptionLabel];
    carNumberLabel.text = @"车牌:";
    [newCoalBGView addSubview:carNumberLabel];
    [carNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carNumberField = [[DCHistoryTextField alloc] initWithDelegate:self isNumber:NO];
    self.carNumberField.tag = UpdateEntity_Type_CoalCarNumber;
    self.carNumberField.placeholder = @"请输入车牌";
    [newCoalBGView addSubview:self.carNumberField];
    [self.carNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carNumberLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    self.keyBoardView = [[DCPlateKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.4)];
    
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
    
    [self.carNumberField setupHistoryTableView:CGRectMake(0, 0, DetailFieldWidth, 120)];
    self.carNumberField.selectHandle = ^(CustomerEntity *customer) {
        weakSelf.carNumberField.text = customer.carNumber;
        weakSelf.carOwnerNameField.text = customer.name;
        weakSelf.carWeightField.text = customer.carWeightString;
        weakSelf.coalPricePerKGField.text = customer.itemPricePerKGString;
    };
    
    UILabel *carOwnerNameLabel = [DCConstant descriptionLabel];
    carOwnerNameLabel.text = @"客户:";
    [newCoalBGView addSubview:carOwnerNameLabel];
    [carOwnerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carNumberField.mas_right).offset(80);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carOwnerNameField = [[DCHistoryTextField alloc] initWithDelegate:self isNumber:NO];
    self.carOwnerNameField.tag = UpdateEntity_Type_CoalUserName;
    self.carOwnerNameField.placeholder = @"请输入客户姓名";
    [newCoalBGView addSubview:self.carOwnerNameField];
    [self.carOwnerNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carOwnerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
        make.right.equalTo(newCoalBGView.mas_right).offset(-EdgeMargin);
    }];
    
    [self.carOwnerNameField setupHistoryTableView:CGRectMake(0, 0, DetailFieldWidth, 120)];
    self.carOwnerNameField.selectHandle = ^(CustomerEntity *customer) {
        weakSelf.carNumberField.text = customer.carNumber;
        weakSelf.carOwnerNameField.text = customer.name;
        weakSelf.carWeightField.text = customer.carWeightString;
        weakSelf.coalPricePerKGField.text = customer.itemPricePerKGString;
    };
    
    UILabel *carAndCoalWeightLabel = [DCConstant descriptionLabel];
    carAndCoalWeightLabel.text = @"总重量(千克):";
    [newCoalBGView addSubview:carAndCoalWeightLabel];
    [carAndCoalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carNumberLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carAndCoalWeightField = [DCConstant detailField:self isNumber:YES];
    self.carAndCoalWeightField.placeholder = @"请输入总重量";
    [newCoalBGView addSubview:self.carAndCoalWeightField];
    [self.carAndCoalWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carAndCoalWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndCoalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carWeightLabel = [DCConstant descriptionLabel];
    carWeightLabel.text = @"车皮重量(千克):";
    [newCoalBGView addSubview:carWeightLabel];
    [carWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carAndCoalWeightField.mas_right).offset(80);
        make.centerY.equalTo(carAndCoalWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carWeightField = [DCConstant detailField:self isNumber:YES];
    self.carWeightField.placeholder = @"请输入车皮重量";
    [newCoalBGView addSubview:self.carWeightField];
    [self.carWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo (carWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndCoalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *coalWeightLabel = [DCConstant descriptionLabel];
    coalWeightLabel.text = @"净重量(千克):";
    [newCoalBGView addSubview:coalWeightLabel];
    [coalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.coalWeightField = [DCConstant detailField:self isNumber:YES];
    self.coalWeightField.placeholder = @"请输入净重量";
    [newCoalBGView addSubview:self.coalWeightField];
    [self.coalWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (coalWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *coalPricePerKGLabel = [DCConstant descriptionLabel];
    coalPricePerKGLabel.text = @"单价(元/吨):";
    [newCoalBGView addSubview:coalPricePerKGLabel];
    [coalPricePerKGLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.coalWeightField.mas_right).offset(80);
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.coalPricePerKGField = [DCConstant detailField:self isNumber:YES];
    self.coalPricePerKGField.placeholder = @"请输入煤单价";
    [newCoalBGView addSubview:self.coalPricePerKGField];
    [self.coalPricePerKGField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (coalPricePerKGLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *coalTotalPriceLabel = [DCConstant descriptionLabel];
    coalTotalPriceLabel.text = @"总价格(元):";
    [newCoalBGView addSubview:coalTotalPriceLabel];
    [coalTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coalWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.coalTotalPriceField = [DCConstant detailField:self isNumber:YES];
    self.coalTotalPriceField.placeholder = @"请输入总价格";
    [newCoalBGView addSubview:self.coalTotalPriceField];
    [self.coalTotalPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (coalTotalPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(coalTotalPriceLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
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
        make.top.equalTo(coalTotalPriceLabel.mas_bottom).offset(40);
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
    
    if (self.buyCoalEntity) {
        self.dateField.text = [DCConstant stringFromDate:self.buyCoalEntity.createDate];
        self.carNumberField.text = self.buyCoalEntity.carNumber;
        self.carOwnerNameField.text = self.buyCoalEntity.carOwnerName;
        self.coalWeightField.text = self.buyCoalEntity.coalWeightString;
        self.carAndCoalWeightField.text = self.buyCoalEntity.carAndCoalWeightString;
        self.carWeightField.text = self.buyCoalEntity.carWeightString;
        self.coalPricePerKGField.text = self.buyCoalEntity.coalPricePerKGString;
        self.coalTotalPriceField.text = self.buyCoalEntity.coalTotalPriceString;
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
    if (textField == self.carAndCoalWeightField || textField == self.carWeightField) {
        if (self.carWeightField.text.length > 0 && self.carAndCoalWeightField.text.length > 0) {
            self.coalWeightField.text = [NSString stringWithFormat:@"%@",@([self.carAndCoalWeightField.text integerValue] - [self.carWeightField.text integerValue])];
            if (self.coalPricePerKGField.text.length >0 ) {
                self.coalTotalPriceField.text = [NSString stringWithFormat:@"%@", @(self.coalWeightField.text.integerValue * self.coalPricePerKGField.text.integerValue * 0.001)];
            }
        }
    }
    
    if (textField == self.coalPricePerKGField && self.coalWeightField.text.length >0) {
        self.coalTotalPriceField.text = [NSString stringWithFormat:@"%@", @(self.coalWeightField.text.integerValue * self.coalPricePerKGField.text.integerValue /1000)];
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
    if (!self.buyCoalEntity) {
        self.buyCoalEntity = [[BuyCoalEntity alloc] init];
        isNewRecord = YES;
    }
    
    if (!self.buyCoalEntity.createDate) {
        self.buyCoalEntity.createDate = [NSDate date];
    }
    
    self.buyCoalEntity.carNumber = self.carNumberField.text;
    self.buyCoalEntity.carOwnerName = self.carOwnerNameField.text;
    self.buyCoalEntity.coalWeight = [self.coalWeightField.text integerValue];
    self.buyCoalEntity.carWeight = [self.carWeightField.text integerValue];
    self.buyCoalEntity.carAndCoalWeight = [self.carAndCoalWeightField.text integerValue];
    self.buyCoalEntity.coalPricePerKG = [self.coalPricePerKGField.text integerValue];
    self.buyCoalEntity.coalTotalPrice = [self.coalTotalPriceField.text integerValue];
    
    if (isNewRecord) {
        [[DCCoreDataManager sharedInstance] addBuyCoalData:self.buyCoalEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
    else{
        [[DCCoreDataManager sharedInstance] updateBuyCoalData:self.buyCoalEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
}

- (void)deleteEntity:(id)sender
{
    [[DCCoreDataManager sharedInstance] deleteBuyCoalData:self.buyCoalEntity complete:^(NSString *errorString) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateBuyCoalEntityNotificationKey object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

- (void)cancelButtonDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

@interface DCCoalDailyBuyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BuyCoalEntity *currentCoalEntity;

@property(nonatomic, strong) NSArray<NSArray *>*buyCoalArray;
@end

@implementation DCCoalDailyBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"煤炭购买记录"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addLeftBarItemWithTitle:@"新增记录" target:self action:@selector(createNewRecord:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadBuyCoalData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:UpdateBuyCoalEntityNotificationKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createNewRecord:(id)sender
{
    DCUpdateBuyCoalEntityViewController *updateVC = [[DCUpdateBuyCoalEntityViewController alloc] initWithBuyCoalEntity:nil];
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
    DCBuyCoalEntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DCBuyCoalEntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *subArray = self.buyCoalArray[indexPath.section];
    BuyCoalEntity *entity = subArray[indexPath.row];
    [cell updateCellWithBuyCoalEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArray = self.buyCoalArray[indexPath.section];
    BuyCoalEntity *entity = subArray[indexPath.row];
    DCUpdateBuyCoalEntityViewController *updateVC = [[DCUpdateBuyCoalEntityViewController alloc] initWithBuyCoalEntity:entity];
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
    BuyCoalEntity *entity = [buyCoalArray firstObject];
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
    
    UILabel *coalWeightLabel = [DCConstant descriptionLabelInHeaderView];
    coalWeightLabel.text = @"净重量(千克):";
    [view addSubview:coalWeightLabel];
    [coalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(carOwnerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *coalTotalPriceLabel = [DCConstant descriptionLabelInHeaderView];
    coalTotalPriceLabel.text = @"总价(元):";
    [view addSubview:coalTotalPriceLabel];
    [coalTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coalWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *coalAndCarWeightLabel = [DCConstant descriptionLabelInHeaderView];
    coalAndCarWeightLabel.text = @"总重量(千克):";
    [view addSubview:coalAndCarWeightLabel];
    [coalAndCarWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coalTotalPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    return view;
}

- (void)updateData:(NSNotification *)note
{
    [self loadBuyCoalData];
}

- (void)loadBuyCoalData
{
    [[DCCoreDataManager sharedInstance] loadBuyCoalData:^(NSArray *coalArray) {
        self.buyCoalArray = [NSArray arrayWithArray:coalArray];
        [self.tableView reloadData];
    }];
}
@end
