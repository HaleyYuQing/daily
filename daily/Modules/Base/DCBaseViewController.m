//
//  DCBaseViewController.m
//  daily
//
//  Created by yuqing huang on 17/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCBaseViewController.h"

@interface DCBaseViewController ()
@property(nonatomic, strong) DCBaseTableView *tableView;
@end

@implementation DCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[DCBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addLeftBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:title  style:UIBarButtonItemStylePlain target:target action:action];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}
@end
