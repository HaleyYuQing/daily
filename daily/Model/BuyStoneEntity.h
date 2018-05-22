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

@property (nonatomic, assign) NSInteger stonePricePerKG;
@property (nonatomic, assign) NSInteger stoneWeight; //kg
@property (nonatomic, assign) NSInteger stoneTotalPrice;

@property (nonatomic, strong) NSString *carOwnerName;
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, assign) NSInteger carWeight;
@property (nonatomic, assign) NSInteger carAndStoneWeight;

- (NSString *)stoneWeightString;
- (NSString *)carWeightString;
- (NSString *)stoneTotalPriceString;
- (NSString *)stonePricePerKGString;
- (NSString *)carAndStoneWeightString;
@end
