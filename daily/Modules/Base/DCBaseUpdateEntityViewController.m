//
//  DCBaseUpdateEntityViewController.m
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCBaseUpdateEntityViewController.h"

@interface DCBaseUpdateEntityViewController ()

@end

@implementation DCBaseUpdateEntityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    CGFloat keyboardHeight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSValue* value = [note.userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue: &duration];
    
    UIView *responderView = [self findFirstResponderInView:self.view];
    CGRect d = [responderView convertRect:responderView.bounds toView:self.view];
    CGFloat remindingHeight = self.view.frame.size.height - (d.origin.y + d.size.height);
    
    if (remindingHeight - keyboardHeight - 20 < 0) {
        CGFloat animationHeight = keyboardHeight + 20 - remindingHeight;
        CGPoint defaultCenter = responderView.superview.superview.center;
        [UIView animateWithDuration:duration animations:^{
            responderView.superview.superview.center = CGPointMake(defaultCenter.x, defaultCenter.y - animationHeight);
        }];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)note
{
    UIView *responderView = [self findFirstResponderInView:self.view];
    NSValue* value = [note.userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue: &duration];
    
    [UIView animateWithDuration:duration animations:^{
        responderView.superview.superview.center = self.view.center;
    }];
}

- (UIView*)findFirstResponderInView:(UIView*)view {
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponderInView:childView];
        if ( result ) return result;
    }
    return nil;
}

@end
