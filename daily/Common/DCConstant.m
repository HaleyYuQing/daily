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

+ (UINavigationController *)embedNav:(UIViewController *)vc {
    return [[UINavigationController alloc] initWithRootViewController:vc];
}

+ (BOOL)compareIsSameDay:(NSDate *)firstDate nextDate:(NSDate *)nextDate
{
    NSCalendar *calendar = [DCConstant currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:firstDate];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:nextDate];

    return [cmp1 day] == [cmp2 day];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    // 1.获得年月日
    NSCalendar *calendar = [DCConstant currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    BOOL isToday = NO;
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"HH:mm a";
        isToday = YES;
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MMM dd, HH:mm a";
    } else {
        formatter.dateFormat = @"MMM-dd，yyyy HH:mm a";
    }

    NSString *time = [formatter stringFromDate:date];

    return time;
}

+ (NSString *)monthAndDayStringFromDate:(NSDate *)date
{
    // 1.获得年月日
    NSCalendar *calendar = [DCConstant currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MMM dd";
    } else {
        formatter.dateFormat = @"MMM dd，yyyy";
    }
    
    NSString *time = [formatter stringFromDate:date];
    
    return time;
}

+ (NSString *)hourAndMinuteStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:MM a";
    
    NSString *time = [formatter stringFromDate:date];
    
    return time;
}

+ (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

+ (UILabel *)detailLabel
{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    return label;
}

+ (UITextField *)detailField:(id)delegate
{
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
    field.delegate = delegate;
    field.returnKeyType = UIReturnKeyDone;
    field.font = [UIFont systemFontOfSize:18];
    field.borderStyle = UITextBorderStyleRoundedRect;
    
    return field;
}

+ (UILabel *)descriptionLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:18];
    return label;
}

+ (UILabel *)descriptionLabelInHeaderView
{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    return label;
}
@end
