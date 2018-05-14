//
//  DCTabbarViewController.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCTabbarViewController.h"
#import "DCCoalSplitViewController.h"
#import "DCLimeSplitViewController.h"
#import "UIColor+DC.h"

@interface DCTabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation DCTabbarViewController

+(instancetype)sharedInstance
{
    static DCTabbarViewController *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DCTabbarViewController alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        DCCoalSplitViewController *coalVC = [[DCCoalSplitViewController alloc] init];
        DCLimeSplitViewController *limeVC = [[DCLimeSplitViewController alloc] init];
        
        self.viewControllers =@[coalVC, limeVC];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 0;
    
    UIFont *tabbarTitleFont = [UIFont boldSystemFontOfSize:16];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: tabbarTitleFont} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: tabbarTitleFont}
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -1)];
    
    [self.tabBar setTintColor:[UIColor colorWithHex:@"FBCB71"]];
    [self.tabBar setBarTintColor:[UIColor colorWithHex:@"0E404E"]];
    [self.tabBar setUnselectedItemTintColor:[UIColor whiteColor]];
    [self.tabBar setValue:@YES forKey:@"_hidesShadow"];
    
    [self setDelegate:self];
}

- (UINavigationController *)embedNav:(UIViewController *)vc {
    return [[UINavigationController alloc] initWithRootViewController:vc];
}

@end
