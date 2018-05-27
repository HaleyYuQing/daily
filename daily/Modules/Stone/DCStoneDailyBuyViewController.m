//
//  DCStoneDailyBuyViewController.m
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCStoneDailyBuyViewController.h"
#import "UINavigationItem+DC.h"

@interface DCStoneDailyBuyViewController ()

@end

@implementation DCStoneDailyBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"石头购买记录"];
    
    self.itemType = ItemEntity_Type_Stone;
}

@end

