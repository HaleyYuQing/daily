//
//  PreorderLimeEntityModel.h
//  daily
//
//  Created by yuqing huang on 22/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PreorderLimeEntityModel : NSManagedObject
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *orderTime;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger limeWeight; //kg
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic ,strong) NSString *buyerName;
@end
