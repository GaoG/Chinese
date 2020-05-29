//
//  ViewController.m
//  Chinese
//
//  Created by  GaoGao on 2020/5/22.
//  Copyright © 2020年  GaoGao. All rights reserved.
//


#import "ViewController.h"
#import "IpConfigView.h"
#import "CountDownView.h"
#import "StartView.h"
#import "SubmitView.h"
#import "NumberScrollView.h"
#import "ConfigHeader.h"
#import "ProgressView.h"
#import "TipsView.h"
#import "SecondViewController.h"
#import "WebSocketManager.h"
#import "ShowNumberView.h"
#import "GCDAsyncUdpSocket.h"


#define SERVERPORT 9600

@interface ViewController ()<WebSocketManagerDelegate,GCDAsyncUdpSocketDelegate>
@property (nonatomic, strong)UIView *scrollview;

@property (nonatomic, strong)IpConfigView *configView;

@property (nonatomic, strong)CountDownView *countDownView;

@property (nonatomic, strong)StartView *startView;

@property (nonatomic, strong)SubmitView *submitView;

@property (nonatomic, strong)TipsView *tipsView;


@property (nonatomic, strong)NumberScrollView *numberScrollView;

@property (nonatomic, strong)ShowNumberView *showNumberView;


@property (nonatomic, strong)ProgressView *progressView;

@property (nonatomic, strong)NSMutableArray *viewArr;

@property (nonatomic, strong)WebSocketManager *webSocketManager;

@property (nonatomic, strong) NSData *address;

@property (nonatomic, assign) float space;

@property (nonatomic, assign) float time;

@property (nonatomic, assign) BOOL isFail;

@property (nonatomic, assign) NSInteger chinsesNumber;


@property (nonatomic, strong)NSMutableArray *dataArr;


@property (nonatomic, copy) NSString *myID;

@property (nonatomic, strong) UIImage *chineseImage;



@end

@implementation ViewController{
    GCDAsyncUdpSocket *receiveSocket;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chinsesNumber = 0;
    
    self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self initSocket];
    
    self.progressView.frame = self.view.bounds;
    [self.view addSubview:self.progressView];
    
    
    self.configView.frame = self.view.bounds;
    
    [self.view addSubview:self.configView];
    
    
    
    self.countDownView.frame = self.view.bounds;
    [self.view addSubview:self.countDownView];
    
    
    self.startView.frame = self.view.bounds;
    [self.view addSubview:self.startView];
    
    
    
    self.submitView.frame = self.view.bounds;
    [self.view addSubview:self.submitView];
    //    [self.submitView start];
    
    
    
    self.numberScrollView.frame = self.view.bounds;
    [self.view addSubview:self.numberScrollView];
    
    self.tipsView.frame = self.view.bounds;
    [self.view addSubview:self.tipsView];
    
    self.showNumberView.frame = self.view.bounds;
    [self.view addSubview:self.showNumberView];
    
    [self.viewArr addObjectsFromArray:@[self.configView,self.configView,self.countDownView,self.startView,self.submitView,self.numberScrollView,self.progressView,self.tipsView,self.showNumberView]];
    
    
    [self operateView:self.configView withState:NO];
    
    
    
    
//    self.space = 1;
//    self.time = .5;
//    [self operateView:self.showNumberView withState:NO];
//    [self.showNumberView showWithSpace:self.space andAnmintTime:self.time];
    
    
}




- (void)initSocket {
    
    
    dispatch_queue_t dQueue = dispatch_queue_create("Server queue", NULL);
    receiveSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self
                                                  delegateQueue:dQueue];
    NSError *error;
    [receiveSocket bindToPort:SERVERPORT error:&error];
    if (error) {
        NSLog(@"服务器绑定失败");
    }
    [receiveSocket beginReceiving:nil];
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    /**
     *  更新UI一定要到主线程去操作啊
     */
    dispatch_sync(dispatch_get_main_queue(), ^{
        
    });
    self.address = address;
    
    //    NSString *sendStr = @"连接成功";
    
    [self sendGroupMessage:msg];
}



/// 像组中发送消息
-(void)sendGroupMessage:(NSString *)message {
    
    NSData *sendData;
    
    if([message isEqualToString:@"chineseNumber"] || [message isEqualToString:@"hideScored"]){
        NSDictionary *dic =@{
                             @"number":@(self.chinsesNumber),
                             @"type":message
                             };
        
       sendData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    }else{
        sendData = [message dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    

    [receiveSocket sendData:sendData toHost:[GCDAsyncUdpSocket hostFromAddress:self.address]
                       port:[GCDAsyncUdpSocket portFromAddress:self.address]
                withTimeout:60
                        tag:500];
    
    
}


-(void)ceshi:(BOOL)state withView:(UIView *)view {
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.duration=.0001;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:0];
    theAnimation.toValue = [NSNumber numberWithFloat: state ? 3.1415926 : 0.0];
    [view.layer addAnimation:theAnimation forKey:@"animateTransform"];
    
    
}

#pragma mark  websocekt 代理方法

-(void)webSocketDidConnect:(BOOL)state{
    
    /// 登录
    
    NSDictionary *dic = @{
                          @"ID":[NSNumber numberWithInteger:[self.myID integerValue]],
                          @"State":@(1)
                          };
    
    [self.webSocketManager sendDataToServerWithMessageType:@"0" data:dic];
    
    [self operateView:self.startView withState:NO];
    
}


#pragma mark  websocekt 代理方法


- (void)webSocketDidReceiveMessage:(NSString *)string {
    
    NSDictionary *dic  = [self dictionaryWithJsonString:string];
//    {"name":"PC","step":1} 开始页面     下一题时候发送{"name":"PC","step":3}
    if ([dic[@"name"] isEqualToString:@"PC"] &&([dic[@"step"]intValue]==1||[dic[@"step"]intValue]==3)) {
//
        [self operateView:self.tipsView withState:NO];
        
    }else if ([dic[@"name"] isEqualToString:@"PC"] &&[dic[@"step"]intValue]==2) {
//        {"name":"PC","step":2}   开始倒计时 321
        
        
        [self operateView:self.countDownView withState:NO];
        [self.countDownView countDownBegin:3];
    }else if (dic[@"pic"]&&![dic[@"pic"] isEqualToString:@""]){
        /// 图片
        
        /// 收到图片 发送回执消息
        
        [self.webSocketManager sendDataToServerWithMessageType:@"0" data:@{@"name": @"mobile",@"nameid":[NSNumber numberWithInt:[self.myID intValue]]}];
        
        NSString * base64Str = dic[@"pic"] ;
        
        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        UIImage *imaeg = [UIImage imageWithData:imageData];
        self.chineseImage = imaeg;
        
    }else if ([dic[@"name"] isEqualToString:@"PC"] &&[dic[@"step"]intValue]==4){
        
        /// 抢答的结果 收到这个结果表示抢答成功
        [self operateView:self.submitView withState:NO];
        [self.submitView RushAnswer:@"抢答成功"];
        /// 发送观众端消息
        [self sendGroupMessage:@"10"];
        
    }else if ([dic[@"name"] isEqualToString:@"reset"]){
        /// 回到首页 复位
        self.chinsesNumber = 0;
        [self operateView:self.startView withState:NO];
        
    }else if ([dic[@"name"] isEqualToString:@"dispense"]&&[dic[@"targetId"]intValue]==1 &&[dic[@"resultId"]intValue]==1){
        /// 回答正确
        self.chinsesNumber ++;
        [self operateView:self.submitView withState:NO];
        [self.submitView RushAnswer:@"回答正确"];
        
        
    }else if ([dic[@"name"] isEqualToString:@"dispense"]&&[dic[@"targetId"]intValue]==1 &&[dic[@"resultId"]intValue]==2){
        /// 回答失败
        self.chinsesNumber --;
        [self operateView:self.submitView withState:NO];
        [self.submitView RushAnswer:@"回答失败"];
    }else if ([dic[@"name"] isEqualToString:@"dispense"]&&[dic[@"targetId"]intValue]==1 &&[dic[@"resultId"]intValue]==3){
        /// 回答失败
        
        [self operateView:self.submitView withState:NO];
        [self.submitView RushAnswer:@"晋级成功"];
    }else if ([dic[@"name"] isEqualToString:@"dispense"]&&[dic[@"targetId"]intValue]==1 &&[dic[@"resultId"]intValue]==4){
        /// 回答失败
        
        [self operateView:self.submitView withState:NO];
        [self.submitView RushAnswer:@"淘汰"];
    }else if ([dic[@"name"] isEqualToString:@"showScored"]){
        /// 所有ipad显示积分
        
        [self sendGroupMessage:@"chineseNumber"];
        
                  
        
    }else if ([dic[@"name"] isEqualToString:@"hideScored"]){
        /// 所有ipad隐藏积分
        
         [self sendGroupMessage:@"hideScored"];
    }

    
    return;
}















#pragma mark  隐藏或显示某个view

-(void)operateView:(UIView *)view withState:(BOOL)state {
    
    for (UIView *sub in self.viewArr) {
        
        if (sub == view) {
            sub.hidden = state;
        }else{
            sub.hidden = !state;
        }
        
    }
}



-(IpConfigView *)configView {
    
    
    if (!_configView) {
        _configView = [[[NSBundle mainBundle]loadNibNamed:@"IpConfigView" owner:nil options:nil]lastObject];
        
        @weakify(self)
        _configView.connectBlock = ^(NSString *ID,NSString *mainIP,NSString *listIP,NSString *audienceIP, NSInteger type) {
            @strongify(self)
            
//            if( type == 1){
            self.myID = ID;
                [self.webSocketManager testConnectServerWithIp:mainIP withdeviceID:ID];

                
//            }else if (type ==2){
//
//            }
        };
        
    }
    
    
    return _configView;
}


-(CountDownView *)countDownView {
    
    if (!_countDownView) {
        _countDownView = [[[NSBundle mainBundle]loadNibNamed:@"CountDownView" owner:nil options:nil]lastObject];
        @weakify(self)
        _countDownView.endBlock = ^{
            @strongify(self)
            [self.submitView setUpChineseImage:self.chineseImage];
            [self operateView:self.submitView withState:NO];
            
            [self.submitView start];

        };
        
    }
    
    
    return _countDownView;
}



-(StartView *)startView {
    
    if (!_startView) {
        _startView = [[[NSBundle mainBundle]loadNibNamed:@"StartView" owner:nil options:nil]lastObject];
    }
    
    
    return _startView;
}



-(SubmitView *)submitView {
    
    if (!_submitView) {
        _submitView = [[[NSBundle mainBundle]loadNibNamed:@"SubmitView" owner:nil options:nil]lastObject];
        @weakify(self)
        _submitView.submitBlock = ^{
            @strongify(self)
            
            
           /// 抢答
            NSDictionary *data = @{
                                   @"name": @"grab",
                                   @"nameid":[NSNumber numberWithInt:[self.myID intValue]],
                                   };
            [self.webSocketManager sendDataToServerWithMessageType:@"0" data:data];
        };
    }
    
    
    return _submitView;
}

-(NumberScrollView *)numberScrollView {
    
    if (!_numberScrollView) {
        _numberScrollView = [[[NSBundle mainBundle]loadNibNamed:@"NumberScrollView" owner:nil options:nil]lastObject];
        @weakify(self)
        _numberScrollView.scrollEndBlock = ^{
            @strongify(self)
            [self operateView:self.submitView withState:NO];
            [self.submitView start];
        };
    }
    
    return _numberScrollView;
}


-(ProgressView *)progressView {
    
    if (!_progressView) {
        _progressView = [[[NSBundle mainBundle]loadNibNamed:@"ProgressView" owner:nil options:nil]lastObject];
        
    }
    
    return _progressView;
}

-(NSMutableArray *)viewArr{
    
    if (!_viewArr) {
        _viewArr = [NSMutableArray array];
    }
    return _viewArr;
    
}

-(WebSocketManager *)webSocketManager {
    
    if (!_webSocketManager) {
        _webSocketManager = [WebSocketManager shared];
        _webSocketManager.delegate = self;
    }
    
    return _webSocketManager;
}

-(TipsView *)tipsView {
    
    if (!_tipsView) {
        _tipsView = [[[NSBundle mainBundle]loadNibNamed:@"TipsView" owner:nil options:nil]lastObject];
        
    }
    
    return _tipsView;
}

-(ShowNumberView *)showNumberView {
    
    if (!_showNumberView) {
        _showNumberView = [[[NSBundle mainBundle]loadNibNamed:@"ShowNumberView" owner:nil options:nil]lastObject];
        @weakify(self)
        _showNumberView.showEndBlock = ^{
            @strongify(self)
            [self operateView:self.submitView withState:NO];
            [self.submitView start];
        };
        
    }
    
    return _showNumberView;
}




//// 字符串转字典
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
