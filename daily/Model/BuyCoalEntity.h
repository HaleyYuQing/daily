//
//  BuyCoalEntity.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyCoalEntity : NSObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) float coalPricePerKG;
@property (nonatomic, assign) float coalWeight; //kg

@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, assign) float carWeight;
@property (nonatomic, assign) float carAndCoalWeight;
@end
