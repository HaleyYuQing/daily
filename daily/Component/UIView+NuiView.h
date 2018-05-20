//
//  UIView+NuiView.h
//  Hi
//
//  Created by gaotengfei on 14-8-17.
//  Copyright (c) 2014年 gaotengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NuiView)

- (CGPoint) topLeft;
- (void) setTopLeft:(CGPoint)topleft;

- (CGPoint) topRight;
- (void) setTopRight:(CGPoint)topRight;

- (CGPoint) bottomLeft;
- (void) setBottomLeft:(CGPoint)bottomLeft;

- (CGPoint) bottomRight;
- (void) setBottomRight:(CGPoint)bottomRight;

- (CGSize) frameSize;

- (void) setFrameSize:(CGSize)size;

- (UIImage*) imageWithUIView;

- (UIView *)subviewWithTag:(NSInteger)tag;

- (void)addHexagonMask;
- (void)addMaskWithImage:(UIImage *)imageForMask;

- (void)frameTranslateWithHorizontalDistance:(CGFloat)dx verticalDistance:(CGFloat)dy;

@end
