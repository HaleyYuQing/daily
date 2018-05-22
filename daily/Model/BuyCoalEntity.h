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
@property (nonatomic, assign) NSInteger coalPricePerKG;
@property (nonatomic, assign) NSInteger coalWeight; //kg
@property (nonatomic, assign) NSInteger coalTotalPrice;

@property (nonatomic, strong) NSString *carOwnerName;
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, assign) NSInteger carWeight;
@property (nonatomic, assign) NSInteger carAndCoalWeight;

- (NSString *)coalWeightString;
- (NSString *)carWeightString;
- (NSString *)coalTotalPriceString;
- (NSString *)coalPricePerKGString;
- (NSString *)carAndCoalWeightString;
@end
