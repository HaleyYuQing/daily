//
//  BuyStoneEntity.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "BuyStoneEntity.h"

@implementation BuyStoneEntity

- (NSString *)stoneWeightString
{
    return [NSString stringWithFormat:@"%ld",self.stoneWeight];
}

- (NSString *)carWeightString
{
    return [NSString stringWithFormat:@"%ld",self.carWeight];
}

- (NSString *)stoneTotalPriceString
{
    return [NSString stringWithFormat:@"%ld",self.stoneTotalPrice];
}

- (NSString *)stonePricePerKGString
{
    return [NSString stringWithFormat:@"%ld",self.stonePricePerKG];
}

- (NSString *)carAndStoneWeightString
{
    return [NSString stringWithFormat:@"%ld",self.carAndStoneWeight];
}
@end
