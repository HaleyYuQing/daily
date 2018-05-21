//
//  OperatorEntityModel.h
//  daily
//
//  Created by yuqing huang on 20/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface OperatorEntityModel : NSManagedObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *createDate;
@end
