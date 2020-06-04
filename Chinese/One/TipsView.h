//
//  TipsView.h
//  Chinese
//
//  Created by  GaoGao on 2020/5/23.
//  Copyright © 2020年  GaoGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TipsView : UIView

@property (weak, nonatomic) IBOutlet UIButton *tipsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *answerImage;

@property (weak, nonatomic) IBOutlet UIImageView *tipsImage;



/// 结果  1 开始 2正确  3 失败
-(void)setTipsResult:(NSInteger )result;


/// 1 晋级 2淘汰 3 回答完毕
-(void)setStateAcrion:(NSInteger )result;



@end

NS_ASSUME_NONNULL_END
