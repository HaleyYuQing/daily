//
//  HLCalendarTableViewCell.h
//  JustekCalendar
//
//  Created by yuqing huang on 01/09/2017.
//  Copyright © 2017 Justek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLCalendarMonthEntity.h"

@interface HLCalendarTableViewCell : UITableViewCell

- (void)configureCell:(HLCalendarMonthEntity *)monthInfo row:(NSInteger)row size:(CGSize)cellSize selectDateHandle:(void (^)(NSDate *))handle;
@end
