//
//  DCConstant.h
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UpdateEntity_Type)
{
    UpdateEntity_Type_NotFound      = NSNotFound,
    UpdateEntity_Type_CoalCarNumber = 1,
    UpdateEntity_Type_CoalUserName,
    UpdateEntity_Type_StoneCarNumber,
    UpdateEntity_Type_StoneUserName,
    UpdateEntity_Type_LimeCarNumber,
    UpdateEntity_Type_LimeUserName,
};

typedef NS_ENUM(NSInteger, ItemEntity_Type)
{
    ItemEntity_Type_Stone = 10,
    ItemEntity_Type_Coal,
    ItemEntity_Type_Lime,
};

typedef NS_ENUM(NSInteger, CustomerType)
{
    CustomerType_ALL = 100,
    CustomerType_Stone,
    CustomerType_Lime,
    CustomerType_Coal
};

@interface DCConstant : NSObject

+ (void)setViewController:(UIViewController *)viewController tabbarTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

+ (UINavigationController *)embedNav:(UIViewController *)vc;

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)monthAndDayStringFromDate:(NSDate *)date;
+ (NSString *)hourAndMinuteStringFromDate:(NSDate *)date;
+ (BOOL)compareIsSameDay:(NSDate *)firstDate nextDate:(NSDate *)nextDate;
+ (UILabel *)detailLabel;
+ (UITextField *)detailField:(id)delegate isNumber:(BOOL)isNumber;
+ (UILabel *)descriptionLabel;
+ (UILabel *)descriptionLabelInHeaderView;

+ (NSString *)getString:(NSString *)text;
+ (NSNumber *)getIntegerNumber:(NSString *)text;

+ (CustomerType)getCustomerEntityTypeWithItemType:(ItemEntity_Type)type;

+ (NSString *)getHSBStringByColor:(UIColor *)originColor;
@end
