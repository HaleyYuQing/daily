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
        formatter.dateFormat = @"HH:mm";
        isToday = YES;
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MMM dd, HH:mm";
    } else {
        formatter.dateFormat = @"yyyy.MM.dd，HH:mm";
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
    } else
    {
        formatter.dateFormat = @"yyyy.MM.dd";
    }
    
    NSString *time = [formatter stringFromDate:date];
    
    return time;
}

+ (NSString *)hourAndMinuteStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    
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

+ (UITextField *)detailField:(id)delegate isNumber:(BOOL)isNumber
{
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.delegate = delegate;
    field.keyboardType = isNumber ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
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

+ (NSString *)getHSBStringByColor:(UIColor *)originColor {
    
    NSDictionary *hsbDict = [DCConstant getHSBAValueByColor:originColor];
    
    return [NSString stringWithFormat:@"(%0.2f, %0.2f, %0.2f)",
            
            [hsbDict[@"H"] floatValue],
            
            [hsbDict[@"S"] floatValue],
            
            [hsbDict[@"B"] floatValue]];
}

+ (NSDictionary *)getHSBAValueByColor:(UIColor *)originColor

{
    CGFloat h=0,s=0,b=0,a=0;
    
    if ([originColor respondsToSelector:@selector(getHue:saturation:brightness:alpha:)]) {
        
        [originColor getHue:&h saturation:&s brightness:&b alpha:&a];
        
    }
    
    return @{@"H":@(h),
             
             @"S":@(s),
             
             @"B":@(b),
             
             @"A":@(a)};
    
}
@end
