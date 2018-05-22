//
//  SellLimeEntity.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@interface SellLimeEntity : BaseEntity

@property (nonatomic, assign) NSInteger limePricePerKG;
@property (nonatomic, assign) NSInteger limeWeight; //kg
@property (nonatomic, assign) NSInteger limeTotalPrice;

@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic ,strong) NSString *buyerName;
@property (nonatomic, assign) NSInteger carWeight;
@property (nonatomic, assign) NSInteger carAndLimeWeight;

@property (nonatomic, strong) NSString *sellerName;
@property (nonatomic, assign) NSInteger payedPrice;
@property (nonatomic, assign) NSInteger notPayedPrice;
@property (nonatomic, assign) NSInteger discountPrice;

- (NSString *)limeWeightString;
- (NSString *)carWeightString;
- (NSString *)limeTotalPriceString;
- (NSString *)limePricePerKGString;
- (NSString *)carAndLimeWeightString;
- (NSString *)payedPriceString;
- (NSString *)notPayedPriceString;
@end
