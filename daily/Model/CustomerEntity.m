//
//  CustomerEntity.m
//  daily
//
//  Created by yuqing huang on 20/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "CustomerEntity.h"

@implementation CustomerEntity

- (NSString *)carWeightString
{
    return self.carWeight ? [NSString stringWithFormat:@"%@",self.carWeight] : @"";
}

- (NSString *)itemPricePerKGString
{
    return self.itemPricePerKG ? [NSString stringWithFormat:@"%@",self.itemPricePerKG] : @"";
}

@end
