//
//  StoneCoalEntityModel.h
//  daily
//
//  Created by yuqing huang on 21/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface StoneCoalEntityModel : NSManagedObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, assign) NSInteger totalWeight;
@end
