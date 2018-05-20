//
//  DCBaseUpdateEntityViewController.h
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCHistoryTextField.h"

@interface DCBaseUpdateEntityViewController : UIViewController
@property (nonatomic, strong) UIView *bgView;

- (void)reloadHistoryDataWithKey:(NSString *)key historyTextField:(DCHistoryTextField *)textField;
@end
