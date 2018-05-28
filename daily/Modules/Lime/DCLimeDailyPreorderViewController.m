//
//  DCLimeDailyPreorderViewController.m
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCLimeDailyPreorderViewController.h"
#import "UINavigationItem+DC.h"
#import "DCCoreDataManager.h"
#import "UIAlertController+DC.h"
#import "UIViewController+DC.h"
#import "DCNotificationManager.h"
#import "DCPlateKeyBoardView.h"
#import "DCBaseUpdateEntityViewController.h"
#import "DCSearchCarAndUserManager.h"

@interface DCPreorderLimeEntityTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *buyerNameLabel;
@property (nonatomic, strong) UILabel *limeWeightLabel;
@property (nonatomic, strong) UILabel *limeTotalPriceLabel;
@property (nonatomic, strong) UILabel *notPayedPriceLabel;
@end

@implementation DCPreorderLimeEntityTableViewCell
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
        limeWeightLabel.text = @"重量(千克):";
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
    }
    return self;
}

- (void)updateCellWithPreorderLimeEntity:(PreorderLimeEntity *)entity
{
    self.dateLabel.text = [DCConstant hourAndMinuteStringFromDate:entity.createDate];
    self.buyerNameLabel.text = entity.buyerName;
    self.limeWeightLabel.text = [entity limeWeightString];
    self.limeTotalPriceLabel.text = entity.carNumber;
}

@end

@interface DCUpdatePreorderLimeEntityViewController: DCBaseUpdateEntityViewController<UISearchBarDelegate>
@property (nonatomic, strong) PreorderLimeEntity *preorderLimeEntity;
//Add new lime
@property (nonatomic, assign) ItemEntity_Type itemType;
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) UITextField *carNumberField;
@property (nonatomic, strong) UITextField *buyerNameField;
@property (nonatomic, strong) UITextField *limeWeightField;

@property (nonatomic, strong) DCPlateKeyBoardView *keyBoardView;

@property (nonatomic, strong) DCSearchCarAndUserManager *searchManager;
@end

@implementation DCUpdatePreorderLimeEntityViewController

- (instancetype)initWithPreorderLimeEntity:(PreorderLimeEntity *)preorderLimeEntity
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.preorderLimeEntity = preorderLimeEntity;
        [self dc_setPresentAsPopup:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *newLabel = [DCConstant descriptionLabel];
    newLabel.text = self.preorderLimeEntity ? @"更新记录" : @"新增记录：";
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
    
    self.dateField = [DCConstant detailField:self isNumber:NO];
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
    
    self.carNumberField = [DCConstant detailField:self isNumber:NO];
    self.carNumberField.placeholder = @"请输入车牌";
    self.carNumberField.tag = UpdateEntity_Type_LimeCarNumber;
    [newLimeBGView addSubview:self.carNumberField];
    [self.carNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carNumberLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
    }];
    self.keyBoardView = [[DCPlateKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.4)];
    self.carNumberField.inputView = self.keyBoardView;
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
    };
    
    UILabel *buyerNameLabel = [DCConstant descriptionLabel];
    buyerNameLabel.text = @"客户:";
    [newLimeBGView addSubview:buyerNameLabel];
    [buyerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.carNumberField.mas_right).offset(80);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.buyerNameField = [DCConstant detailField:self isNumber:NO];
    self.buyerNameField.placeholder = @"请输入客户姓名";
    [newLimeBGView addSubview:self.buyerNameField];
    [self.buyerNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (buyerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carNumberLabel.mas_centerY);
        make.width.equalTo(@(DetailFieldWidth));
        make.right.equalTo(newLimeBGView.mas_right).offset(-EdgeMargin);
    }];
    
    UILabel *carAndLimeWeightLabel = [DCConstant descriptionLabel];
    carAndLimeWeightLabel.text = @"重量(千克):";
    [newLimeBGView addSubview:carAndLimeWeightLabel];
    [carAndLimeWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carNumberLabel.mas_bottom).offset(LineSpace);
        make.left.equalTo(newLimeBGView.mas_left).offset(EdgeMargin);
        make.width.equalTo(@(DescriptionLablelWidth));
    }];
    
    self.limeWeightField = [DCConstant detailField:self isNumber:YES];
    self.limeWeightField.placeholder = @"请输入重量";
    [newLimeBGView addSubview:self.limeWeightField];
    [self.limeWeightField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (carAndLimeWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(carAndLimeWeightLabel.mas_centerY);
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
        make.top.equalTo(carAndLimeWeightLabel.mas_bottom).offset(40);
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
    
    if (self.preorderLimeEntity) {
        self.dateField.text = [DCConstant stringFromDate:self.preorderLimeEntity.createDate];
        self.carNumberField.text = self.preorderLimeEntity.carNumber;
        self.buyerNameField.text = self.preorderLimeEntity.buyerName;
        self.limeWeightField.text = self.preorderLimeEntity.limeWeightString;
    }
    else{
        self.dateField.text = [DCConstant stringFromDate:[NSDate date]];
    }
    
    self.searchManager = [[DCSearchCarAndUserManager alloc] initWithSearchType:[DCConstant getCustomerEntityTypeWithItemType:self.itemType]];
    self.searchManager.selectHandle = ^(CustomerEntity *customer) {
        weakSelf.carNumberField.text = customer.carNumber;
        weakSelf.buyerNameField.text = customer.name;
        [weakSelf.searchManager.searchBar resignFirstResponder];
    };
    [self.bgView addSubview:self.searchManager.searchBar];
    self.searchManager.searchBar.delegate = self;
    [self.searchManager.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newLabel.mas_centerY);
        make.left.equalTo(newLabel.mas_right).offset(EdgeMargin);
        make.right.equalTo(cancelButton.mas_left).offset(-EdgeMargin);
    }];
    
    [self.bgView addSubview:self.searchManager.tableView];
    [self.searchManager.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchManager.searchBar.mas_bottom);
        make.left.equalTo(newLabel.mas_right).offset(EdgeMargin);
        make.right.equalTo(cancelButton.mas_left).offset(-EdgeMargin);
        make.height.equalTo(@(DCSearchTableViewHeight));
    }];
    [self.searchManager reloadData:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"");
    [self.searchManager prefillResultsWithKey:searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"");
    self.searchManager.tableView.hidden = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"");
    [self.searchManager prefillResultsWithKey:searchBar.text];
}

- (void)saveEntity:(id)sender
{
    if (self.carNumberField.text.length == 0) {
        UIAlertController *alert = [UIAlertController dc_alertControllerWithTitle:@"Please input car number" message:nil actionTitle:@"OK" handler:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    BOOL isNewRecord = NO;
    if (!self.preorderLimeEntity) {
        self.preorderLimeEntity = [[PreorderLimeEntity alloc] init];
        isNewRecord = YES;
    }
    
    if (!self.preorderLimeEntity.createDate) {
        self.preorderLimeEntity.createDate = [NSDate date];
    }
    
    self.preorderLimeEntity.carNumber = self.carNumberField.text;
    self.preorderLimeEntity.buyerName = self.buyerNameField.text;
    self.preorderLimeEntity.limeWeight = @([self.limeWeightField.text integerValue]);
    
    if (isNewRecord) {
        [[DCCoreDataManager sharedInstance] addPreorderLimeData:self.preorderLimeEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
    else{
        [[DCCoreDataManager sharedInstance] updatePreorderLimeData:self.preorderLimeEntity complete:^(NSString *errorString) {
            [self finishAction:errorString];
        }];
    }
}

- (void)deleteEntity:(id)sender
{
    [[DCCoreDataManager sharedInstance] deletePreorderLimeData:self.preorderLimeEntity complete:^(NSString *errorString) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdatePreorderLimeEntityNotificationKey object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

- (void)cancelButtonDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

@interface DCLimeDailyPreorderViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PreorderLimeEntity *currentLimeEntity;

@property(nonatomic, strong) NSArray<NSArray *>*preorderLimeArray;
@end

@implementation DCLimeDailyPreorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"石灰预订记录"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addLeftBarItemWithTitle:@"新增记录" target:self action:@selector(createNewRecord:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadPreorderLimeData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:UpdatePreorderLimeEntityNotificationKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createNewRecord:(id)sender
{
    DCUpdatePreorderLimeEntityViewController *updateVC = [[DCUpdatePreorderLimeEntityViewController alloc] initWithPreorderLimeEntity:nil];
    updateVC.itemType = ItemEntity_Type_Lime;
    [self presentViewController:updateVC animated:YES completion:nil];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.preorderLimeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subArray = self.preorderLimeArray[section];
    return subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCPreorderLimeEntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DCPreorderLimeEntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *subArray = self.preorderLimeArray[indexPath.section];
    PreorderLimeEntity *entity = subArray[indexPath.row];
    [cell updateCellWithPreorderLimeEntity:entity];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArray = self.preorderLimeArray[indexPath.section];
    PreorderLimeEntity *entity = subArray[indexPath.row];
    DCUpdatePreorderLimeEntityViewController *updateVC = [[DCUpdatePreorderLimeEntityViewController alloc] initWithPreorderLimeEntity:entity];
    [self presentViewController:updateVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TableViewHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *subArray = self.preorderLimeArray[section];
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

- (UIView *)createTableViewHeaderView:(NSArray *)preorderLimeArray
{
    PreorderLimeEntity *entity = [preorderLimeArray firstObject];
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
    limeWeightLabel.text = @"重量(千克):";
    [view addSubview:limeWeightLabel];
    [limeWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buyerNameLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    UILabel *limeTotalPriceLabel = [DCConstant descriptionLabelInHeaderView];
    limeTotalPriceLabel.text = @"车牌:";
    [view addSubview:limeTotalPriceLabel];
    [limeTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(limeWeightLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    return view;
}

- (void)updateData:(NSNotification *)note
{
    [self loadPreorderLimeData];
}

- (void)loadPreorderLimeData
{
    [[DCCoreDataManager sharedInstance] loadPreorderLimeData:^(NSArray *limeArray) {
        self.preorderLimeArray = [NSArray arrayWithArray:limeArray];
        [self.tableView reloadData];
    }];
}
@end

