//
//  DCSearchCarAndUserViewController.h
//  daily
//
//  Created by yuqing huang on 27/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCSearchResultsViewController : UIViewController
@property (nonatomic, readonly) UITableView *tableView;
- (void)reloadData:(NSArray *)results;
@end

@interface DCSearchCarAndUserViewController : UISearchController
- (instancetype)initWithSearchType:(CustomerType)type searchResultsViewController:(UIViewController *)resultsVC;
@end
