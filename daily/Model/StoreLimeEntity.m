//
//  StoreLimeEntity.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "StoreLimeEntity.h"

@implementation StoreLimeEntity

- (NSString *)getLimeWeightString
{
    return self.limeWeight ? [NSString stringWithFormat:@"%@",self.limeWeight] : @"";
}

@end
