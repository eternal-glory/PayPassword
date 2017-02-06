//
//  WHPayPasswordView.m
//  PayPassword
//
//  Copyright © 2017年 lei wenhao. All rights reserved.
//

#import "WHPayPasswordView.h"

static NSString * const MONEYNUMBERS = @"0123456789";

@interface WHPayPasswordView () <UIKeyInput>

@end

@implementation WHPayPasswordView

- (void)drawRect:(CGRect)rect {

    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat x = (width - self.squareSize * self.passwordNumber) / 2.0f;
    CGFloat y = (height - self.squareSize) / 2.0f;
    
    // 获取contextRef对象;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画外框
    // 获取边框大小
    CGRect conRect = CGRectMake(x, y, self.squareSize * self.passwordNumber, self.squareSize);
    // 向当前路径添加一个矩形
    CGContextAddRect(context, conRect);
    // 设置绘制直线、边框时的线宽 数组可以小数;
    CGContextSetLineWidth(context, 1);
    // 设置绘制线的颜色
    CGContextSetStrokeColorWithColor(context, self.rectColor.CGColor);
    // 使用指定颜色来实现该CGContextRef的填充颜色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // 画竖线
    for (int i = 1; i <= self.passwordNumber; i++) {
        // 向当前路径结束点移动到(x,y)点
        CGContextMoveToPoint(context, x + i * self.squareSize, y);
        // 向当前路径结束点连接到(x,y)点
        CGContextAddLineToPoint(context, x + i * self.squareSize, y + self.squareSize);
        // 关闭当前定义的路径
        CGContextClosePath(context);
    }
    // 使用指定模式绘制当前CGContextRef所包含的路径。第二个参数为枚举值进入API就可以选取所需的样式
    CGContextDrawPath(context, kCGPathFillStroke);
    // 使用指定颜色来实现该CGContextRef的填充颜色
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);
    
    // 画黑点
    for (int i = 1; i <= self.saveStore.length; i++) {
        // 向当前路径添加一段圆弧
        CGContextAddArc(context, x + i * self.squareSize - self.squareSize / 2.0f, y + self.squareSize / 2.0f, self.pointRadius, 0, M_PI * 2.0f, YES);
        //
        CGContextDrawPath(context, kCGPathFill);
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.saveStore = [NSMutableString string];
        self.passwordNumber = 6;
        self.pointRadius = 6;
        self.rectColor = [UIColor colorWithRed:54.0/255.0 green:59.0/255.0 blue:87.0/255.0 alpha:1.0];
        self.pointColor = [UIColor colorWithRed:54.0/255.0 green:59.0/255.0 blue:87.0/255.0 alpha:1.0];
        
        [self becomeFirstResponder];
    }
    
    return self;
}


/** 设置正方形的边长 */
- (void)setSquareSize:(CGFloat)squareSize {
    _squareSize = squareSize;
    [self setNeedsDisplay];
}

/** 设置键盘类型 */
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

/** 设置密码的位数 */
- (void)setPasswordNumber:(NSUInteger)passwordNumber {
    _passwordNumber = passwordNumber;
    [self setNeedsDisplay];
}

- (BOOL)becomeFirstResponder {
    
    if ([self.delegate respondsToSelector:@selector(passwordBeginInput:)]) {
        [self.delegate passwordBeginInput:self];
    }
    
    return [super becomeFirstResponder];
}

/** 是否能成为第一响应者 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

#pragma mark ----- UIKeyInput Delegate ----
/** 用于显示的文本对象是否有任何文本 */
- (BOOL)hasText {
    return self.saveStore.length > 0;
}

/** 插入文本 */
- (void)insertText:(NSString *)text {
    
    if (self.saveStore.length < self.passwordNumber) {
        
        NSCharacterSet * character = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        NSString * filtered = [[text componentsSeparatedByCharactersInSet:character] componentsJoinedByString:@""];
        
        BOOL fasicTest = [text isEqualToString:filtered];
        if (fasicTest) {
            [self.saveStore appendString:text];
            
            if ([self.delegate respondsToSelector:@selector(passwordDidChange:)]) {
                [self.delegate passwordDidChange:self];
            }
            
            if (self.saveStore.length == self.passwordNumber) {
                if ([self.delegate respondsToSelector:@selector(passwordCompleteInput:)]) {
                    [self.delegate passwordCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
        }
    }
}
/** 文本删除 */
- (void)deleteBackward {
    
    if (self.saveStore.length > 0) {
        
        [self.saveStore deleteCharactersInRange:NSMakeRange(self.saveStore.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passwordDidChange:)]) {
            [self.delegate passwordDidChange:self];
        }
        
    }
    [self setNeedsDisplay];
}

@end
