//
//  UseStoneEntity.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItemEntity.h"

@interface UseStoneEntity : NSObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *stoneWeight; //kg
@property (nonatomic, strong) NSString *operatorName;

- (NSString *)stoneWeightString;
@end
