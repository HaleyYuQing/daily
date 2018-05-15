//
//  UIViewController+DC.m
//  daily
//
//  Created by yuqing huang on 15/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "UIViewController+DC.h"
#import "DCPopupTransitionDelegate.h"
#import <objc/runtime.h>

static void *DCPopupTransitionDelegateKey;

@implementation UIViewController(DC)

- (void)dc_setPresentAsPopup:(BOOL)presentAsPopup {
    if (presentAsPopup) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        DCPopupTransitionDelegate *delegate = [[DCPopupTransitionDelegate alloc] init];
        self.transitioningDelegate = delegate;
        
        objc_setAssociatedObject(self, DCPopupTransitionDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        objc_setAssociatedObject(self, DCPopupTransitionDelegateKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
