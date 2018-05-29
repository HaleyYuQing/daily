//
//  HLCalendarView.h
//  JustekCalendar
//
//  Created by yuqing huang on 01/09/2017.
//  Copyright © 2017 Justek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLCalendarView : UIView
@property (nonatomic, copy) void (^selectHandle)(NSDate *);
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setMaxDate:(NSDate *)date;
- (void)setMinDate:(NSDate *)date;
- (UIView *)setupInputAccessoryView:(CGRect)frame;
@end
