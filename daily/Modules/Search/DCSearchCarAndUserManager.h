//
//  DCSearchCarAndUserManager.h
//  daily
//
//  Created by yuqing huang on 27/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomerEntity;

@interface DCSearchCarAndUserManager : NSObject
@property (nonatomic ,readonly) UISearchBar *searchBar;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, copy) void (^selectHandle)(CustomerEntity *customer);

- (instancetype)initWithSearchType:(CustomerType)type;
- (void)reloadData:(NSArray *)results;
- (void)prefillResultsWithKey:(NSString *)key;
@end
