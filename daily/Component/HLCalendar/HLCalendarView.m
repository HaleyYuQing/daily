//
//  HLCalendarView.m
//  JustekCalendar
//
//  Created by yuqing huang on 01/09/2017.
//  Copyright © 2017 Justek. All rights reserved.
//

#import "HLCalendarView.h"
#import "HLCalendarTableViewCell.h"
#import "HLCalendarMonthEntity.h"
#import "NSDate+HLCalendar.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HLSeperateLineColor UIColorFromRGB(0xcccccc)

#define HLDefaultMaxShownMonthCount  3
#define HLDefaultMonthCellHeight 40

@interface HLCalendarView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *backWhiteView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *calendarTableView;
@property (nonatomic, strong) NSArray *calendarMonthList;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;
@end

@implementation HLCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];
        
        CGFloat whiteViewWidth = frame.size.width > 800? 600 : frame.size.width;
        self.backWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, whiteViewWidth, frame.size.height)];
        self.backWhiteView.center = bgView.center;
        self.backWhiteView.userInteractionEnabled = YES;
        self.backWhiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backWhiteView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"选择日期";
        self.titleLabel.textColor =  UIColorFromRGB(0x555555);
        [self.titleLabel sizeToFit];
        [self.backWhiteView addSubview:self.titleLabel];
        self.titleLabel.center = CGPointMake(self.backWhiteView.bounds.size.width * 0.5, 8 + self.titleLabel.frame.size.height * 0.5);
       
        CGFloat weekLabelHeight = 30;
        CGFloat weekLabelWidth = self.backWhiteView.bounds.size.width / 7.0;
        UIView *weeksView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+8, self.backWhiteView.bounds.size.width, 30)];
        CGFloat defaultOrginX = 0;
        for (int i = 0; i < 7; i++) {
            UILabel *weeklabel = [self createWeekLabel:defaultOrginX width:weekLabelWidth height:weekLabelHeight];
            weeklabel.text = [self getWeekString:i];
            [weeksView addSubview:weeklabel];
            defaultOrginX = CGRectGetMaxX(weeklabel.frame);
        }
        
        [self.backWhiteView addSubview:weeksView];
        
        CGFloat calendarTableViewHeight = CGRectGetHeight(self.backWhiteView.frame) - CGRectGetMaxY(weeksView.frame);
        self.calendarTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weeksView.frame), self.backWhiteView.bounds.size.width, calendarTableViewHeight) style:UITableViewStylePlain];
        self.calendarTableView.backgroundColor = [UIColor whiteColor];
        self.calendarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.calendarTableView.dataSource = self;
        self.calendarTableView.delegate = self;
        [self.calendarTableView registerClass:[HLCalendarTableViewCell class] forCellReuseIdentifier:@"HLCalendarTableViewCell"];
        [self.backWhiteView addSubview:self.calendarTableView];
        
        NSDate *nextDate = [NSDate date];
        NSMutableArray *monthList = [NSMutableArray array];
        for (int i = 0; i < HLDefaultMaxShownMonthCount; i++) {
            [monthList insertObject:[[HLCalendarMonthEntity alloc] initWithDate:nextDate] atIndex:0];
            nextDate = [nextDate previousMonthDate];
        }
        self.calendarMonthList = [NSArray arrayWithArray:monthList];
        
        [self.calendarTableView reloadData];
        [self.calendarTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.calendarMonthList.count-1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    return self;
}

- (UILabel *)createWeekLabel:(CGFloat)orginX width:(CGFloat)width height:(CGFloat)height
{
    UILabel *weeklabel = [[UILabel alloc] initWithFrame:CGRectMake(orginX, 0, width, height)];
    weeklabel.textColor =  UIColorFromRGB(0x555555);
    weeklabel.font = [UIFont systemFontOfSize:15];
    weeklabel.textAlignment = NSTextAlignmentCenter;
    return weeklabel;
}

- (NSString *)getWeekString:(int)weekIndex
{
    switch (weekIndex) {
        case 0:
            return @"星期日";
            break;
        case 1:
            return @"星期一";
            break;
        case 2:
            return @"星期二";
            break;
        case 3:
            return @"星期三";
            break;
        case 4:
            return @"星期四";
            break;
        case 5:
            return @"星期五";
            break;
        case 6:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.calendarMonthList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HLCalendarMonthEntity *monthInfo = self.calendarMonthList[section];
    return monthInfo.rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HLCalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLCalendarTableViewCell"];
    HLCalendarMonthEntity *monthInfo = self.calendarMonthList[indexPath.section];
    [cell configureCell:monthInfo row:indexPath.row size:CGSizeMake(self.backWhiteView.frame.size.width, HLDefaultMonthCellHeight) selectDateHandle:self.selectHandle];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HLDefaultMonthCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backWhiteView.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0x555555);
    HLCalendarMonthEntity *monthInfo = self.calendarMonthList[section];
    titleLabel.text = monthInfo.title;
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    [headerView addSubview:titleLabel];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backWhiteView.frame.size.width, 0.5)];
    topLine.backgroundColor = HLSeperateLineColor;
    [headerView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30 - 0.5, self.backWhiteView.frame.size.width, 0.5)];
    bottomLine.backgroundColor = HLSeperateLineColor;
    [headerView addSubview:bottomLine];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)setMaxDate:(NSDate *)date
{
    _maxDate = date;
    if (_minDate && [_minDate laterDate:_maxDate] == _minDate) {
        return;
    }
    
    NSDate *nextDate = _maxDate;
    NSMutableArray *monthList = [NSMutableArray array];
    HLCalendarMonthEntity *todayMonthEntity = nil;
    for (int i = 0; (i <= HLDefaultMaxShownMonthCount || self.minDate.dateMonth <= nextDate.dateMonth) && (!_minDate || (!_minDate || (_minDate && ([nextDate laterDate:_minDate] == nextDate|| [self isSameMonth:_minDate date2:nextDate])))); i++) {
        HLCalendarMonthEntity *cm = [[HLCalendarMonthEntity alloc] initWithDate:nextDate];
        [monthList insertObject:cm atIndex:0];
        if (!todayMonthEntity && cm.year == [[NSDate date] dateYear] && cm.month == [[NSDate date] dateMonth]) {
            todayMonthEntity = cm;
        }
        cm.maxDate = _maxDate;
        cm.minDate = _minDate;
        nextDate = [nextDate previousMonthDate];
    }
    self.calendarMonthList = [NSArray arrayWithArray:monthList];
    
    [self.calendarTableView reloadData];
    
    NSIndexPath *defaultShowMonth = nil;
    if (todayMonthEntity) {
        NSInteger todayIndex = [self.calendarMonthList indexOfObject:todayMonthEntity];
        defaultShowMonth = [NSIndexPath indexPathForRow:0 inSection:todayIndex];
    }
    else
    {
        defaultShowMonth = [NSIndexPath indexPathForRow:0 inSection:self.calendarMonthList.count-1];
    }
    [self.calendarTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.calendarMonthList.count-1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)setMinDate:(NSDate *)date
{
    _minDate = date;
    if (_maxDate && [_minDate laterDate:_maxDate] == _minDate) {
        return;
    }
    
    NSDate *nextDate = self.maxDate ? self.maxDate : [self.minDate getDateAfterMonths:HLDefaultMaxShownMonthCount];
    NSMutableArray *monthList = [NSMutableArray array];
    HLCalendarMonthEntity *todayMonthEntity = nil;
    for (int i = 0; (i <= HLDefaultMaxShownMonthCount || self.minDate.dateMonth <= nextDate.dateMonth)  && (!_minDate || (_minDate && ([nextDate laterDate:_minDate] == nextDate|| [self isSameMonth:_minDate date2:nextDate]))); i++) {
        HLCalendarMonthEntity *cm = [[HLCalendarMonthEntity alloc] initWithDate:nextDate];
        [monthList insertObject:cm atIndex:0];
        if (!todayMonthEntity && cm.year == [[NSDate date] dateYear] && cm.month == [[NSDate date] dateMonth]) {
            todayMonthEntity = cm;
        }
        cm.maxDate = _maxDate;
        cm.minDate = _minDate;
        nextDate = [nextDate previousMonthDate];
    }
    self.calendarMonthList = [NSArray arrayWithArray:monthList];
    
    [self.calendarTableView reloadData];
    NSIndexPath *defaultShowMonth = nil;
    if (todayMonthEntity) {
        NSInteger todayIndex = [self.calendarMonthList indexOfObject:todayMonthEntity];
        defaultShowMonth = [NSIndexPath indexPathForRow:0 inSection:todayIndex];
    }
    else
    {
        defaultShowMonth = [NSIndexPath indexPathForRow:0 inSection:self.calendarMonthList.count-1];
    }
    [self.calendarTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (BOOL)isSameMonth:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth;
    
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    
    return ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]);
}

- (void)hideView:(UIGestureRecognizer *)ges
{
    if (self.selectHandle) {
        self.selectHandle(nil);
    }
}

- (UIView *)setupInputAccessoryView:(CGRect)frame
{
    UIView *hideView = [[UIView alloc] initWithFrame:frame];
    hideView.backgroundColor = UIColorFromRGBA(0x333333, 0.5);
    [hideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView:)]];
    return hideView;
}
@end
