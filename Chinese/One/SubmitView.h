//
//  SubmitView.h
//  Chinese
//
//  Created by  GaoGao on 2020/5/23.
//  Copyright © 2020年  GaoGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubmitView : UIView
/// 提交
@property (nonatomic, copy) void (^submitBlock)(void);
/// 倒计时开始
-(void)start;

//-(void)RushAnswer:(NSString *)tipsStr;

/// 设置图片
-(void)setUpChineseImage:(UIImage *)image;
/// 隐藏或显示汉字图片  yes / no
-(void)hiddenChinsesImage:(BOOL)state;

/// 设置提交按钮是否响应事件
-(void)setupSubmitState:(BOOL)state;


@end

NS_ASSUME_NONNULL_END
