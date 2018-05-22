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

@property (nonatomic, strong) NSNumber * limePricePerKG;
@property (nonatomic, strong) NSNumber * limeWeight; //kg
@property (nonatomic, strong) NSNumber * limeTotalPrice;

@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic ,strong) NSString *buyerName;
@property (nonatomic, strong) NSNumber * carWeight;
@property (nonatomic, strong) NSNumber * carAndLimeWeight;

@property (nonatomic, strong) NSString *sellerName;
@property (nonatomic, strong) NSNumber * payedPrice;
@property (nonatomic, strong) NSNumber * notPayedPrice;
@property (nonatomic, strong) NSNumber * discountPrice;

- (NSString *)limeWeightString;
- (NSString *)carWeightString;
- (NSString *)limeTotalPriceString;
- (NSString *)limePricePerKGString;
- (NSString *)carAndLimeWeightString;
- (NSString *)payedPriceString;
- (NSString *)notPayedPriceString;
@end
