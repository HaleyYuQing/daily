//
//  HLCalendarDayCell.m
//  JustekCalendar
//
//  Created by yuqing huang on 01/09/2017.
//  Copyright © 2017 Justek. All rights reserved.
//

#import "HLCalendarDayCell.h"

@interface HLCalendarDayCell ()

@end

@implementation HLCalendarDayCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.todayLabel];
    }
    
    return self;
}

- (UILabel *)todayLabel {
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _dayLabel.backgroundColor = [UIColor clearColor];
        _dayLabel.textColor = [UIColor colorWithRed:109/255.0 green:125/255.0 blue:128/255.0 alpha:1];
    }
    return _dayLabel;
}

@end
