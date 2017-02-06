//
//  WHPasswordView.m
//  PasswordView
//
//  Created by 西太科技 on 2017/2/6.
//  Copyright © 2017年 lei wenhao. All rights reserved.
//

#import "PasswordViewSuper.h"

#import "WHPayPasswordView.h"

#define WH_screenWidth [UIScreen mainScreen].bounds.size.width
#define WH_screenHeight [UIScreen mainScreen].bounds.size.height
#define WH_alertView_width 280
#define WH_margin_X (WH_screenWidth - WH_alertView_width) * 0.5
#define WH_lineColor [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0]

/** 动画时间 */
static CGFloat const WH_animateWithDuration = 0.2;
/** 距离X轴的间距 */
static CGFloat const margin_X = 20;
/** 距离Y轴的间距 */
static CGFloat const margin_Y = 20;
/** 标题字体大小 */
static CGFloat const message_text_fond = 14.0f;
/** 金额字体大小 */
static CGFloat const amount_text_fond = 17.0f;

@interface PasswordViewSuper () <PayPasswordViewDelegate>

/** 遮盖 */
@property (strong, nonatomic) UIButton * coverView;
/** 背景View */
@property (strong, nonatomic) UIView * bg_view;
/** 标题提示文字 */
@property (strong, nonatomic) NSString * messageTitle;
/** 内容提示文字 */
@property (assign, nonatomic) CGFloat amountTitle;

@end

@implementation PasswordViewSuper

- (instancetype)initWithTitle:(NSString *)title amount:(NSString *)amount {
    
    if (self = [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        
        self.messageTitle = title;
        self.amountTitle = [amount floatValue];
        
        [self setupPasswordView];
        
    }
    
    return self;
}


+ (instancetype)wh_passwordViewWithTitle:(NSString *)title amount:(NSString *)amount {
    return [[self alloc] initWithTitle:title amount:amount]
    ;
}

- (void)show {
    
    if (self.superview != nil) {
        return;
    }
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:WH_animateWithDuration animations:^{
        [self animationWithAlertView];
    }];
}

- (void)setupPasswordView {
    
    // 遮盖层
    self.coverView = [[UIButton alloc] init];
    self.coverView.frame = self.bounds;
    self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    [self addSubview:self.coverView];
    
    // 顶部View
    UIView * topView = [[UIView alloc] init];
    
    CGFloat topView_X = 0;
    CGFloat topView_Y = 5;
    CGFloat topView_W = WH_alertView_width;
    CGFloat topView_H = 30;
    topView.frame = CGRectMake(topView_X, topView_Y, topView_W, topView_H);
    
    UILabel * label = [[UILabel alloc] init];
    label.frame = topView.bounds;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请输入支付密码";
    label.font = [UIFont boldSystemFontOfSize:15.0f];
    [topView addSubview:label];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(5, 0, topView_H, topView_H);
    cancelBtn.backgroundColor = [UIColor blueColor];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    
    // 分割线
    UIView * marginView = [[UIView alloc] init];
    CGFloat marginView_X = 0;
    CGFloat marginView_Y = CGRectGetMaxY(topView.frame);
    CGFloat marginView_W = topView_W;
    CGFloat marginView_H = 0.5;
    
    marginView.frame = CGRectMake(marginView_X, marginView_Y, marginView_W, marginView_H);
    
    marginView.backgroundColor = [UIColor cyanColor];
    
    // 中间View
    UIView * middleView = [[UIView alloc] init];
    CGFloat middleView_X = 0;
    CGFloat middleView_Y = CGRectGetMaxY(marginView.frame) + margin_Y;
    CGFloat middleView_W = topView_W;
    CGFloat middleView_H = 90;
    
    middleView.frame = CGRectMake(middleView_X, middleView_Y, middleView_W, middleView_H);
    
    // 内容标题
    UILabel * message_label = [[UILabel alloc] init];
    message_label.textAlignment = NSTextAlignmentCenter;
    message_label.text = self.messageTitle;
    message_label.font = [UIFont systemFontOfSize:message_text_fond];
    CGSize message_labelSize = [self sizeWithText:message_label.text font:[UIFont systemFontOfSize:message_text_fond] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    // 设置Message的frame
    CGFloat message_label_X = margin_X;
    CGFloat message_label_Y;
    if (message_label.text == nil) {
        message_label_Y = 5.0f;
    } else {
        message_label_Y = margin_Y;
    }
    
    CGFloat message_label_W = WH_alertView_width - 2 * message_label_X;
    CGFloat message_label_H = message_labelSize.height;
    message_label.frame = CGRectMake(message_label_X, message_label_Y, message_label_W, message_label_H);
    
    [middleView addSubview:message_label];
    
    // 金额
    UILabel * amount_label = [[UILabel alloc] init];
    amount_label.textAlignment = NSTextAlignmentCenter;
    amount_label.text = [NSString stringWithFormat:@"¥%.2f",self.amountTitle];
    amount_label.font = [UIFont boldSystemFontOfSize:amount_text_fond];
    CGSize amount_labelSize = [self sizeWithText:amount_label.text font:amount_label.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat amount_label_X = margin_X;
    CGFloat amount_label_Y = CGRectGetMaxY(message_label.frame) + 10;
    CGFloat amount_label_W = WH_alertView_width - 2 * amount_label_X;
    CGFloat amount_label_H = amount_labelSize.height;
    amount_label.frame = CGRectMake(amount_label_X, amount_label_Y, amount_label_W, amount_label_H);
    
    [middleView addSubview:amount_label];
    
    // 底部View
    UIView * bottomView = [[UIView alloc] init];
    CGFloat bottomView_X = margin_X;
    CGFloat bottomView_Y = CGRectGetMaxY(middleView.frame) + margin_Y;
    CGFloat bottomView_W = middleView_W - 2 * margin_X;
    CGFloat bottomView_H = bottomView_W / 6;
    
    bottomView.frame = CGRectMake(bottomView_X, bottomView_Y, bottomView_W, bottomView_H);
    bottomView.backgroundColor = [UIColor redColor];
    
    WHPayPasswordView * payPassword = [[WHPayPasswordView alloc] initWithFrame:bottomView.bounds];
    payPassword.squareSize = bottomView_H;
    payPassword.delegate = self;
    
    [bottomView addSubview:payPassword];
    
    // 背景View
    self.bg_view = [[UIView alloc] init];
    CGFloat bg_viewW = WH_alertView_width;
    CGFloat bg_viewH =  topView.frame.size.height + middleView.frame.size.height + bottomView.frame.size.height + 3 * margin_Y + 5;
    CGFloat bg_viewX = WH_margin_X;
    CGFloat bg_viewY = (WH_screenHeight - bg_viewH) / 3;
    _bg_view.frame = CGRectMake(bg_viewX, bg_viewY, bg_viewW, bg_viewH);
    _bg_view.layer.cornerRadius = 10.f;
    _bg_view.layer.masksToBounds = YES;
    _bg_view.backgroundColor = [UIColor whiteColor];
    
    [_bg_view addSubview:topView];
    [_bg_view addSubview:marginView];
    [_bg_view addSubview:middleView];
    [_bg_view addSubview:bottomView];
    [self.coverView addSubview:_bg_view];
}



/** 视图销毁 */
- (void)dismiss {
    
    [UIView animateWithDuration:WH_animateWithDuration animations:^{
        
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)animationWithAlertView {
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.15f;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray * values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    animation.values = values;
    [self.bg_view.layer addAnimation:animation forKey:nil];
}


- (void)cancelBtnClick {
    [UIView animateWithDuration:WH_animateWithDuration animations:^{
        [self dismiss];
    }];
}

#pragma mark - - - PayPasswordViewDelegate - - -

- (void)passwordCompleteInput:(WHPayPasswordView *)password {
    
    [UIView animateWithDuration:WH_animateWithDuration animations:^{
        [self dismiss];
    }];
}


@end
