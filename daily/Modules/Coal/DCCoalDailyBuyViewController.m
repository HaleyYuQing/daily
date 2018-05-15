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

#define EdgeMargin  20
#define LineSpace   20
#define DescriptionLablelWidth   80
#define DetailFieldWidth     160

@interface DCUpdateBuyCoalEntityViewController: UIViewController
@property (nonatomic, strong) BuyCoalEntity *buyCoalEntity;
//Add new coal
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) UITextField *carNumberField;
@property (nonatomic, strong) UITextField *carOwnerNameField;
@property (nonatomic, strong) UITextField *carWeightField;
@property (nonatomic, strong) UITextField *carAndCoalWeightField;
@property (nonatomic, strong) UITextField *coalWeightField;
@property (nonatomic, strong) UITextField *coalPricePerKGField;
@property (nonatomic, strong) UITextField *coalTotalPriceField;
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
    UIView *bgView = [UIView new];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    UILabel *newLabel = [UILabel new];
    newLabel.text = @"新增记录：";
    [bgView addSubview:newLabel];
    [newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(EdgeMargin);
        make.left.equalTo(self.view.mas_left).offset(EdgeMargin);
    }];
    
    UIView *newCoalBGView = [[UIView alloc] initWithFrame:CGRectZero];
    newCoalBGView.layer.borderWidth = 1;
    newCoalBGView.layer.borderColor = [BUTTON_COLOR CGColor];
    [self.view addSubview:newCoalBGView];
    [newCoalBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
    }];
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.text = @"日期:";
    [newCoalBGView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newCoalBGView.mas_top).offset(EdgeMargin);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.dateField = [self detailField];
    self.dateField.placeholder = @"点击生成日期";
    [newCoalBGView addSubview:self.dateField];
    [self.dateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(dateLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carNumberLabel = [UILabel new];
    carNumberLabel.text = @"车牌:";
    [newCoalBGView addSubview:carNumberLabel];
    [carNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carNumberField = [self detailField];
    self.carNumberField.placeholder = @"请输入车牌";
    [newCoalBGView addSubview:self.carNumberField];
    [self.carNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carNumberLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carOwnerNameLabel = [UILabel new];
    carOwnerNameLabel.text = @"车主:";
    [newCoalBGView addSubview:carOwnerNameLabel];
    [carOwnerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carNumberField.mas_right).offset(80);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carOwnerNameField = [self detailField];
    self.carOwnerNameField.placeholder = @"请输入车主姓名";
    [newCoalBGView addSubview:self.carOwnerNameField];
    [self.carOwnerNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carOwnerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carAndCoalWeightLabel = [UILabel new];
    carAndCoalWeightLabel.text = @"总重量:";
    [newCoalBGView addSubview:carAndCoalWeightLabel];
    [carAndCoalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carNumberLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carAndCoalWeightField = [self detailField];
    self.carAndCoalWeightField.placeholder = @"请输入总重量";
    [newCoalBGView addSubview:self.carAndCoalWeightField];
    [self.carAndCoalWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carAndCoalWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndCoalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carWeightLabel = [UILabel new];
    carWeightLabel.text = @"车皮重量:";
    [newCoalBGView addSubview:carWeightLabel];
    [carWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carAndCoalWeightField.mas_right).offset(80);
        make.centerY.equalTo(carAndCoalWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carWeightField = [self detailField];
    self.carWeightField.placeholder = @"请输入车皮重量";
    [newCoalBGView addSubview:self.carWeightField];
    [self.carWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo (carWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndCoalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *coalWeightLabel = [UILabel new];
    coalWeightLabel.text = @"净重量:";
    [newCoalBGView addSubview:coalWeightLabel];
    [coalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.coalWeightField = [self detailField];
    self.coalWeightField.placeholder = @"请输入净重量";
    [newCoalBGView addSubview:self.coalWeightField];
    [self.coalWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (coalWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *coalPricePerKGLabel = [UILabel new];
    coalPricePerKGLabel.text = @"单价:";
    [newCoalBGView addSubview:coalPricePerKGLabel];
    [coalPricePerKGLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.coalWeightField.mas_right).offset(80);
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.coalPricePerKGField = [self detailField];
    self.coalPricePerKGField.placeholder = @"请输入煤单价";
    [newCoalBGView addSubview:self.coalPricePerKGField];
    [self.coalPricePerKGField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (coalPricePerKGLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *coalTotalPriceLabel = [UILabel new];
    coalTotalPriceLabel.text = @"总价格:";
    [newCoalBGView addSubview:coalTotalPriceLabel];
    [coalTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coalWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.coalTotalPriceField = [self detailField];
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
}

- (UITextField *)detailField
{
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
    field.font = [UIFont systemFontOfSize:14];
    field.borderStyle = UITextBorderStyleRoundedRect;
    
    return field;
}

- (void)saveEntity:(id)sender
{
    if (self.carNumberField.text.length == 0) {
        UIAlertController *alert = [UIAlertController dc_alertControllerWithTitle:@"Please input car number" message:nil actionTitle:@"OK" handler:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (!self.buyCoalEntity) {
        self.buyCoalEntity = [[BuyCoalEntity alloc] init];
    }
    
    if (!self.buyCoalEntity.createDate) {
        self.buyCoalEntity.createDate = [NSDate date];
    }
    
    self.buyCoalEntity.carNumber = self.carNumberField.text;
    self.buyCoalEntity.coalWeight = [self.coalWeightField.text floatValue];
    self.buyCoalEntity.carWeight = [self.carWeightField.text floatValue];
    self.buyCoalEntity.carAndCoalWeight = [self.carAndCoalWeightField.text floatValue];
    
    [[DCCoreDataManager sharedInstance] addBuyCoalData:self.buyCoalEntity];
}
@end

@interface DCCoalDailyBuyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BuyCoalEntity *currentCoalEntity;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *buyCoalArray;

//Add new coal
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) UITextField *carNumberField;
@property (nonatomic, strong) UITextField *carOwnerNameField;
@property (nonatomic, strong) UITextField *carWeightField;
@property (nonatomic, strong) UITextField *carAndCoalWeightField;
@property (nonatomic, strong) UITextField *coalWeightField;
@property (nonatomic, strong) UITextField *coalPricePerKGField;
@property (nonatomic, strong) UITextField *coalTotalPriceField;
@end

@implementation DCCoalDailyBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"购买详情"];
    
    UILabel *newLabel = [UILabel new];
    newLabel.text = @"新增记录：";
    [self.view addSubview:newLabel];
    [newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(EdgeMargin);
        make.left.equalTo(self.view.mas_left).offset(EdgeMargin);
    }];
    
    UIView *newCoalBGView = [[UIView alloc] initWithFrame:CGRectZero];
    newCoalBGView.layer.borderWidth = 1;
    newCoalBGView.layer.borderColor = [BUTTON_COLOR CGColor];
    [self.view addSubview:newCoalBGView];
    [newCoalBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
    }];
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.text = @"日期:";
    [newCoalBGView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newCoalBGView.mas_top).offset(EdgeMargin);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.dateField = [self detailField];
    self.dateField.placeholder = @"点击生成日期";
    [newCoalBGView addSubview:self.dateField];
    [self.dateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (dateLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(dateLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carNumberLabel = [UILabel new];
    carNumberLabel.text = @"车牌:";
    [newCoalBGView addSubview:carNumberLabel];
    [carNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carNumberField = [self detailField];
    self.carNumberField.placeholder = @"请输入车牌";
    [newCoalBGView addSubview:self.carNumberField];
    [self.carNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carNumberLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carOwnerNameLabel = [UILabel new];
    carOwnerNameLabel.text = @"车主:";
    [newCoalBGView addSubview:carOwnerNameLabel];
    [carOwnerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carNumberField.mas_right).offset(80);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carOwnerNameField = [self detailField];
    self.carOwnerNameField.placeholder = @"请输入车主姓名";
    [newCoalBGView addSubview:self.carOwnerNameField];
    [self.carOwnerNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carOwnerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carAndCoalWeightLabel = [UILabel new];
    carAndCoalWeightLabel.text = @"总重量:";
    [newCoalBGView addSubview:carAndCoalWeightLabel];
    [carAndCoalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carNumberLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carAndCoalWeightField = [self detailField];
    self.carAndCoalWeightField.placeholder = @"请输入总重量";
    [newCoalBGView addSubview:self.carAndCoalWeightField];
    [self.carAndCoalWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carAndCoalWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndCoalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *carWeightLabel = [UILabel new];
    carWeightLabel.text = @"车皮重量:";
    [newCoalBGView addSubview:carWeightLabel];
    [carWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carAndCoalWeightField.mas_right).offset(80);
        make.centerY.equalTo(carAndCoalWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.carWeightField = [self detailField];
    self.carWeightField.placeholder = @"请输入车皮重量";
    [newCoalBGView addSubview:self.carWeightField];
    [self.carWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo (carWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndCoalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *coalWeightLabel = [UILabel new];
    coalWeightLabel.text = @"净重量:";
    [newCoalBGView addSubview:coalWeightLabel];
    [coalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.coalWeightField = [self detailField];
    self.coalWeightField.placeholder = @"请输入净重量";
    [newCoalBGView addSubview:self.coalWeightField];
    [self.coalWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (coalWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *coalPricePerKGLabel = [UILabel new];
    coalPricePerKGLabel.text = @"单价:";
    [newCoalBGView addSubview:coalPricePerKGLabel];
    [coalPricePerKGLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.coalWeightField.mas_right).offset(80);
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.coalPricePerKGField = [self detailField];
    self.coalPricePerKGField.placeholder = @"请输入煤单价";
    [newCoalBGView addSubview:self.coalPricePerKGField];
    [self.coalPricePerKGField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (coalPricePerKGLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(coalWeightLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    
    UILabel *coalTotalPriceLabel = [UILabel new];
    coalTotalPriceLabel.text = @"总价格:";
    [newCoalBGView addSubview:coalTotalPriceLabel];
    [coalTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coalWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.coalTotalPriceField = [self detailField];
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(newCoalBGView.mas_bottom).offset(30);
        make.bottom.left.right.equalTo(self.view);
    }];
    
    [[DCCoreDataManager sharedInstance] loadBuyCoalData:^(NSArray *coalArray) {
        self.buyCoalArray = [NSArray arrayWithArray:coalArray];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    NSLog(@"");
}

- (UITextField *)detailField
{
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
    field.font = [UIFont systemFontOfSize:14];
    field.borderStyle = UITextBorderStyleRoundedRect;
    
    return field;
}

- (void)saveEntity:(id)sender
{
    if (self.carNumberField.text.length == 0) {
        UIAlertController *alert = [UIAlertController dc_alertControllerWithTitle:@"Please input car number" message:nil actionTitle:@"OK" handler:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (!self.currentCoalEntity) {
        self.currentCoalEntity = [[BuyCoalEntity alloc] init];
    }
    
    if (!self.currentCoalEntity.createDate) {
        self.currentCoalEntity.createDate = [NSDate date];
    }
    
    self.currentCoalEntity.carNumber = self.carNumberField.text;
    self.currentCoalEntity.coalWeight = [self.coalWeightField.text floatValue];
    self.currentCoalEntity.carWeight = [self.carWeightField.text floatValue];
    self.currentCoalEntity.carAndCoalWeight = [self.carAndCoalWeightField.text floatValue];
    
    [[DCCoreDataManager sharedInstance] addBuyCoalData:self.currentCoalEntity];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.buyCoalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    BuyCoalEntity *entity = self.buyCoalArray[indexPath.row];
    cell.textLabel.text =  [NSString stringWithFormat:@"%@  %@  %@",entity.carNumber, @(entity.carWeight), @(entity.carAndCoalWeight)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"5月12日";
}
@end
