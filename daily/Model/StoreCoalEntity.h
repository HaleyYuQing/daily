//
//  StoreCoalEntity.h
//  daily
//
//  Created by yuqing huang on 21/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreCoalEntity : NSObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSNumber * totalWeight;

- (NSString *)totalWeightString;

@end
