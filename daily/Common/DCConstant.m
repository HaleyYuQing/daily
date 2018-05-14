//
//  DCConstant.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCConstant.h"

@implementation DCConstant

+ (void)setViewController:(UIViewController *)viewController tabbarTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                     selectedImage:[[UIImage imageNamed:selectedImageName]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    [tabBarItem setImageInsets:UIEdgeInsetsMake(3, 0, -3, 0)];
    [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    [viewController setTabBarItem:tabBarItem];
}

@end
