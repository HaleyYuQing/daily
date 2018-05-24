//
//  DCBaseMenuViewController.h
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DCMenu_type)
{
    DCMenu_NotFound = 1000,
    DCLimeMenu_Sell,
    DCLimeMenu_Store,
    DCCoalMenu_Buy,
    DCCoalMenu_Use,
    DCCoalMenu_Store,
    DCStoneMenu_Buy,
    DCStoneMenu_Use,
    DCStoneMenu_Store
};

@interface DCBaseMenuViewController : UIViewController
@property (nonatomic, readonly) UITableView *tableView;
@property(nonatomic, assign) DCMenu_type currentMenuIndex;
@property (nonatomic, strong) NSArray *menuIndexArray;

- (DCMenu_type)currentMenu;
- (void)showViewControllerWithMenu:(DCMenu_type)type;
@end
