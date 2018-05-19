//
//  DCLimeDailySellViewController.m
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCLimeDailySellViewController.h"
#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"
#import "UIViewController+DC.h"
#import "DCNotificationManager.h"
#import "DCPlateKeyBoardView.h"
#import "DCBaseUpdateEntityViewController.h"

@interface DCSellLimeEntityTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *buyerNameLabel;
@property (nonatomic, strong) UILabel *limeWeightLabel;
@property (nonatomic, strong) UILabel *limeTotalPriceLabel;
@property (nonatomic, strong) UILabel *limeAndCarWeightLabel;
@end

@implementation DCSellLimeEntityTableViewCell
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
        
        UILabel *buyerNameLabel = [DCConstant detailLabel];
        self.buyerNameLabel = buyerNameLabel;
        buyerNameLabel.text = @"客户:";
        [self.contentView addSubview:buyerNameLabel];
        [buyerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *limeWeightLabel = [DCConstant detailLabel];
        self.limeWeightLabel = limeWeightLabel;
        limeWeightLabel.text = @"净重量(千克):";
        [self.contentView addSubview:limeWeightLabel];
        [limeWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buyerNameLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *limeTotalPriceLabel = [DCConstant detailLabel];
        self.limeTotalPriceLabel = limeTotalPriceLabel;
        limeTotalPriceLabel.text = @"总价(元):";
        [self.contentView addSubview:limeTotalPriceLabel];
        [limeTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(limeWeightLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *limeAndCarWeightLabel = [DCConstant detailLabel];
        self.limeAndCarWeightLabel = limeAndCarWeightLabel;
        limeAndCarWeightLabel.text = @"总重量(千克):";
        [self.contentView addSubview:limeAndCarWeightLabel];
        [limeAndCarWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(limeTotalPriceLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
    }
    return self;
}

- (void)updateCellWithSellLimeEntity:(SellLimeEntity *)entity
{
    self.dateLabel.text = [DCConstant hourAndMinuteStringFromDate:entity.createDate];
    self.buyerNameLabel.text = entity.buyerName;
    self.limeWeightLabel.text = [entity limeWeightString];
    self.limeTotalPriceLabel.text = [entity limeTotalPriceString];
    self.limeAndCarWeightLabel.text = [entity carAndLimeWeightString];
}

@end

@interface DCUpdateSellLimeEntityViewController: DCBaseUpdateEntityViewController<UITextFieldDelegate>
@property (nonatomic, strong) SellLimeEntity *sellLimeEntity;
//Add new lime
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) UITextField *carNumberField;
@property (nonatomic, strong) UITextField *buyerNameField;
@property (nonatomic, strong) UITextField *carWeightField;
@property (nonatomic, strong) UITextField *carAndLimeWeightField;
@property (nonatomic, strong) UITextField *limeWeightField;
@property (nonatomic, strong) UITextField *limePricePerKGField;
@property (nonatomic, strong) UITextField *limeTotalPriceField;
@property (nonatomic, strong) UITextField *payedPriceField;
@property (nonatomic, strong) UITextField *notPayedPriceField;

@property (nonatomic, strong) DCPlateKeyBoardView *keyBoardView;
@end

@implementation DCUpdateSellLimeEntityViewController

- (instancetype)initWithSellLimeEntity:(SellLimeEntity *)sellLimeEntity
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.sellLimeEntity = sellLimeEntity;
        [self dc_setPresentAsPopup:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *newLabel = [DCConstant descriptionLabel];
    newLabel.text = self.sellLimeEntity ? @"更新记录" : @"新增记录：";
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
    
    UIView *newLimeBGView = [[UIView alloc] initWithFrame:CGRectZero];
    newLimeBGView.backgroundColor = [UIColor whiteColor];
    newLimeBGView.layer.borderWidth = 1;
    newLimeBGView.layer.borderColor = [BUTTON_COLOR CGColor];
    [self.bgView addSubview:newLimeBGView];
    [newLimeBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newLabel.mas_bottom).offset(EdgeMargin);
        make.left.equalTo(self.bgView.mas_left).offset(EdgeMargin);
        make.right.equalTo(self.bgView.mas_right).offset(-EdgeMargin);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-EdgeMargin);
    }];
    
    UILabel *dateLabel = [DCConstant descriptionLabel];
    dateLabel.text = @"日期:";
    [newLimeBGView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newLimeBGView.mas_top).offset(EdgeMargin);
        make.left.equalTo(newLimeBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.dateField = [DCConstant detailField:self];
    self.dateField.enabled = NO;
    self.dateField.placeholder = @"点击生成日期";
    [newLimeBGView addSubview:self.dateField];
    [self.dateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(dateLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carNumberLabel = [DCConstant descriptionLabel];
    carNumberLabel.text = @"车牌:";
    [newLimeBGView addSubview:carNumberLabel];
    [carNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newLimeBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carNumberField = [DCConstant detailField:self];
    self.carNumberField.placeholder = @"请输入车牌";
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
    
    [newLimeBGView addSubview:self.carNumberField];
    [self.carNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carNumberLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *buyerNameLabel = [DCConstant descriptionLabel];
    buyerNameLabel.text = @"客户:";
    [newLimeBGView addSubview:buyerNameLabel];
    [buyerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carNumberField.mas_right).offset(80);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.buyerNameField = [DCConstant detailField:self];
    self.buyerNameField.placeholder = @"请输入客户姓名";
    [newLimeBGView addSubview:self.buyerNameField];
    [self.buyerNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (buyerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
        make.right.equalTo(newLimeBGView.mas_right).offset(-EdgeMargin);
    }];
    
    UILabel *carAndLimeWeightLabel = [DCConstant descriptionLabel];
    carAndLimeWeightLabel.text = @"总重量(千克):";
    [newLimeBGView addSubview:carAndLimeWeightLabel];
    [carAndLimeWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carNumberLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newLimeBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carAndLimeWeightField = [DCConstant detailField:self];
    self.carAndLimeWeightField.placeholder = @"请输入总重量";
    [newLimeBGView addSubview:self.carAndLimeWeightField];
    [self.carAndLimeWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carAndLimeWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndLimeWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carWeightLabel = [DCConstant descriptionLabel];
    carWeightLabel.text = @"车皮重量(千克):";
    [newLimeBGView addSubview:carWeightLabel];
    [carWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carAndLimeWeightField.mas_right).offset(80);
        make.centerY.equalTo(carAndLimeWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carWeightField = [DCConstant detailField:self];
    self.carWeightField.placeholder = @"请输入车皮重量";
    [newLimeBGView addSubview:self.carWeightField];
    [self.carWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo (carWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndLimeWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *limeWeightLabel = [DCConstant descriptionLabel];
    limeWeightLabel.text = @"净重量(千克):";
    [newLimeBGView addSubview:limeWeightLabel];
    [limeWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newLimeBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.limeWeightField = [DCConstant detailField:self];
    self.limeWeightField.placeholder = @"请输入净重量";
    [newLimeBGView addSubview:self.limeWeightField];
    [self.limeWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (limeWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(limeWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *limePricePerKGLabel = [DCConstant descriptionLabel];
    limePricePerKGLabel.text = @"单价(元/吨):";
    [newLimeBGView addSubview:limePricePerKGLabel];
    [limePricePerKGLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.limeWeightField.mas_right).offset(80);
        make.centerY.equalTo(limeWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.limePricePerKGField = [DCConstant detailField:self];
    self.limePricePerKGField.placeholder = @"请输入石灰单价";
    [newLimeBGView addSubview:self.limePricePerKGField];
    [self.limePricePerKGField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (limePricePerKGLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(limeWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *limeTotalPriceLabel = [DCConstant descriptionLabel];
    limeTotalPriceLabel.text = @"总金额(元):";
    [newLimeBGView addSubview:limeTotalPriceLabel];
    [limeTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(limeWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newLimeBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.limeTotalPriceField = [DCConstant detailField:self];
    self.limeTotalPriceField.placeholder = @"请输入总金额";
    [newLimeBGView addSubview:self.limeTotalPriceField];
    [self.limeTotalPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (limeTotalPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(limeTotalPriceLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *payedPriceLabel = [DCConstant descriptionLabel];
    payedPriceLabel.text = @"已付金额(元):";
    [newLimeBGView addSubview:payedPriceLabel];
    [payedPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(limeTotalPriceLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newLimeBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.payedPriceField = [DCConstant detailField:self];
    self.payedPriceField.placeholder = @"请输入已付金额";
    [newLimeBGView addSubview:self.payedPriceField];
    [self.payedPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (payedPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(payedPriceLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *notPayedPriceLabel = [DCConstant descriptionLabel];
    notPayedPriceLabel.text = @"未付金额(元):";
    [newLimeBGView addSubview:notPayedPriceLabel];
    [notPayedPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payedPriceLabel.mas_centerY);
        make.left.equalTo(self.payedPriceField.mas_right).offset(80);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.notPayedPriceField = [DCConstant detailField:self];
    self.notPayedPriceField.placeholder = @"请输入未付金额";
    [newLimeBGView addSubview:self.notPayedPriceField];
    [self.notPayedPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (notPayedPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(payedPriceLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [newLimeBGView addSubview:saveButton];
    saveButton.layer.borderWidth = 1;
    saveButton.layer.borderColor = [BUTTON_COLOR CGColor];
    saveButton.layer.cornerRadius = 40 * 0.5;
    [saveButton addTarget:self action:@selector(saveEntity:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payedPriceLabel.mas_bottom).offset(40);
        make.left.equalTo(newLimeBGView.mas_left).offset(EdgeMargin);
        make.bottom.equalTo(newLimeBGView.mas_bottom).offset(-EdgeMargin);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [newLimeBGView addSubview:deleteButton];
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
    
    if (self.sellLimeEntity) {
        self.dateField.text = [DCConstant stringFromDate:self.sellLimeEntity.createDate];
        self.carNumberField.text = self.sellLimeEntity.carNumber;
        self.buyerNameField.text = self.sellLimeEntity.buyerName;
        self.limeWeightField.text = self.sellLimeEntity.limeWeightString;
        self.carAndLimeWeightField.text = self.sellLimeEntity.carAndLimeWeightString;
        self.carWeightField.text = self.sellLimeEntity.carWeightString;
        self.limePricePerKGField.text = self.sellLimeEntity.limePricePerKGString;
        self.limeTotalPriceField.text = self.sellLimeEntity.limeTotalPriceString;
        self.payedPriceField.text = self.sellLimeEntity.payedPriceString;
        self.notPayedPriceField.text = self.sellLimeEntity.notPayedPriceString;
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
    if (textField == self.carAndLimeWeightField || textField == self.carWeightField) {
        if (self.carWeightField.text.length > 0 && self.carAndLimeWeightField.text.length > 0) {
            self.limeWeightField.text = [NSString stringWithFormat:@"%@",@([self.carAndLimeWeightField.text integerValue] - [self.carWeightField.text integerValue])];
            if (self.limePricePerKGField.text.length >0 ) {
                self.limeTotalPriceField.text = [NSString stringWithFormat:@"%@", @(self.limeWeightField.text.integerValue * self.limePricePerKGField.text.integerValue * 0.001)];
            }
        }
    }
    
    if (textField == self.limePricePerKGField && self.limeWeightField.text.length >0) {
        self.limeTotalPriceField.text = [NSString stringWithFormat:@"%@", @(self.limeWeightField.text.integerValue * self.limePricePerKGField.text.integerValue /1000)];
    }
    
    if (textField == self.payedPriceField || textField == self.limeTotalPriceField) {
        if (self.limeTotalPriceField.text.length > 0 && self.payedPriceField.text.length > 0) {
            self.notPayedPriceField.text = [NSString stringWithFormat:@"%@", @(self.limeTotalPriceField.text.integerValue - self.payedPriceField.text.integerValue)];
        }
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
    if (!self.sellLimeEntity) {
        self.sellLimeEntity = [[SellLimeEntity alloc] init];
        isNewRecord = YES;
    }
    
    if (!self.sellLimeEntity.createDate) {
        self.sellLimeEntity.createDate = [NSDate date];
    }
    
    self.sellLimeEntity.carNumber = self.carNumberField.text;
    self.sellLimeEntity.buyerName = self.buyerNameField.text;
    self.sellLimeEntity.limeWeight = [self.limeWeightField.text integerValue];
    self.sellLimeEntity.carWeight = [self.carWeightField.text integerValue];
    self.sellLimeEntity.carAndLimeWeight = [self.carAndLimeWeightField.text integerValue];
    self.sellLimeEntity.limePricePerKG = [self.limePricePerKGField.text integerValue];
    self.sellLimeEntity.limeTotalPrice = [self.limeTotalPriceField.text integerValue];
    self.sellLimeEntity.payedPrice = [self.payedPriceField.text integerValue];
    self.sellLimeEntity.notPayedPrice = [self.notPayedPriceField.text integerValue];
    
    if (isNewRecord) {
        [[DCCoreDataManager sharedInstance] addSellLimeData:self.sellLimeEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
    else{
        [[DCCoreDataManager sharedInstance] updateSellLimeData:self.sellLimeEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
}

- (void)deleteEntity:(id)sender
{
    [[DCCoreDataManager sharedInstance] deleteSellLimeData:self.sellLimeEntity complete:^(NSString *errorString) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateSellLimeEntityNotificationKey object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

- (void)cancelButtonDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

@interface DCLimeDailySellViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SellLimeEntity *currentLimeEntity;

@property(nonatomic, strong) NSArray<NSArray *>*sellLimeArray;
@end

@implementation DCLimeDailySellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"石灰出售记录"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addLeftBarItemWithTitle:@"新增记录" target:self action:@selector(createNewRecord:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadSellLimeData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:UpdateSellLimeEntityNotificationKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createNewRecord:(id)sender
{
    DCUpdateSellLimeEntityViewController *updateVC = [[DCUpdateSellLimeEntityViewController alloc] initWithSellLimeEntity:nil];
    [self presentViewController:updateVC animated:YES completion:nil];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sellLimeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subArray = self.sellLimeArray[section];
    return subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCSellLimeEntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DCSellLimeEntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *subArray = self.sellLimeArray[indexPath.section];
    SellLimeEntity *entity = subArray[indexPath.row];
    [cell updateCellWithSellLimeEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArray = self.sellLimeArray[indexPath.section];
    SellLimeEntity *entity = subArray[indexPath.row];
    DCUpdateSellLimeEntityViewController *updateVC = [[DCUpdateSellLimeEntityViewController alloc] initWithSellLimeEntity:entity];
    [self presentViewController:updateVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TableViewHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *subArray = self.sellLimeArray[section];
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

- (UIView *)createTableViewHeaderView:(NSArray *)sellLimeArray
{
    SellLimeEntity *entity = [sellLimeArray firstObject];
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
    
    UILabel *buyerNameLabel = [DCConstant descriptionLabelInHeaderView];
    buyerNameLabel.text = @"客户:";
    [view addSubview:buyerNameLabel];
    [buyerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *limeWeightLabel = [DCConstant descriptionLabelInHeaderView];
    limeWeightLabel.text = @"净重量(千克):";
    [view addSubview:limeWeightLabel];
    [limeWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buyerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *limeTotalPriceLabel = [DCConstant descriptionLabelInHeaderView];
    limeTotalPriceLabel.text = @"总价(元):";
    [view addSubview:limeTotalPriceLabel];
    [limeTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(limeWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *limeAndCarWeightLabel = [DCConstant descriptionLabelInHeaderView];
    limeAndCarWeightLabel.text = @"总重量(千克):";
    [view addSubview:limeAndCarWeightLabel];
    [limeAndCarWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(limeTotalPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    return view;
}

- (void)updateData:(NSNotification *)note
{
    [self loadSellLimeData];
}

- (void)loadSellLimeData
{
    [[DCCoreDataManager sharedInstance] loadSellLimeData:^(NSArray *limeArray) {
        self.sellLimeArray = [NSArray arrayWithArray:limeArray];
        [self.tableView reloadData];
    }];
}
@end
