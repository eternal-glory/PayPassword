//
//  WHPayPasswordView.h
//  PayPassword
//
//  Copyright © 2017年 lei wenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHPayPasswordView;

@protocol PayPasswordViewDelegate <NSObject>

@optional
/** 监听输入的变化 */
- (void)passwordDidChange:(WHPayPasswordView *)password;

/** 监听开始输入 */
- (void)passwordBeginInput:(WHPayPasswordView *)password;

/** 监听输入完成时 */
- (void)passwordCompleteInput:(WHPayPasswordView *)password;

@end


@interface WHPayPasswordView : UIView

@property (assign, nonatomic) IBInspectable NSUInteger passwordNumber;///<密码的位数;

@property (assign, nonatomic) IBInspectable CGFloat squareSize;///<正方形大小;

@property (assign, nonatomic) IBInspectable CGFloat pointRadius;///<黑点半径;

@property (strong, nonatomic) IBInspectable UIColor * pointColor;///<黑点的颜色;

@property (strong, nonatomic) IBInspectable UIColor * rectColor;///<边框的颜色;

@property (strong, nonatomic) NSMutableString * saveStore;///<保存密码的字符串;

@property (weak, nonatomic) id<PayPasswordViewDelegate> delegate;

@end
