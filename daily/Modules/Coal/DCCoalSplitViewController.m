//
//  DCCoalSplitViewController.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCCoalSplitViewController.h"
#import "DCCoalMenuViewController.h"
#import "DCConstant.h"

@interface DCCoalSplitViewController ()

@end

@implementation DCCoalSplitViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        DCCoalMenuViewController *menu = [[DCCoalMenuViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        nvc.navigationBar.hidden = YES;
        self.viewControllers = @[menu, nvc];
        
        [DCConstant setViewController:self tabbarTitle:@"Coal" imageName:@"coal" selectedImageName:@"coal"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
