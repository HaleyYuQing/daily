//
//  HLCalendarMonthCollectionView.m
//  JustekCalendar
//
//  Created by yuqing huang on 01/09/2017.
//  Copyright © 2017 Justek. All rights reserved.
//

#import "HLCalendarMonthCollectionView.h"
#import "HLCalendarDayCell.h"

@interface HLCalendarMonthCollectionView()

@end

@implementation HLCalendarMonthCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self)
    {
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
