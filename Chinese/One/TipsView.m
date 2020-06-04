//
//  TipsView.m
//  Chinese
//
//  Created by  GaoGao on 2020/5/23.
//  Copyright © 2020年  GaoGao. All rights reserved.
//

#import "TipsView.h"

@implementation TipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



/// 结果  1 开始 2正确  3 失败
-(void)setTipsResult:(NSInteger )result {
    
    self.answerImage.image = [UIImage imageNamed:@"bg_icon"];
    self.tipsImage.hidden = NO;
    
    if(result ==2){
        self.tipsImage.image = [UIImage imageNamed:@"answer_right"];
    }else if (result==3){
        self.tipsImage.image = [UIImage imageNamed:@"answer_error"];
    }else if(result==1){
        self.tipsImage.image = [UIImage imageNamed:@"begin_tips"];
       
    }else{
         self.tipsImage.image = [UIImage imageNamed:@""];
    }
    
    
    
    
    
}



/// 1 晋级 2淘汰 3 回答完毕
-(void)setStateAcrion:(NSInteger )result {
    
    self.tipsImage.hidden = YES;
    
    
    if(result ==1){
        self.answerImage.image = [UIImage imageNamed:@"answer_succeed"];
    }else if (result==2){
        self.answerImage.image = [UIImage imageNamed:@"answer_fail"];
    }else{
        self.answerImage.image = [UIImage imageNamed:@"answer_finish"];
    }
    
    
    
    
    
}




@end
