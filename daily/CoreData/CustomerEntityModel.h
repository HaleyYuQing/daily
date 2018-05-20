//
//  CustomerEntityModel.h
//  daily
//
//  Created by yuqing huang on 20/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CustomerEntityModel : NSManagedObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger itemPricePerKG;
@property (nonatomic, assign) NSInteger customerType;
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, assign) NSInteger carWeight;
@end
