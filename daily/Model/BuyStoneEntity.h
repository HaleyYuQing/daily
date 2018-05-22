//
//  BuyStoneEntity.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@interface BuyStoneEntity : BaseEntity

@property (nonatomic, strong) NSNumber * stonePricePerKG;
@property (nonatomic, strong) NSNumber * stoneWeight; //kg
@property (nonatomic, strong) NSNumber * stoneTotalPrice;

@property (nonatomic, strong) NSString *carOwnerName;
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, strong) NSNumber * carWeight;
@property (nonatomic, strong) NSNumber * carAndStoneWeight;

- (NSString *)stoneWeightString;
- (NSString *)carWeightString;
- (NSString *)stoneTotalPriceString;
- (NSString *)stonePricePerKGString;
- (NSString *)carAndStoneWeightString;
@end
