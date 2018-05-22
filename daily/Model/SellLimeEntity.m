//
//  SellLimeEntity.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "SellLimeEntity.h"

@implementation SellLimeEntity
- (NSString *)limeWeightString
{
    return [NSString stringWithFormat:@"%@",self.limeWeight];
}

- (NSString *)carWeightString
{
    return [NSString stringWithFormat:@"%@",self.carWeight];
}

- (NSString *)limeTotalPriceString
{
    return [NSString stringWithFormat:@"%@",self.limeTotalPrice];
}

- (NSString *)limePricePerKGString
{
    return [NSString stringWithFormat:@"%@",self.limePricePerKG];
}

- (NSString *)carAndLimeWeightString
{
    return [NSString stringWithFormat:@"%@",self.carAndLimeWeight];
}

- (NSString *)payedPriceString
{
    return [NSString stringWithFormat:@"%@",self.payedPrice];
}

- (NSString *)notPayedPriceString
{
    return [NSString stringWithFormat:@"%@",self.notPayedPrice];
}
@end
