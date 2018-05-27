//
//  DCSearchCarAndUserViewController.m
//  daily
//
//  Created by yuqing huang on 27/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCSearchCarAndUserViewController.h"
#import "CustomerEntity.h"

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

@interface DCSearchResultsViewController()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<CustomerEntity *> *resultsArray;
@end

@implementation DCSearchResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)reloadData:(NSArray *)results
{
    self.resultsArray = results;
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
}
@end

@interface DCSearchCarAndUserViewController ()<UISearchBarDelegate, UISearchResultsUpdating>
@property (nonatomic, assign) CustomerType type;
@end

@implementation DCSearchCarAndUserViewController

- (instancetype)initWithSearchType:(CustomerType)type searchResultsViewController:(UIViewController *)resultsVC
{
    self = [super initWithSearchResultsController:resultsVC];
    if (self) {
        self.type = type;
        
    }
    return self;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"");
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"");
}
@end
