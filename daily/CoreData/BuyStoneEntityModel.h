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
@property (nonatomic, assign) NSInteger stonePricePerKG;
@property (nonatomic, assign) NSInteger stoneWeight; //kg
@property (nonatomic, assign) NSInteger stoneTotalPrice;

@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, strong) NSString *carOwnerName;
@property (nonatomic, assign) NSInteger carWeight;
@property (nonatomic, assign) NSInteger carAndStoneWeight;
@end

