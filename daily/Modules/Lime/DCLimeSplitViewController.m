//
//  DCLimeSplitViewController.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCLimeSplitViewController.h"
#import "DCLimeMenuViewController.h"
#import "DCConstant.h"
#import "UINavigationItem+DC.h"

@interface DCLimeSplitViewController ()
@property (nonatomic, strong)DCLimeMenuViewController *menu;
@end

@implementation DCLimeSplitViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        DCLimeMenuViewController *menu = [[DCLimeMenuViewController alloc] init];
        self.menu = menu;
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        self.viewControllers = @[[DCConstant embedNav:menu], nvc];
        
        [DCConstant setViewController:self tabbarTitle:@"石灰" imageName:@"lime" selectedImageName:@"lime"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.menu currentMenu] == DCMenu_NotFound) {
        [self.menu showViewControllerWithMenu:DCLimeMenu_Sell];
    }
}

@end
