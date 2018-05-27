//
//  PreorderLimeEntity.h
//  daily
//
//  Created by yuqing huang on 22/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreorderLimeEntity : NSObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSDate *orderTime;
@property (nonatomic, strong) NSNumber * limeWeight; //kg
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic ,strong) NSString *buyerName;

- (NSString *)limeWeightString;
@end
