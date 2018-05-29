//
//  HLCalendarTableViewCell.m
//  JustekCalendar
//
//  Created by yuqing huang on 01/09/2017.
//  Copyright © 2017 Justek. All rights reserved.
//

#import "HLCalendarTableViewCell.h"
#import "HLCalendarMonthCollectionView.h"
#import "HLCalendarDayCell.h"
#import "NSDate+HLCalendar.h"
#import "Masonry.h"

@interface HLCalendarTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) HLCalendarMonthCollectionView *monthCollectionView;
@property (nonatomic, strong) HLCalendarMonthEntity *monthInfo;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy) void (^selectHandle)(NSDate *);

@property (nonatomic, strong) UIView *seperateLine;
@end

@implementation HLCalendarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.seperateLine = [UIView new];
        self.seperateLine.backgroundColor = UIColorFromRGB(0xcccccc);
        [self.contentView addSubview:self.seperateLine];
        [self.seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@(0.5));
        }];
    }
    return self;
}

- (HLCalendarMonthCollectionView *)monthCollectionView
{
    if (!_monthCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.cellSize.width / 7.0, self.cellSize.height);
        flowLayout.minimumLineSpacing = 0.0;
        flowLayout.minimumInteritemSpacing = 0.0;
        
        self.monthCollectionView = [[HLCalendarMonthCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height) collectionViewLayout:flowLayout];
        [self.monthCollectionView registerClass:[HLCalendarDayCell class] forCellWithReuseIdentifier:@"monthCell"];
        self.monthCollectionView.delegate = self;
        self.monthCollectionView.dataSource = self;
        
        [self.contentView insertSubview:self.monthCollectionView atIndex:0];
    }
    return _monthCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HLCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"monthCell" forIndexPath:indexPath];
    
    NSInteger firstWeekday = self.monthInfo.firstWeekday;
    NSInteger totalDays = self.monthInfo.totalDays;
    
    // current month
    if ((self.row * 7 + indexPath.row) >= firstWeekday && (self.row * 7 + indexPath.row) < firstWeekday + totalDays) {
        cell.dayLabel.hidden = NO;
        cell.dayLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        cell.dayLabel.text = [NSString stringWithFormat:@"%d", self.row * 7 + indexPath.row - firstWeekday + 1];
        cell.userInteractionEnabled = YES;
        // later maxDate
        if (self.monthInfo.maxDate && (self.monthInfo.month == [self.monthInfo.maxDate dateMonth]) && (self.monthInfo.year == [self.monthInfo.maxDate dateYear]) && ((self.row * 7 + indexPath.row) > [self.monthInfo.maxDate dateDay] + firstWeekday - 1))
        {
            //later maxDate
            cell.dayLabel.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
            cell.userInteractionEnabled = NO;
        }
        // early minDate
        else if (self.monthInfo.minDate && (self.monthInfo.month == [self.monthInfo.minDate dateMonth]) && (self.monthInfo.year == [self.monthInfo.minDate dateYear]) && ((self.row * 7 + indexPath.row) < [self.monthInfo.minDate dateDay] + firstWeekday - 1))
        {
            cell.dayLabel.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
            cell.userInteractionEnabled = NO;
        }
        // today
        else if ((self.monthInfo.month == [[NSDate date] dateMonth]) && (self.monthInfo.year == [[NSDate date] dateYear])) {
            if ((self.row * 7 + indexPath.row) == [[NSDate date] dateDay] + firstWeekday - 1) {
                cell.dayLabel.text = @"今天";
            }
        }
    }
    // out of this month
    else if ((self.row * 7 + indexPath.row) < firstWeekday) {
        cell.dayLabel.hidden = YES;
    } else if ((self.row * 7 + indexPath.row) >= firstWeekday + totalDays) {
        cell.dayLabel.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"");
    NSInteger currentDay = self.row * 7 + indexPath.row - self.monthInfo.firstWeekday + 1;
    NSDate *currentDate = [NSDate getDateFromYear:self.monthInfo.year month:self.monthInfo.month day:currentDay];
    if (self.selectHandle) {
        self.selectHandle(currentDate);
    }
}

- (void)configureCell:(HLCalendarMonthEntity *)monthInfo row:(NSInteger)row size:(CGSize)cellSize selectDateHandle:(void (^)(NSDate *))handle;
{
    self.selectHandle = handle;
    self.cellSize = cellSize;
    self.row = row;
    self.monthInfo = monthInfo;
    [self.monthCollectionView reloadData];
}
@end
