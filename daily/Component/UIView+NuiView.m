//
//  UIView+NuiView.m
//  Hi
//
//  Created by gaotengfei on 14-8-17.
//  Copyright (c) 2014年 gaotengfei. All rights reserved.
//

#import "UIView+NuiView.h"

@implementation UIView (NuiView)

- (CGPoint) topLeft
{
    return self.frame.origin;
}

- (void) setTopLeft:(CGPoint)topleft
{
    CGRect frame = self.frame;
    frame.origin = topleft;
    self.frame = frame;
}

- (CGPoint) topRight
{
    CGPoint point;
    point.x = self.frame.origin.x + self.frame.size.width;
    point.y = self.frame.origin.y;
    return point;
}

- (void) setTopRight:(CGPoint)topRight
{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(topRight.x - self.frameSize.width, topRight.y);
    self.frame = frame;
}

- (CGPoint) bottomLeft
{
    CGPoint point;
    point.x = self.frame.origin.x;
    point.y = self.frame.origin.y + self.frame.size.height;
    return point;
}

- (void) setBottomLeft:(CGPoint)bottomLeft
{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(bottomLeft.x, bottomLeft.y - self.frameSize.height);
    self.frame = frame;
}

- (CGPoint) bottomRight
{
    CGPoint point;
    point.x = self.frame.origin.x + self.frame.size.width;
    point.y = self.frame.origin.y + self.frame.size.height;
    return point;
}

- (void) setBottomRight:(CGPoint)bottomRight
{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(bottomRight.x - self.frameSize.width, bottomRight.y - self.frameSize.height);
    self.frame = frame;
}

- (CGSize) frameSize
{
    return self.frame.size;
}

- (void) setFrameSize:(CGSize)size
{
    if(size.width > 0 && size.height > 0)
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (UIImage*) imageWithUIView
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    //[view.layer drawInContext:currnetContext];
    [self.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)subviewWithTag:(NSInteger)tag
{
    for(UIView* v in self.subviews)
    {
        if (v.tag == tag)
        {
            return v;
        }
    }
    return nil;
}

- (void)addHexagonMask
{
    UIImage *imageForMask = [UIImage imageNamed:@"bottom-slab2"];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    maskLayer.contents = (id)[imageForMask CGImage];
    [[self layer] setMask:maskLayer];
}

- (void)addMaskWithImage:(UIImage *)imageForMask
{
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    maskLayer.contents = (id)[imageForMask CGImage];
    [[self layer] setMask:maskLayer];
}

- (void)frameTranslateWithHorizontalDistance:(CGFloat)dx verticalDistance:(CGFloat)dy
{
    self.frame = CGRectMake(self.frame.origin.x + dx, self.frame.origin.y + dy, self.frame.size.width, self.frame.size.height);
}

@end
