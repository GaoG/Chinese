//
//  UILabel+WordSpacing.m
//  Chinese
//
//  Created by  GaoGao on 2020/5/23.
//  Copyright © 2020年  GaoGao. All rights reserved.
//

#import "UILabel+WordSpacing.h"

@implementation UILabel (WordSpacing)
-(void)setText:(NSString *)text withKeyWord:(NSArray *)keywords withKeyColor:(UIColor *)color {
    self.font = [UIFont boldSystemFontOfSize:70];
    self.textAlignment = 1;
    if (!text) {
        text = @"";
    }
    
    if (!keywords) {
        keywords = @[];
    }
    
    //设置字间距
    NSDictionary *dic = @{NSKernAttributeName:@30.f};
    NSMutableAttributedString * attributedString =     [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
    
    for (NSString *str in keywords) {
        if ([text rangeOfString:str].location!=NSNotFound) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[text rangeOfString:str]];
        }
    }
    
    [self setAttributedText:attributedString];
}




-(void)setText:(NSString *)text withWordSpacing:(float)spacing {
    
    self.font = [UIFont boldSystemFontOfSize:100];
    
    self.textAlignment = 1;
    if (!text) {
        text = @"";
    }
    
    if(spacing < 1.0){
        spacing = 30.0;
        
    }
        
    //设置字间距
    NSDictionary *dic = @{
                          NSKernAttributeName:@(spacing)
                          
                          };
    NSMutableAttributedString * attributedString =     [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
    [attributedString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor whiteColor]
                               range:NSMakeRange(0, text.length)];//设置颜色
    [self setAttributedText:attributedString];
}


@end
