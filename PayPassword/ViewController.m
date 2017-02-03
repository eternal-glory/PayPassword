//
//  ViewController.m
//  PayPassword
//
//  Copyright © 2017年 lei wenhao. All rights reserved.
//

#import "ViewController.h"

#import "WHPayPasswordView.h"


#define K_SelfViewWidth self.view.frame.size.width

@interface ViewController () <PayPasswordViewDelegate>

@property (strong, nonatomic) UILabel * label;

@property (strong, nonatomic) UIButton * button;

@property (strong, nonatomic) WHPayPasswordView * payPwdView;

@property (strong, nonatomic) NSString * firstPassword;

@property (strong, nonatomic) NSString * secondPassword;

@end

@implementation ViewController

- (WHPayPasswordView *)payPwdView {
    
    if (!_payPwdView) {
        
        CGFloat x = CGRectGetMaxX(self.label.frame) + 10;
        CGFloat y = CGRectGetMinY(self.label.frame);
        CGFloat width = K_SelfViewWidth - x - 20;
        CGFloat height = CGRectGetHeight(self.label.frame);
        _payPwdView = [[WHPayPasswordView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _payPwdView.backgroundColor = [UIColor clearColor];
        _payPwdView.delegate = self;
        _payPwdView.squareSize = 30;
    }
    
    return _payPwdView;
}

- (UILabel *)label {
    
    if (!_label) {
        _label = [[UILabel alloc] init];
        [self.view addSubview:_label];
        _label.frame = CGRectMake(15, 60, 80, 30);
        _label.textAlignment = NSTextAlignmentRight;
        _label.font = [UIFont fontWithName:@"Heiti SC" size:15.f];
        _label.textColor = [UIColor colorWithRed:54.0/255.0 green:59.0/255.0 blue:87.0/255.0 alpha:1.0];
    }
    
    return _label;
}

- (UIButton *)button {
    
    if (!_button) {
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(K_SelfViewWidth - (CGRectGetWidth(self.label.frame) + 10), CGRectGetMaxY(self.label.frame) + 10, CGRectGetWidth(self.label.frame), CGRectGetHeight(self.label.frame));
        [_button setTitle:@"重置密码" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithRed:54.0/255.0 green:59.0/255.0 blue:87.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        _button.titleLabel.font = self.label.font;
        [_button addTarget:self action:@selector(resetPayPassword) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _button;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.label.text = @"新密码:";
    [self.view addSubview:self.payPwdView];
    [self.view addSubview:self.button];
    
}

#pragma mark --- PayPasswordViewDelegate ----

- (void)passwordBeginInput:(WHPayPasswordView *)password {
    NSLog(@"开始输入 : %@",password.saveStore);
}

- (void)passwordDidChange:(WHPayPasswordView *)password {
    NSLog(@"输入改变 : %@",password.saveStore);
}

- (void)passwordCompleteInput:(WHPayPasswordView *)password {
    
    NSLog(@"输入结束 : %@",password.saveStore);
    
    if ([_firstPassword isEqualToString:@""] || _firstPassword.length == 0) {
        
        NSString * string = password.saveStore;
        self.firstPassword = string;
        
        // 输入两次密码操作
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.label.text = @"确认密码:";
            [_payPwdView.saveStore deleteCharactersInRange:NSMakeRange(0, _payPwdView.saveStore.length)];
            [_payPwdView setNeedsDisplay];
        });
    } else if (_secondPassword.length == 0 || [_secondPassword isEqualToString:@""]) {
        
        self.secondPassword = password.saveStore;
        
    }
}


- (void)resetPayPassword {
    [_payPwdView.saveStore deleteCharactersInRange:NSMakeRange(0, _payPwdView.saveStore.length)];
    [_payPwdView setNeedsDisplay];
    
    self.label.text = @"新密码:";
    self.firstPassword = @"";
    self.secondPassword = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
