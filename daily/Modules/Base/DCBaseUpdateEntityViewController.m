//
//  DCBaseUpdateEntityViewController.m
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCBaseUpdateEntityViewController.h"
#import "UIView+NuiView.h"

@interface DCBaseUpdateEntityViewController ()<UIGestureRecognizerDelegate>

@end

@implementation DCBaseUpdateEntityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tap.delegate = self;
    [self.bgView addGestureRecognizer:tap];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
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
    
    CGFloat addtionalHeight = [self isSearchBar:responderView] ? DCSearchTableViewHeight : 20;
    
    if (remindingHeight - keyboardHeight - addtionalHeight < 0) {
        CGFloat animationHeight = keyboardHeight + addtionalHeight - remindingHeight;
        CGPoint defaultCenter = self.bgView.center;
        
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).offset(-animationHeight);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            self.bgView.center = CGPointMake(defaultCenter.x, defaultCenter.y - animationHeight);
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)note
{
    NSValue* value = [note.userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue: &duration];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        self.bgView.center = self.view.center;
    } completion:^(BOOL finished) {
        
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

- (BOOL)isSearchBar:(UIView *)view
{
    return  [view isKindOfClass:[UISearchBar class]];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)ges
{
    UIView *responderView = [self findFirstResponderInView:self.view];
    [responderView resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
