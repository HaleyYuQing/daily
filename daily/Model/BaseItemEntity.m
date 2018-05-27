//
//  BaseItemEntity.m
//  daily
//
//  Created by yuqing huang on 21/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "BaseItemEntity.h"

@implementation BaseItemEntity

- (NSString *)itemWeightString
{
    return self.itemWeight ? [NSString stringWithFormat:@"%@",self.itemWeight] : @"";
}

- (NSString *)carWeightString
{
    return self.carWeight ? [NSString stringWithFormat:@"%@",self.carWeight] : @"";
}

- (NSString *)itemTotalPriceString
{
    return self.itemTotalPrice ? [NSString stringWithFormat:@"%@",self.itemTotalPrice] : @"";
}

- (NSString *)itemPricePerKGString
{
    return self.itemPricePerKG ? [NSString stringWithFormat:@"%@",self.itemPricePerKG] : @"";
}

- (NSString *)carAndItemWeightString
{
    return self.carAndItemWeight ? [NSString stringWithFormat:@"%@",self.carAndItemWeight] : @"";
}

- (NSString *)payedPriceString
{
    return self.payedPrice ? [NSString stringWithFormat:@"%@",self.payedPrice] : @"";
}

- (NSString *)notPayedPriceString
{
    return self.notPayedPrice ? [NSString stringWithFormat:@"%@",self.notPayedPrice] : @"";
}

- (CustomerType)getCustomerType
{
    switch ([self.itemType integerValue]) {
        case ItemEntity_Type_Stone:
            return CustomerType_Stone;
            break;
        case ItemEntity_Type_Coal:
            return CustomerType_Coal;
            break;
        case ItemEntity_Type_Lime:
            return CustomerType_Lime;
            break;
        default:
            break;
    }
    return NSNotFound;
}
@end
