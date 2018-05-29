//
//  HLCalendarMonthEntity.m
//  JustekCalendar
//
//  Created by yuqing huang on 01/09/2017.
//  Copyright © 2017 Justek. All rights reserved.
//

#import "HLCalendarMonthEntity.h"
#import "NSDate+HLCalendar.h"

@implementation HLCalendarMonthEntity

- (instancetype)initWithDate:(NSDate *)date {
    
    if (self = [super init]) {
        _monthDate = date;
        _totalDays = [self setupTotalDays];
        _firstWeekday = [self setupFirstWeekday];
        _year = [self setupYear];
        _month = [self setupMonth];
        _rows = [self setupRows];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM YYYY"];
        _title = [formatter stringFromDate:_monthDate];
    }
    
    return self;
    
}


- (NSInteger)setupTotalDays {
    return [_monthDate totalDaysInMonth];
}

- (NSInteger)setupFirstWeekday {
    return [_monthDate firstWeekDayInMonth];
}

- (NSInteger)setupYear {
    return [_monthDate dateYear];
}

- (NSInteger)setupMonth {
    return [_monthDate dateMonth];
}

- (NSInteger)setupRows
{
    return [_monthDate rowsInMonth];
}

@end
