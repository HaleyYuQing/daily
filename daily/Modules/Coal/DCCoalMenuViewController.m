//
//  DCCoalMenuViewController.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCCoalMenuViewController.h"

@interface DCCoalMenuViewController ()
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation DCCoalMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Menu";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
