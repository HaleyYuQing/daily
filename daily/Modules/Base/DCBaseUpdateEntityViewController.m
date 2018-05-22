//
//  DCBaseUpdateEntityViewController.m
//  daily
//
//  Created by yuqing huang on 19/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "DCBaseUpdateEntityViewController.h"
#import "UIView+NuiView.h"
#import "DCCoreDataManager.h"

@interface DCBaseUpdateEntityViewController ()

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
    [self.bgView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification *)note
{
    UIView *responderView = [self findFirstResponderInView:self.view];
    if ([self isShowHistory:responderView.tag]) {
        DCHistoryTextField *field = (DCHistoryTextField *)responderView;
        CGRect d = [field convertRect:field.bounds toView:[UIApplication sharedApplication].keyWindow];
        field.tableView.topLeft = CGPointMake(d.origin.x, d.origin.y + d.size.height);
        [[UIApplication sharedApplication].keyWindow addSubview:field.tableView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:field.tableView];
    }
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
    
    CGFloat addtionalHeight = [self isShowHistory:responderView.tag] ? 120 : 20;
    
    if (remindingHeight - keyboardHeight - addtionalHeight < 0) {
        CGFloat animationHeight = keyboardHeight + addtionalHeight - remindingHeight;
        CGPoint defaultCenter = responderView.superview.superview.center;
        
        [responderView.superview.superview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).offset(-animationHeight);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            responderView.superview.superview.center = CGPointMake(defaultCenter.x, defaultCenter.y - animationHeight);
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)note
{
    UIView *responderView = [self findFirstResponderInView:self.view];
    if ([self isShowHistory:responderView.tag]) {
        DCHistoryTextField *field = (DCHistoryTextField *)responderView;
        [field.tableView removeFromSuperview];
    }
    
    NSValue* value = [note.userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue: &duration];
    
    [responderView.superview.superview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        responderView.superview.superview.center = self.view.center;
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

- (BOOL)isShowHistory:(UpdateEntity_Type)type
{
    return type == UpdateEntity_Type_LimeUserName || type == UpdateEntity_Type_LimeCarNumber || type == UpdateEntity_Type_StoneCarNumber || type == UpdateEntity_Type_StoneUserName || type == UpdateEntity_Type_CoalCarNumber || type == UpdateEntity_Type_CoalUserName;
}

- (void)hideKeyboard:(UITapGestureRecognizer *)ges
{
    UIView *responderView = [self findFirstResponderInView:self.view];
    [responderView resignFirstResponder];
}

- (void)textDidChange:(NSNotification *)note
{
    if ([note.object isKindOfClass:[DCHistoryTextField class]]) {
        DCHistoryTextField *field = note.object;
        [self reloadHistoryDataWithKey:field.text historyTextField:field];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isKindOfClass:[DCHistoryTextField class]]) {
        DCHistoryTextField *field = (DCHistoryTextField *)textField;
        [self reloadHistoryDataWithKey:field.text historyTextField:field];
    }
}

- (void)reloadHistoryDataWithKey:(NSString *)key historyTextField:(DCHistoryTextField *)textField
{
    if (textField.tag == UpdateEntity_Type_LimeCarNumber) {
        __block NSMutableArray *results = [[NSMutableArray alloc] init];
        [[[DCCoreDataManager sharedInstance] getLimeCustomer] enumerateObjectsUsingBlock:^(CustomerEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.carNumber lowercaseString] containsString:[key lowercaseString]] || key.length == 0) {
                [results addObject:obj];
            }
        }];
        
        [textField reloadHitoryWithData:results];
    }
    
    if (textField.tag == UpdateEntity_Type_LimeUserName) {
        __block NSMutableArray *results = [[NSMutableArray alloc] init];
        [[[DCCoreDataManager sharedInstance] getLimeCustomer] enumerateObjectsUsingBlock:^(CustomerEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.name lowercaseString] containsString:[key lowercaseString]] || key.length == 0) {
                [results addObject:obj];
            }
        }];
        
        [textField reloadHitoryWithData:results];
    }
    
    if (textField.tag == UpdateEntity_Type_StoneCarNumber) {
        __block NSMutableArray *results = [[NSMutableArray alloc] init];
        [[[DCCoreDataManager sharedInstance] getStoneCustomer] enumerateObjectsUsingBlock:^(CustomerEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.carNumber lowercaseString] containsString:[key lowercaseString]] || key.length == 0) {
                [results addObject:obj];
            }
        }];
        
        [textField reloadHitoryWithData:results];
    }
    
    if (textField.tag == UpdateEntity_Type_StoneUserName) {
        __block NSMutableArray *results = [[NSMutableArray alloc] init];
        [[[DCCoreDataManager sharedInstance] getStoneCustomer] enumerateObjectsUsingBlock:^(CustomerEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.name lowercaseString] containsString:[key lowercaseString]] || key.length == 0) {
                [results addObject:obj];
            }
        }];
        
        [textField reloadHitoryWithData:results];
    }
    
    if (textField.tag == UpdateEntity_Type_CoalCarNumber) {
        __block NSMutableArray *results = [[NSMutableArray alloc] init];
        [[[DCCoreDataManager sharedInstance] getCoalCustomer] enumerateObjectsUsingBlock:^(CustomerEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.carNumber lowercaseString] containsString:[key lowercaseString]] || key.length == 0) {
                [results addObject:obj];
            }
        }];
        
        [textField reloadHitoryWithData:results];
    }
    
    if (textField.tag == UpdateEntity_Type_CoalUserName) {
        __block NSMutableArray *results = [[NSMutableArray alloc] init];
        [[[DCCoreDataManager sharedInstance] getCoalCustomer] enumerateObjectsUsingBlock:^(CustomerEntity * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj.name lowercaseString] containsString:[key lowercaseString]] || key.length == 0) {
                [results addObject:obj];
            }
        }];
        
        [textField reloadHitoryWithData:results];
    }
}
@end
