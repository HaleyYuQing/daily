//
//  DCColaDailyUseViewController.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCCoalDailyUseViewController.h"
#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"

#define EdgeMargin  20
#define LineSpace   10

@interface DCColaDailyUseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BuyCoalEntity *currentCoalEntity;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *buyCoalArray;

//Add new coal
@property (nonatomic, strong) UITextField *carNumberField;
@property (nonatomic, strong) UITextField *carWeightField;
@property (nonatomic, strong) UITextField *carAndCoalWeightField;
@property (nonatomic, strong) UITextField *coalWeightField;
@property (nonatomic, strong) UITextField *coalPricePerKGField;
@end

@implementation DCColaDailyUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"Detail"];
    
    UIView *newCoalBGView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:newCoalBGView];
    [newCoalBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
    }];
    
    UILabel *carNumberLabel = [UILabel new];
    carNumberLabel.text = @"CarNumber:";
    [newCoalBGView addSubview:carNumberLabel];
    [carNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newCoalBGView.mas_top).offset(EdgeMargin);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
    }];
    
    self.carNumberField = [UITextField new];
    self.carNumberField.placeholder = @"CarNumber";
    [newCoalBGView addSubview:self.carNumberField];
    [self.carNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carNumberLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(100));
    }];
    
    UILabel *carWeightLabel = [UILabel new];
    carWeightLabel.text = @"CarWeight:";
    [newCoalBGView addSubview:carWeightLabel];
    [carWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carNumberLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
    }];
    
    self.carWeightField = [UITextField new];
    self.carWeightField.placeholder = @"CarWeight";
    [newCoalBGView addSubview:self.carWeightField];
    [self.carWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carWeightLabel.mas_centerY);
        make.width.equalTo(@(100));
    }];
    
    UILabel *carAndCoalWeightLabel = [UILabel new];
    carAndCoalWeightLabel.text = @"CarAndCoalWeight:";
    [newCoalBGView addSubview:carAndCoalWeightLabel];
    [carAndCoalWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carWeightLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
    }];
    
    self.carAndCoalWeightField = [UITextField new];
    self.carAndCoalWeightField.placeholder = @"CarAndCoalWeight";
    [newCoalBGView addSubview:self.carAndCoalWeightField];
    [self.carAndCoalWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carAndCoalWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndCoalWeightLabel.mas_centerY);
        make.width.equalTo(@(100));
    }];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [newCoalBGView addSubview:saveButton];
    saveButton.layer.borderWidth = 1;
    saveButton.layer.borderColor = [BUTTON_COLOR CGColor];
    saveButton.layer.cornerRadius = 40 * 0.5;
    [saveButton addTarget:self action:@selector(saveEntity:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carAndCoalWeightLabel.mas_bottom).offset(20);
        make.left.equalTo(newCoalBGView.mas_left).offset(EdgeMargin);
        make.bottom.equalTo(newCoalBGView.mas_bottom).offset(-EdgeMargin);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
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
