//
//  KeyboardAvoidingScrollView.m
//  daily
//
//  Created by yuqing huang on 18/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "KeyboardAvoidingScrollView.h"

@implementation KeyboardAvoidingScrollView

- (void)startObservingKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TPKeyboardAvoiding_keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TPKeyboardAvoiding_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollToActiveTextField)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollToActiveTextField)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:nil];
}

- (void)stopObservingKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
