//
//  SubmitView.m
//  Chinese
//
//  Created by  GaoGao on 2020/5/23.
//  Copyright © 2020年  GaoGao. All rights reserved.
//

#import "SubmitView.h"
#import "SNTimer.h"
@interface SubmitView ()


@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (nonatomic,assign) NSInteger  timer;
/// 计时器
@property (weak, nonatomic) IBOutlet UILabel *chronographL;


@property (weak, nonatomic) IBOutlet UILabel *minuteL;

@property (weak, nonatomic) IBOutlet UILabel *minuteR;


@property (weak, nonatomic) IBOutlet UILabel *secondL;

@property (weak, nonatomic) IBOutlet UILabel *secondR;


@property (weak, nonatomic) IBOutlet UILabel *msecL;

@property (weak, nonatomic) IBOutlet UILabel *msecR;

/// 提交
@property (weak, nonatomic) IBOutlet UIButton *submitBut;

@property (nonatomic,strong) SNTimer *gcdTimer;

@property (nonatomic,strong) NSDate * date1970;

@property (nonatomic,strong) NSDate * startCountDate;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;

/// 题目图片
@property (weak, nonatomic) IBOutlet UIImageView *chineseImage;


@end

@implementation SubmitView



/// 倒计时开始
- (void)start {
    self.submitBut.enabled = YES;
 
    
    
    
    return;
    
    /// 倒计时不需要了
    
//    self.timer = 30;
//    self.timeL.text = @"30";
//    [_gcdTimer invalidate];
//    __weak id weakSelf = self;
//
//    _gcdTimer = [SNTimer repeatingTimerWithTimeInterval:1 block:^{
//        [weakSelf updateTime];
//    }];
//
//
//    [self.gcdTimer fire];
//
}

/// 不需要了
//-(void)RushAnswer:(NSString *)tipsStr; {
//
//
//    self.timeL.text = tipsStr;
//
//
//}


//
//-(void)updateTime {
//
//    self.timer --;
//
//
//    if (self.timer ==0) {
//        [self.gcdTimer invalidate];
//        self.timeL.text = @"已结束";
//        self.submitBut.enabled = NO;
//    }else{
//
//        self.timeL.text = [NSString stringWithFormat:@"%ld",(long)self.timer];
//
//    }
//}

- (IBAction)submitButAction:(UIButton*)sender {
    
    sender.enabled = NO;
    
     [self.gcdTimer invalidate];
    self.submitBlock ? self.submitBlock() : nil;
}


/// 设置图片
-(void)setUpChineseImage:(UIImage *)image {
    self.chineseImage.image = image;
}

/// 隐藏或显示汉字图片  yes / no
-(void)hiddenChinsesImage:(BOOL)state {
    
    self.chineseImage.hidden = state;
    
    
}


/// 设置提交按钮是否响应事件
-(void)setupSubmitState:(BOOL)state {
    
    
    self.submitBut.enabled = state;
    
    
}



//-(SNTimer *)gcdTimer {
//
//    if(!_gcdTimer){
//        __weak id weakSelf = self;
//        self.date1970 = [NSDate dateWithTimeIntervalSince1970:0];
//        _gcdTimer = [SNTimer repeatingTimerWithTimeInterval:0.01 block:^{
//            [weakSelf updateTime];
//        }];
//
//    }
//    return _gcdTimer;
//}


- (NSDateFormatter *)dateFormatter {
    if(!_dateFormatter){
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"mm:ss:SS"];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
    }
    
    return _dateFormatter;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
