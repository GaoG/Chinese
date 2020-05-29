//
//  ShowNumberView.h
//  Chinese
//
//  Created by  GaoGao on 2020/5/24.
//  Copyright © 2020年  GaoGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowNumberView : UIView

/// type 1白色  2黄色
-(void)setText:(NSString *)text andColor:(NSInteger )type;


/// 显示结束 block
@property (nonatomic, copy)void (^showEndBlock) (void);


/// 开始显示  设置时间
- (void)showWithSpace:(float)space andAnmintTime:(float)time;


@end

NS_ASSUME_NONNULL_END
