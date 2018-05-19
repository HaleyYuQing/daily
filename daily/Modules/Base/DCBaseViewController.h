//
//  DCBaseViewController.h
//  daily
//
//  Created by yuqing huang on 17/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCBaseTableView.h"

@interface DCBaseViewController : UIViewController
@property(nonatomic, readonly) DCBaseTableView * tableView;

- (void)addLeftBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
