//
//  DCBaseTableView.m
//  daily
//
//  Created by yuqing huang on 18/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCBaseTableView.h"

@implementation DCBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = TableViewBackgroundColor;
        self.tableFooterView = [UIView new];
    }
    return self;
}

@end
