//
//  BuyCoalEntityModel.h
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface BuyCoalEntityModel : NSManagedObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber * coalPricePerKG;
@property (nonatomic, strong) NSNumber * coalWeight; //kg
@property (nonatomic, strong) NSNumber * coalTotalPrice;

@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, strong) NSString *carOwnerName;
@property (nonatomic, strong) NSNumber * carWeight;
@property (nonatomic, strong) NSNumber * carAndCoalWeight;
@end
