//
//  UseStoneEntity.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UseStoneEntity : NSObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger stoneWeight; //kg
@property (nonatomic, strong) NSString *operatorName;

- (NSString *)stoneWeightString;
@end
