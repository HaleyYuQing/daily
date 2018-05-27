//
//  DCBaseItemDailyBuyViewController.m
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCBaseItemDailyBuyViewController.h"
#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"
#import "UIViewController+DC.h"
#import "DCNotificationManager.h"
#import "DCPlateKeyBoardView.h"
#import "DCBaseUpdateEntityViewController.h"
#import "DCSearchCarAndUserViewController.h"

@interface DCItemBuyEntityTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *buyerNameLabel;
@property (nonatomic, strong) UILabel *itemWeightLabel;
@property (nonatomic, strong) UILabel *itemTotalPriceLabel;
@property (nonatomic, strong) UILabel *notPayedPriceLabel;
@end

@implementation DCItemBuyEntityTableViewCell
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
        
        UILabel *itemWeightLabel = [DCConstant detailLabel];
        self.itemWeightLabel = itemWeightLabel;
        itemWeightLabel.text = @"净重量(千克):";
        [self.contentView addSubview:itemWeightLabel];
        [itemWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buyerNameLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *itemTotalPriceLabel = [DCConstant detailLabel];
        self.itemTotalPriceLabel = itemTotalPriceLabel;
        itemTotalPriceLabel.text = @"总价(元):";
        [self.contentView addSubview:itemTotalPriceLabel];
        [itemTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemWeightLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *notPayedPriceLabel = [DCConstant detailLabel];
        self.notPayedPriceLabel = notPayedPriceLabel;
        notPayedPriceLabel.text = @"未付金额(千克):";
        [self.contentView addSubview:notPayedPriceLabel];
        [notPayedPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemTotalPriceLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
    }
    return self;
}

- (void)updateCellWithItemBuyEntity:(BaseItemEntity *)entity
{
    self.dateLabel.text = [DCConstant hourAndMinuteStringFromDate:entity.createDate];
    self.buyerNameLabel.text = entity.buyerName;
    self.itemWeightLabel.text = [entity itemWeightString];
    self.itemTotalPriceLabel.text = [entity itemTotalPriceString];
    self.notPayedPriceLabel.text = [entity notPayedPriceString];
}

@end

@interface DCUpdateItemBuyEntityViewController: DCBaseUpdateEntityViewController<UITextFieldDelegate, UISearchBarDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) BaseItemEntity *itemBuyEntity;
@property (nonatomic, assign) ItemEntity_Type itemType;
//Add new item
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) DCHistoryTextField *carNumberField;
@property (nonatomic, strong) DCHistoryTextField *buyerNameField;
@property (nonatomic, strong) UITextField *carWeightField;
@property (nonatomic, strong) UITextField *carAndItemWeightField;
@property (nonatomic, strong) UITextField *itemWeightField;
@property (nonatomic, strong) UITextField *itemPricePerKGField;
@property (nonatomic, strong) UITextField *itemTotalPriceField;
@property (nonatomic, strong) UITextField *payedPriceField;
@property (nonatomic, strong) UITextField *notPayedPriceField;

@property (nonatomic, strong) DCPlateKeyBoardView *keyBoardView;
@end

@implementation DCUpdateItemBuyEntityViewController

- (instancetype)initWithItemBuyEntity:(BaseItemEntity *)itemBuyEntity itemType:(ItemEntity_Type)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.itemBuyEntity = itemBuyEntity;
        self.itemType = type;
        [self dc_setPresentAsPopup:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *newLabel = [DCConstant descriptionLabel];
    newLabel.text = self.itemBuyEntity ? @"更新记录" : @"新增记录：";
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
    
    UIView *newItemBGView = [[UIView alloc] initWithFrame:CGRectZero];
    newItemBGView.backgroundColor = [UIColor whiteColor];
    newItemBGView.layer.borderWidth = 1;
    newItemBGView.layer.borderColor = [BUTTON_COLOR CGColor];
    [self.bgView addSubview:newItemBGView];
    [newItemBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newLabel.mas_bottom).offset(EdgeMargin);
        make.left.equalTo(self.bgView.mas_left).offset(EdgeMargin);
        make.right.equalTo(self.bgView.mas_right).offset(-EdgeMargin);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-EdgeMargin);
    }];
    
    UILabel *dateLabel = [DCConstant descriptionLabel];
    dateLabel.text = @"日期:";
    [newItemBGView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newItemBGView.mas_top).offset(EdgeMargin);
        make.left.equalTo(newItemBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.dateField = [DCConstant detailField:self isNumber:NO];
    self.dateField.enabled = NO;
    self.dateField.placeholder = @"点击生成日期";
    [newItemBGView addSubview:self.dateField];
    [self.dateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(dateLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carNumberLabel = [DCConstant descriptionLabel];
    carNumberLabel.text = @"车牌:";
    [newItemBGView addSubview:carNumberLabel];
    [carNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newItemBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carNumberField = [[DCHistoryTextField alloc] initWithDelegate:self isNumber:NO];
    self.carNumberField.placeholder = @"请输入车牌";
    [newItemBGView addSubview:self.carNumberField];
    [self.carNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carNumberLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    __weak typeof(self) weakSelf = self;
    self.keyBoardView = [[DCPlateKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.4)];
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
                [weakSelf.carNumberField setText: string];
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
        [weakSelf reloadHistoryDataWithKey:weakSelf.carNumberField.text historyTextField:weakSelf.carNumberField];
    };
    self.carNumberField.inputView = self.keyBoardView;
    self.carNumberField.selectHandle = ^(CustomerEntity *customer) {
        weakSelf.carNumberField.text = customer.carNumber;
        weakSelf.buyerNameField.text = customer.name;
        weakSelf.carWeightField.text = customer.carWeightString;
        weakSelf.itemPricePerKGField.text = customer.itemPricePerKGString;
    };
    
    UILabel *buyerNameLabel = [DCConstant descriptionLabel];
    buyerNameLabel.text = @"客户:";
    [newItemBGView addSubview:buyerNameLabel];
    [buyerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carNumberField.mas_right).offset(80);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.buyerNameField = [[DCHistoryTextField alloc] initWithDelegate:self isNumber:NO];
    self.buyerNameField.placeholder = @"请输入客户姓名";
    self.buyerNameField.selectHandle = ^(CustomerEntity *customer) {
        weakSelf.carNumberField.text = customer.carNumber;
        weakSelf.buyerNameField.text = customer.name;
        weakSelf.carWeightField.text = customer.carWeightString;
        weakSelf.itemPricePerKGField.text = customer.itemPricePerKGString;
    };
    
    [newItemBGView addSubview:self.buyerNameField];
    [self.buyerNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (buyerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
        make.right.equalTo(newItemBGView.mas_right).offset(-EdgeMargin);
    }];
    
    UILabel *carAndItemWeightLabel = [DCConstant descriptionLabel];
    carAndItemWeightLabel.text = @"总重量(千克):";
    [newItemBGView addSubview:carAndItemWeightLabel];
    [carAndItemWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carNumberLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newItemBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carAndItemWeightField = [DCConstant detailField:self isNumber:YES];
    self.carAndItemWeightField.placeholder = @"请输入总重量";
    [newItemBGView addSubview:self.carAndItemWeightField];
    [self.carAndItemWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carAndItemWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndItemWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carWeightLabel = [DCConstant descriptionLabel];
    carWeightLabel.text = @"车皮重量(千克):";
    [newItemBGView addSubview:carWeightLabel];
    [carWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carAndItemWeightField.mas_right).offset(80);
        make.centerY.equalTo(carAndItemWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carWeightField = [DCConstant detailField:self isNumber:YES];
    self.carWeightField.placeholder = @"请输入车皮重量";
    [newItemBGView addSubview:self.carWeightField];
    [self.carWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo (carWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndItemWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *itemWeightLabel = [DCConstant descriptionLabel];
    itemWeightLabel.text = @"净重量(千克):";
    [newItemBGView addSubview:itemWeightLabel];
    [itemWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newItemBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.itemWeightField = [DCConstant detailField:self isNumber:YES];
    self.itemWeightField.placeholder = @"请输入净重量";
    [newItemBGView addSubview:self.itemWeightField];
    [self.itemWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (itemWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(itemWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *itemPricePerKGLabel = [DCConstant descriptionLabel];
    itemPricePerKGLabel.text = @"单价(元/吨):";
    [newItemBGView addSubview:itemPricePerKGLabel];
    [itemPricePerKGLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.itemWeightField.mas_right).offset(80);
        make.centerY.equalTo(itemWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.itemPricePerKGField = [DCConstant detailField:self isNumber:YES];
    if (self.itemType == ItemEntity_Type_Stone) {
        self.itemPricePerKGField.placeholder = @"请输入石头单价";
    }
    else if (self.itemType == ItemEntity_Type_Coal)
    {
        self.itemPricePerKGField.placeholder = @"请输入煤炭单价";
    }
    else if (self.itemType == ItemEntity_Type_Lime){
        self.itemPricePerKGField.placeholder = @"请输入石灰单价";
    }
    
    [newItemBGView addSubview:self.itemPricePerKGField];
    [self.itemPricePerKGField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (itemPricePerKGLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(itemWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *itemTotalPriceLabel = [DCConstant descriptionLabel];
    itemTotalPriceLabel.text = @"总金额(元):";
    [newItemBGView addSubview:itemTotalPriceLabel];
    [itemTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newItemBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.itemTotalPriceField = [DCConstant detailField:self isNumber:YES];
    self.itemTotalPriceField.placeholder = @"请输入总金额";
    [newItemBGView addSubview:self.itemTotalPriceField];
    [self.itemTotalPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (itemTotalPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(itemTotalPriceLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *payedPriceLabel = [DCConstant descriptionLabel];
    payedPriceLabel.text = @"已付金额(元):";
    [newItemBGView addSubview:payedPriceLabel];
    [payedPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemTotalPriceLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newItemBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.payedPriceField = [DCConstant detailField:self isNumber:YES];
    self.payedPriceField.placeholder = @"请输入已付金额";
    [newItemBGView addSubview:self.payedPriceField];
    [self.payedPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (payedPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(payedPriceLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *notPayedPriceLabel = [DCConstant descriptionLabel];
    notPayedPriceLabel.text = @"未付金额(元):";
    [newItemBGView addSubview:notPayedPriceLabel];
    [notPayedPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payedPriceLabel.mas_centerY);
        make.left.equalTo(self.payedPriceField.mas_right).offset(80);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.notPayedPriceField = [DCConstant detailField:self isNumber:YES];
    self.notPayedPriceField.placeholder = @"请输入未付金额";
    [newItemBGView addSubview:self.notPayedPriceField];
    [self.notPayedPriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (notPayedPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(payedPriceLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [newItemBGView addSubview:saveButton];
    saveButton.layer.borderWidth = 1;
    saveButton.layer.borderColor = [BUTTON_COLOR CGColor];
    saveButton.layer.cornerRadius = 40 * 0.5;
    [saveButton addTarget:self action:@selector(saveEntity:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payedPriceLabel.mas_bottom).offset(40);
        make.left.equalTo(newItemBGView.mas_left).offset(EdgeMargin);
        make.bottom.equalTo(newItemBGView.mas_bottom).offset(-EdgeMargin);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [newItemBGView addSubview:deleteButton];
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
    
    if (self.itemBuyEntity) {
        self.dateField.text = [DCConstant stringFromDate:self.itemBuyEntity.createDate];
        self.carNumberField.text = self.itemBuyEntity.carNumber;
        self.buyerNameField.text = self.itemBuyEntity.buyerName;
        self.itemWeightField.text = self.itemBuyEntity.itemWeightString;
        self.carAndItemWeightField.text = self.itemBuyEntity.carAndItemWeightString;
        self.carWeightField.text = self.itemBuyEntity.carWeightString;
        self.itemPricePerKGField.text = self.itemBuyEntity.itemPricePerKGString;
        self.itemTotalPriceField.text = self.itemBuyEntity.itemTotalPriceString;
        self.payedPriceField.text = self.itemBuyEntity.payedPriceString;
        self.notPayedPriceField.text = self.itemBuyEntity.notPayedPriceString;
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
    if (textField == self.carAndItemWeightField || textField == self.carWeightField) {
        if (self.carWeightField.text.length > 0 && self.carAndItemWeightField.text.length > 0) {
            self.itemWeightField.text = [NSString stringWithFormat:@"%@",@([self.carAndItemWeightField.text integerValue] - [self.carWeightField.text integerValue])];
            if (self.itemPricePerKGField.text.length >0 ) {
                self.itemTotalPriceField.text = [NSString stringWithFormat:@"%@", @(self.itemWeightField.text.integerValue * self.itemPricePerKGField.text.integerValue * 0.001)];
                
                if (self.payedPriceField.text.length == 0 && self.notPayedPriceField.text.length == 0) {
                    self.payedPriceField.text = @"0";
                    self.notPayedPriceField.text = self.itemTotalPriceField.text;
                }
            }
        }
    }
    
    if (textField == self.itemPricePerKGField && self.itemWeightField.text.length >0) {
        NSInteger price = self.itemWeightField.text.integerValue * self.itemPricePerKGField.text.integerValue /1000;
        self.itemTotalPriceField.text = [NSString stringWithFormat:@"%@", @(price)];
    }
    
    if (textField == self.payedPriceField || textField == self.itemTotalPriceField) {
        if (self.itemTotalPriceField.text.length > 0 && self.payedPriceField.text.length > 0) {
            self.notPayedPriceField.text = [NSString stringWithFormat:@"%@", @(self.itemTotalPriceField.text.integerValue - self.payedPriceField.text.integerValue)];
        }
    }
}

- (void)saveEntity:(id)sender
{
    if (self.carNumberField.text.length == 0 ) {
        UIAlertController *alert = [UIAlertController dc_alertControllerWithTitle:@"请输入车牌" message:nil actionTitle:@"OK" handler:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.buyerNameField.text.length == 0 ) {
        UIAlertController *alert = [UIAlertController dc_alertControllerWithTitle:@"请输入客户姓名" message:nil actionTitle:@"OK" handler:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    BOOL isNewRecord = NO;
    if (!self.itemBuyEntity) {
        self.itemBuyEntity = [[BaseItemEntity alloc] init];
        isNewRecord = YES;
    }
    
    if (!self.itemBuyEntity.createDate) {
        self.itemBuyEntity.createDate = [NSDate date];
    }
    self.itemBuyEntity.itemType = @(self.itemType);
    self.itemBuyEntity.carNumber = [DCConstant getString:self.carNumberField.text];
    self.itemBuyEntity.buyerName = [DCConstant getString:self.buyerNameField.text];
    self.itemBuyEntity.itemWeight = [DCConstant getIntegerNumber:self.itemWeightField.text];
    self.itemBuyEntity.carWeight = [DCConstant getIntegerNumber:self.carWeightField.text];
    self.itemBuyEntity.carAndItemWeight = [DCConstant getIntegerNumber:self.carAndItemWeightField.text];
    self.itemBuyEntity.itemPricePerKG = [DCConstant getIntegerNumber:self.itemPricePerKGField.text];
    self.itemBuyEntity.itemTotalPrice = [DCConstant getIntegerNumber:self.itemTotalPriceField.text];
    self.itemBuyEntity.payedPrice = [DCConstant getIntegerNumber:self.payedPriceField.text];
    self.itemBuyEntity.notPayedPrice = [DCConstant getIntegerNumber:self.notPayedPriceField.text];
    
    if (isNewRecord) {
        [[DCCoreDataManager sharedInstance] addBuyItemData:self.itemBuyEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
    else{
        [[DCCoreDataManager sharedInstance] updateBuyItemData:self.itemBuyEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
}

- (void)deleteEntity:(id)sender
{
    if (!self.itemBuyEntity) {
        return;
    }
    
    [[DCCoreDataManager sharedInstance] deleteBuyItemData:self.itemBuyEntity complete:^(NSString *errorString) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateItemBuyEntityNotificationKey object:@(self.itemType)];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

- (void)cancelButtonDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

@interface DCBaseItemDailyBuyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BaseItemEntity *currentItemEntity;

@property(nonatomic, strong) NSArray<NSArray *>*itemBuyArray;
@end

@implementation DCBaseItemDailyBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"记录"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addLeftBarItemWithTitle:@"新增记录" target:self action:@selector(createNewRecord:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadItemBuyData:self.itemType];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:UpdateItemBuyEntityNotificationKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createNewRecord:(id)sender
{
    DCUpdateItemBuyEntityViewController *updateVC = [[DCUpdateItemBuyEntityViewController alloc] initWithItemBuyEntity:nil itemType:self.itemType];
    [self presentViewController:updateVC animated:YES completion:nil];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemBuyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subArray = self.itemBuyArray[section];
    return subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCItemBuyEntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DCItemBuyEntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *subArray = self.itemBuyArray[indexPath.section];
    BaseItemEntity *entity = subArray[indexPath.row];
    [cell updateCellWithItemBuyEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArray = self.itemBuyArray[indexPath.section];
    BaseItemEntity *entity = subArray[indexPath.row];
    DCUpdateItemBuyEntityViewController *updateVC = [[DCUpdateItemBuyEntityViewController alloc] initWithItemBuyEntity:entity itemType:[entity.itemType integerValue]];
    [self presentViewController:updateVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TableViewHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *subArray = self.itemBuyArray[section];
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

- (UIView *)createTableViewHeaderView:(NSArray *)itemBuyArray
{
    BaseItemEntity *entity = [itemBuyArray firstObject];
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
    
    UILabel *itemWeightLabel = [DCConstant descriptionLabelInHeaderView];
    itemWeightLabel.text = @"净重量(千克):";
    [view addSubview:itemWeightLabel];
    [itemWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buyerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *itemTotalPriceLabel = [DCConstant descriptionLabelInHeaderView];
    itemTotalPriceLabel.text = @"总价(元):";
    [view addSubview:itemTotalPriceLabel];
    [itemTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *notPayedPriceLabel = [DCConstant descriptionLabelInHeaderView];
    notPayedPriceLabel.text = @"未付金额(元):";
    [view addSubview:notPayedPriceLabel];
    [notPayedPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemTotalPriceLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    return view;
}

- (void)updateData:(NSNotification *)note
{
    ItemEntity_Type type = [note.object integerValue];
    if (type == self.itemType) {
        [self loadItemBuyData:type];
    }
}

- (void)loadItemBuyData:(ItemEntity_Type)type
{
    [[DCCoreDataManager sharedInstance] loadBuyItemData:type complete:^(NSArray *itemArray) {
        self.itemBuyArray = [NSArray arrayWithArray:itemArray];
        [self.tableView reloadData];
    }];
}
@end

