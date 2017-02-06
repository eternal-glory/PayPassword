//
//  WHPasswordView.h
//  PasswordView
//
//  Created by 西太科技 on 2017/2/6.
//  Copyright © 2017年 lei wenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PasswordViewSuper;

@interface PasswordViewSuper : UIView


+ (instancetype)wh_passwordViewWithTitle:(NSString *)title amount:(NSString *)amount;

- (void)show;

@end
