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
    return [NSString stringWithFormat:@"%ld",self.carWeight];
}

- (NSString *)itemPricePerKGString
{
    return [NSString stringWithFormat:@"%ld",self.itemPricePerKG];
}

@end