//
//  UINavigationItem+DC.m
//  daily
//
//  Created by yuqing huang on 14/05/2018.
//  Copyright © 2018 Justek. All rights reserved.
//

#import "UINavigationItem+DC.h"
#import "UIColor+DC.h"

@implementation UINavigationItem(DC)
- (void)dc_setTitle:(NSString *)title {
    [self dc_setTitleWithFontAttribute:title fontSize:@16 kerning:@3.0];
}

- (void)dc_setTitleWithFontAttribute:(NSString *)title fontSize:(NSNumber *)fontSize kerning:(NSNumber *)kerning {
    NSDictionary *attributes = @{
                                 NSKernAttributeName: kerning,
                                 NSFontAttributeName: [FONT_PROXIMANOVA_BOLD fontWithSize:[fontSize floatValue]],
                                 NSForegroundColorAttributeName: [UIColor colorWithHex:@"6387B5"],
                                 };
    NSAttributedString *s = [[NSAttributedString alloc] initWithString:[title uppercaseString]
                                                            attributes:attributes];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setAttributedText:s];
    [titleLabel sizeToFit];
    
    [self setTitleView:titleLabel];
}
@end
