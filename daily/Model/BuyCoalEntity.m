//
//  BuyCoalEntity.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "BuyCoalEntity.h"

@implementation BuyCoalEntity

- (NSString *)coalWeightString
{
    return [NSString stringWithFormat:@"%@",self.coalWeight];
}

- (NSString *)carWeightString
{
    return [NSString stringWithFormat:@"%@",self.carWeight];
}

- (NSString *)coalTotalPriceString
{
    return [NSString stringWithFormat:@"%@",self.coalTotalPrice];
}

- (NSString *)coalPricePerKGString
{
    return [NSString stringWithFormat:@"%@",self.coalPricePerKG];
}

- (NSString *)carAndCoalWeightString
{
    return [NSString stringWithFormat:@"%@",self.carAndCoalWeight];
}
@end
