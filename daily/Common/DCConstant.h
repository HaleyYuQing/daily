//
//  DCConstant.h
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DCConstant : NSObject

+ (void)setViewController:(UIViewController *)viewController tabbarTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

+ (UINavigationController *)embedNav:(UIViewController *)vc;

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)monthAndDayStringFromDate:(NSDate *)date;
+ (NSString *)hourAndMinuteStringFromDate:(NSDate *)date;
+ (BOOL)compareIsSameDay:(NSDate *)firstDate nextDate:(NSDate *)nextDate;
+ (UILabel *)detailLabel;
+ (UITextField *)detailField:(id)delegate;
+ (UILabel *)descriptionLabel;
+ (UILabel *)descriptionLabelInHeaderView;
@end
