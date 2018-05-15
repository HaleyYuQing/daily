//
//  UIAlertController+DC.m
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "UIAlertController+DC.h"

@implementation UIAlertController(DC)

+ (instancetype _Nonnull)dc_alertControllerWithTitle:(NSString * _Nullable)title
                                              message:(NSString * _Nullable)message
                                          actionTitle:(NSString * _Nullable)actionTitle
                                              handler:(void (^ _Nullable)(UIAlertAction * _Nullable action))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:actionTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:handler];
    [alert addAction:okAction];
    
    return alert;
}

+ (instancetype _Nonnull )dc_alertControllerWithTitle:(NSString *_Nullable)title
                                               message:(NSString *_Nullable)message
                                       leftactionTitle:(NSString *_Nullable)leftactionTitle
                                           lefthandler:(void (^ _Nullable)(UIAlertAction * _Nullable action))lefthandler
                                      rightactionTitle:(NSString *_Nullable)rightactionTitle
                                          righthandler:(void (^ _Nullable)(UIAlertAction * _Nullable action))righthandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftactionTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:lefthandler];
    [alert addAction:leftAction];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightactionTitle
                                                          style:UIAlertActionStyleDefault
                                                        handler:righthandler];
    [alert addAction:rightAction];
    
    return alert;
}

@end
