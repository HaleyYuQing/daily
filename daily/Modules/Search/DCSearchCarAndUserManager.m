//
//  DCSearchCarAndUserManagerm
//  daily
//
//  Created by yuqing huang on 27/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCSearchCarAndUserManager.h"
#import "CustomerEntity.h"
#import "DCCoreDataManager.h"

@interface DCCustomerEntityTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *buyerNameLabel;
@property (nonatomic, strong) UILabel *carNumberLabel;
@end

@implementation DCCustomerEntityTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.carNumberLabel = [DCConstant detailLabel];
        [self.contentView addSubview:self.carNumberLabel];
        [self.carNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
        
        UILabel *buyerNameLabel = [DCConstant detailLabel];
        self.buyerNameLabel = buyerNameLabel;
        buyerNameLabel.text = @"客户:";
        [self.contentView addSubview:buyerNameLabel];
        [buyerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carNumberLabel.mas_right).offset(EdgeMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
        }];
    }
    return self;
}

- (void)updateCellWithCustomerEntity:(CustomerEntity *)entity
{
    self.buyerNameLabel.text = entity.name;
    self.carNumberLabel.text = entity.carNumber;
}

@end

@interface DCSearchCarAndUserManager ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic ,strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<CustomerEntity *> *resultsArray;
@property (nonatomic, assign) CustomerType type;
@end

@implementation DCSearchCarAndUserManager

- (instancetype)initWithSearchType:(CustomerType)type
{
    self = [super init];
    if (self) {
        self.type = type;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.bounces = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.searchBar = [[UISearchBar alloc] init];
        self.searchBar.placeholder = @"输入车牌或者姓名搜索";
        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return self;
}

- (void)reloadData:(NSArray *)results
{
    self.resultsArray = results;
    self.tableView.hidden = self.resultsArray.count == 0;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCCustomerEntityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DCCustomerEntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell updateCellWithCustomerEntity:[self.resultsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectHandle) {
        self.selectHandle(self.resultsArray[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createTableViewHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)createTableViewHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, TableViewHeaderViewHeight)];
    view.backgroundColor = [UIColor colorWithHex:@"0E404E"];
    
    UILabel *carNumberLabel = [DCConstant descriptionLabelInHeaderView];
    carNumberLabel.text = @"车牌:";
    [view addSubview:carNumberLabel];
    [carNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];

    UILabel *buyerNameLabel = [DCConstant descriptionLabelInHeaderView];
    buyerNameLabel.text = @"客户:";
    [view addSubview:buyerNameLabel];
    [buyerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(carNumberLabel.mas_right).offset(EdgeMargin);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@(DescriptionLabelWidthInHeaderView));
    }];
    
    return view;
}

- (void)prefillResultsWithKey:(NSString *)key
{
    if (self.type == CustomerType_Lime) {
        __block NSMutableArray *results = [[NSMutableArray alloc] init];
        [[[DCCoreDataManager sharedInstance] getLimeCustomer] enumerateObjectsUsingBlock:^(CustomerEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.name lowercaseString] containsString:[key lowercaseString]] || [[obj.carNumber lowercaseString] containsString:[key lowercaseString]] || key.length == 0) {
                [results addObject:obj];
            }
        }];
        
        [self reloadData:results];
    }
    
    if (self.type == CustomerType_Stone) {
        __block NSMutableArray *results = [[NSMutableArray alloc] init];
        [[[DCCoreDataManager sharedInstance] getStoneCustomer] enumerateObjectsUsingBlock:^(CustomerEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.name lowercaseString] containsString:[key lowercaseString]] || [[obj.carNumber lowercaseString] containsString:[key lowercaseString]] || key.length == 0) {
                [results addObject:obj];
            }
        }];
        
        [self reloadData:results];
    }
    
    if (self.type == CustomerType_Coal) {
        __block NSMutableArray *results = [[NSMutableArray alloc] init];
        [[[DCCoreDataManager sharedInstance] getCoalCustomer] enumerateObjectsUsingBlock:^(CustomerEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.name lowercaseString] containsString:[key lowercaseString]] || [[obj.carNumber lowercaseString] containsString:[key lowercaseString]] || key.length == 0) {
                [results addObject:obj];
            }
        }];
        
        [self reloadData:results];
    }
}
@end
