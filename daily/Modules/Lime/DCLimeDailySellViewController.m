//
//  DCLimeDailySellViewController.m
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCLimeDailySellViewController.h"
#import "UINavigationItem+DC.h"

@implementation DCLimeDailySellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem dc_setTitle:@"石灰出售记录"];
    
    self.itemType = ItemEntity_Type_Lime;
}

@end
