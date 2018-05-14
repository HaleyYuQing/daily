//
//  UIColor+DC.m
//  daily
//
//  Created by yuqing huang on 11/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "UIColor+DC.h"

@implementation UIColor(DC)

+ (UIColor *)colorWithHex:(NSString *)hex
{
    if ([hex length] != 6) {
        return nil;
    }
    
    // Brutal and not-very elegant test for non hex-numeric characters
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-fA-F|0-9]" options:0 error:NULL];
    NSUInteger match = [regex numberOfMatchesInString:hex options:NSMatchingReportCompletion range:NSMakeRange(0, [hex length])];
    
    if (match != 0) {
        return nil;
    }
    
    NSRange rRange = NSMakeRange(0, 2);
    NSString *rComponent = [hex substringWithRange:rRange];
    NSUInteger rVal = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:rComponent];
    [rScanner scanHexInt:(unsigned int *)&rVal];
    float rRetVal = (float)rVal / 254;
    
    
    NSRange gRange = NSMakeRange(2, 2);
    NSString *gComponent = [hex substringWithRange:gRange];
    NSUInteger gVal = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:gComponent];
    [gScanner scanHexInt:(unsigned int *)&gVal];
    float gRetVal = (float)gVal / 254;
    
    NSRange bRange = NSMakeRange(4, 2);
    NSString *bComponent = [hex substringWithRange:bRange];
    NSUInteger bVal = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:bComponent];
    [bScanner scanHexInt:(unsigned int *)&bVal];
    float bRetVal = (float)bVal / 254;
    
    return [UIColor colorWithRed:rRetVal green:gRetVal blue:bRetVal alpha:1.0f];
}
@end
