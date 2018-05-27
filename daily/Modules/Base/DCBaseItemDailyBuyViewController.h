//
//  DCBaseItemDailyBuyViewController.h
//  daily
//
//  Created by yuqing huang on 24/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCBaseViewController.h"

@class BaseItemEntity;

@interface DCBaseItemDailyBuyViewController : DCBaseViewController
@property (nonatomic, readonly) BaseItemEntity *currentItemEntity;
@property (nonatomic, assign) ItemEntity_Type itemType;
@end
