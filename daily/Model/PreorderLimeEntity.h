//
//  PreorderLimeEntity.h
//  daily
//
//  Created by yuqing huang on 22/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@interface PreorderLimeEntity : BaseEntity
@property (nonatomic, strong) NSDate *orderTime;
@property (nonatomic, assign) NSInteger limeWeight; //kg
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic ,strong) NSString *buyerName;

- (NSString *)limeWeightString;
@end
