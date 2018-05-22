//
//  UseStoneEntity.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@interface UseStoneEntity : BaseEntity
@property (nonatomic, strong) NSNumber *stoneWeight; //kg
@property (nonatomic, strong) NSString *operatorName;

- (NSString *)stoneWeightString;
@end
