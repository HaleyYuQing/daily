//
//  CustomerEntity.h
//  daily
//
//  Created by yuqing huang on 20/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

typedef NS_ENUM(NSInteger, CustomerType)
{
    CustomerType_ALL = 1000,
    CustomerType_Stone,
    CustomerType_Lime,
    CustomerType_Coal
};

@interface CustomerEntity : BaseEntity

@property (nonatomic, assign) NSInteger itemPricePerKG;
@property (nonatomic, assign) NSInteger customerType;
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, assign) NSInteger carWeight;

- (NSString *)carWeightString;
- (NSString *)itemPricePerKGString;
@end
