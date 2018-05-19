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
    return [NSString stringWithFormat:@"%ld",self.limeWeight];
}

- (NSString *)carWeightString
{
    return [NSString stringWithFormat:@"%ld",self.carWeight];
}

- (NSString *)limeTotalPriceString
{
    return [NSString stringWithFormat:@"%ld",self.limeTotalPrice];
}

- (NSString *)limePricePerKGString
{
    return [NSString stringWithFormat:@"%ld",self.limePricePerKG];
}

- (NSString *)carAndLimeWeightString
{
    return [NSString stringWithFormat:@"%ld",self.carAndLimeWeight];
}

- (NSString *)payedPriceString
{
    return [NSString stringWithFormat:@"%ld",self.payedPrice];
}

- (NSString *)notPayedPriceString
{
    return [NSString stringWithFormat:@"%ld",self.notPayedPrice];
}
@end
