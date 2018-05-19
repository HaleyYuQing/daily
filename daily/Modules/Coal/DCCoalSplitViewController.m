//
//  DCCoalSplitViewController.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCCoalSplitViewController.h"
#import "DCCoalMenuViewController.h"

@interface DCCoalSplitViewController ()
@property (nonatomic, strong)DCCoalMenuViewController *menu;
@end

@implementation DCCoalSplitViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        DCCoalMenuViewController *menu = [[DCCoalMenuViewController alloc] init];
        self.menu = menu;
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        self.viewControllers = @[[DCConstant embedNav:menu], nvc];
        
        [DCConstant setViewController:self tabbarTitle:@"煤炭" imageName:@"coal" selectedImageName:@"coal"];
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
        [self.menu showViewControllerWithMenu:DCCoalMenu_Use];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
