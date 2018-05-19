//
//  UseCoalEntity.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UseCoalEntity : NSObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger coalWeight; //kg
@property (nonatomic, strong) NSString *operatorName;

- (NSString *)coalWeightString;
@end
