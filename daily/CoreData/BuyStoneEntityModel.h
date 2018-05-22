//
//  BuyStoneEntityModel.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface BuyStoneEntityModel : NSManagedObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *stonePricePerKG;
@property (nonatomic, strong) NSNumber * stoneWeight; //kg
@property (nonatomic, strong) NSNumber * stoneTotalPrice;

@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, strong) NSString *carOwnerName;
@property (nonatomic, strong) NSNumber * carWeight;
@property (nonatomic, strong) NSNumber * carAndStoneWeight;
@end

