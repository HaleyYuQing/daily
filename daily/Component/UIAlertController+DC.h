//
//  UIAlertController+DC.h
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertController(DC)
+ (instancetype _Nonnull )dc_alertControllerWithTitle:(NSString *_Nullable)title
                                               message:(NSString *_Nullable)message
                                           actionTitle:(NSString *_Nullable)actionTitle
                                               handler:(void (^ _Nullable)(UIAlertAction * _Nullable action))handler;
+ (instancetype _Nonnull )dc_alertControllerWithTitle:(NSString *_Nullable)title
                                               message:(NSString *_Nullable)message
                                       leftactionTitle:(NSString *_Nullable)leftactionTitle
                                           lefthandler:(void (^ _Nullable)(UIAlertAction * _Nullable action))lefthandler
                                      rightactionTitle:(NSString *_Nullable)rightactionTitle
                                          righthandler:(void (^ _Nullable)(UIAlertAction * _Nullable action))righthandler;
@end
