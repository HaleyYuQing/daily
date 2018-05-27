//
//  CustomerEntity.h
//  daily
//
//  Created by yuqing huang on 20/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerEntity : NSObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber * itemPricePerKG;
@property (nonatomic, strong) NSNumber * customerType;
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, strong) NSNumber * carWeight;

- (NSString *)carWeightString;
- (NSString *)itemPricePerKGString;
@end
