//
//  DCBaseViewController.m
//  daily
//
//  Created by yuqing huang on 17/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCBaseViewController.h"

@interface DCBaseViewController ()

@end

@implementation DCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
