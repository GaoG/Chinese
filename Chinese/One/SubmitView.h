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

-(void)RushAnswer:(NSString *)tipsStr;

/// 设置图片
-(void)setUpChineseImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END