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

@interface DCLimeSplitViewController ()

@end

@implementation DCLimeSplitViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        DCLimeMenuViewController *menu = [[DCLimeMenuViewController alloc] init];
        
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        nvc.navigationBar.hidden = YES;
        
        self.viewControllers = @[menu, nvc];
        
        [DCConstant setViewController:self tabbarTitle:@"Lime" imageName:@"lime" selectedImageName:@"lime"];
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
