//
//  DCCoalDailyBuyViewController.m
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCCoalDailyBuyViewController.h"
#import "UINavigationItem+DC.h"

@interface DCCoalDailyBuyViewController ()

@end

@implementation DCCoalDailyBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"煤炭购买记录"];
    
    self.itemType = ItemEntity_Type_Coal;
}
@end
