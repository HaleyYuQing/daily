//
//  UseStoneEntityModel.h
//  daily
//
//  Created by yuqing huang on 18/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UseStoneEntityModel : NSManagedObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *stoneWeight; //kg
@property (nonatomic, strong) NSString *operatorName;
@end

