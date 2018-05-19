//
//  DCStoneSplitViewController.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCStoneSplitViewController.h"
#import "DCStoneMenuViewController.h"

@interface DCStoneSplitViewController ()
@property (nonatomic, strong)DCStoneMenuViewController *menu;
@end

@implementation DCStoneSplitViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        DCStoneMenuViewController *menu = [[DCStoneMenuViewController alloc] init];
        self.menu = menu;
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        self.viewControllers = @[[DCConstant embedNav:menu], nvc];

        [DCConstant setViewController:self tabbarTitle:@"石头" imageName:@"stone" selectedImageName:@"stone"];
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
        [self.menu showViewControllerWithMenu:DCStoneMenu_Use];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
