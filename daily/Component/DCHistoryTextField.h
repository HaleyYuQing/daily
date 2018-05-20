//
//  DCHistoryTextField.h
//  daily
//
//  Created by yuqing huang on 20/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerEntity.h"

@interface DCHistoryTextField : UITextField
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy) void (^selectHandle)(CustomerEntity *customer);

- (instancetype)initWithDelegate:(id)delegate isNumber:(BOOL)isNumber;
- (void)setupHistoryTableView:(CGRect)frame;
- (void)reloadHitoryWithData:(NSArray *)array;
- (void)hideHistoryTableView;

@end
