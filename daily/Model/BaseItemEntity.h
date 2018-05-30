//
//  BaseItemEntity.h
//  daily
//
//  Created by yuqing huang on 21/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseItemEntity : NSObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *itemType;
@property (nonatomic, strong) NSNumber *itemPricePerKG;
@property (nonatomic, strong) NSNumber *itemWeight; //kg
@property (nonatomic, strong) NSNumber *itemTotalPrice;

@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, strong) NSString *buyerName;
@property (nonatomic, strong) NSNumber *carWeight;
@property (nonatomic, strong) NSNumber *carAndItemWeight;

@property (nonatomic, strong) NSNumber *payedPrice;
@property (nonatomic, strong) NSNumber *notPayedPrice;
@property (nonatomic, strong) NSNumber *discountPrice;

- (NSString *)itemWeightString;
- (NSString *)carWeightString;
- (NSString *)itemTotalPriceString;
- (NSString *)itemPricePerKGString;
- (NSString *)carAndItemWeightString;
- (NSString *)payedPriceString;
- (NSString *)notPayedPriceString;

- (CustomerType)getCustomerType;
@end