//
//  ViewController.m
//  PasswordView
//
//  Created by 西太科技 on 2017/2/6.
//  Copyright © 2017年 lei wenhao. All rights reserved.
//

#import "ViewController.h"
#import "PasswordViewSuper.h"

#define Screen [UIScreen mainScreen].bounds

@interface ViewController ()


@property (strong, nonatomic) NSString * amount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    
    UILabel * title = [[UILabel alloc] init];
    title.frame = CGRectMake(20, 100, 100, 30);
    title.text = @"提现金额";
    [self.view addSubview:title];
    
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, CGRectGetMaxY(title.frame) + 20, 100, 30);
    label.text = @"¥";
    label.font = [UIFont boldSystemFontOfSize:17.0f];
    [label sizeToFit];
    [self.view addSubview:label];
    
    UITextField * textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(CGRectGetMaxX(label.frame) + 20, CGRectGetMidY(label.frame), 100, 30);
    [textField becomeFirstResponder];
    textField.keyboardType = UIKeyboardTypeNumberPad;

    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textField];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, 0, Screen.size.width - 60, 35);
    button.backgroundColor = [UIColor cyanColor];
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"提取" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];

}

- (void)textFieldDidChange:(UITextField *)textField {
    self.amount = textField.text;
}

- (void)buttonClick {
    
    PasswordViewSuper * passwordVS = [PasswordViewSuper wh_passwordViewWithTitle:@"提现" amount:self.amount];
    [passwordVS show];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
