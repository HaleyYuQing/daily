//
//  BuyCoalEntity.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@interface BuyCoalEntity : BaseEntity
@property (nonatomic, strong) NSNumber * coalPricePerKG;
@property (nonatomic, strong) NSNumber * coalWeight; //kg
@property (nonatomic, strong) NSNumber * coalTotalPrice;

@property (nonatomic, strong) NSString *carOwnerName;
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, strong) NSNumber * carWeight;
@property (nonatomic, strong) NSNumber * carAndCoalWeight;

- (NSString *)coalWeightString;
- (NSString *)carWeightString;
- (NSString *)coalTotalPriceString;
- (NSString *)coalPricePerKGString;
- (NSString *)carAndCoalWeightString;
@end
