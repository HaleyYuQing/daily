//
//  StoreStoneEntity.h
//  daily
//
//  Created by yuqing huang on 22/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreStoneEntity : NSObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, assign) NSInteger totalWeight;

- (NSString *)totalWeightString;
@end
