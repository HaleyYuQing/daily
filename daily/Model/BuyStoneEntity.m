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
    return [NSString stringWithFormat:@"%@",self.stoneWeight];
}

- (NSString *)carWeightString
{
    return [NSString stringWithFormat:@"%@",self.carWeight];
}

- (NSString *)stoneTotalPriceString
{
    return [NSString stringWithFormat:@"%@",self.stoneTotalPrice];
}

- (NSString *)stonePricePerKGString
{
    return [NSString stringWithFormat:@"%@",self.stonePricePerKG];
}

- (NSString *)carAndStoneWeightString
{
    return [NSString stringWithFormat:@"%@",self.carAndStoneWeight];
}
@end
