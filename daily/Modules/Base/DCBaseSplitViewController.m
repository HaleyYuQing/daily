//
//  DCBaseSplitViewController.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCBaseSplitViewController.h"

@interface DCBaseSplitViewController ()

@end

@implementation DCBaseSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showRightViewController:(UIViewController *)vc
{
    UINavigationController *baseVC = self.viewControllers[1];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [baseVC popToRootViewControllerAnimated:NO];
    [baseVC pushViewController:vc animated:NO];
}
@end
