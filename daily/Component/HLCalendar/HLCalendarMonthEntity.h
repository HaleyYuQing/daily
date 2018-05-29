//
//  HLCalendarMonthEntity.h
//  JustekCalendar
//
//  Created by yuqing huang on 01/09/2017.
//  Copyright © 2017 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLCalendarMonthEntity : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *monthDate; //one day of the month
@property (nonatomic, assign) NSInteger totalDays;
@property (nonatomic, assign) NSInteger firstWeekday; // first day of the month
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger rows;

@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;

- (instancetype)initWithDate:(NSDate *)date;
@end
