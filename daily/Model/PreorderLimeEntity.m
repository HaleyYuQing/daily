//
//  PreorderLimeEntity.m
//  daily
//
//  Created by yuqing huang on 22/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "PreorderLimeEntity.h"

@implementation PreorderLimeEntity
- (NSString *)limeWeightString
{
    return self.limeWeight ? [NSString stringWithFormat:@"%@",self.limeWeight] : @"";
}

@end
