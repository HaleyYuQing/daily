//
//  StoreStoneEntity.m
//  daily
//
//  Created by yuqing huang on 22/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "StoreStoneEntity.h"

@implementation StoreStoneEntity
- (NSString *)totalWeightString
{
    return self.totalWeight ? [NSString stringWithFormat:@"%@", self.totalWeight] : @"";
}

@end
