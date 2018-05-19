//
//  DCPlateKeyBoardView.h
//  daily
//
//  Created by yuqing huang on 20/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCPlateKeyBoardView : UIView
@property (nonatomic, copy) void (^selectHandle)(NSString *string, BOOL isProvinceString);
- (void)deleteEnd;
- (UIView *)setupInputAccessoryView:(CGRect)frame;
@end
