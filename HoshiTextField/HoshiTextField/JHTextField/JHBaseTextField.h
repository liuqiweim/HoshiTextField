//
//  JHBaseTextField.h
//  ezichart
//
//  Created by 刘淇伟 on 2019/7/17.
//  Copyright © 2019 刘淇伟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TextFieldErrorAlignment) {
    TextFieldErrorAlignmentTextBounds, // 默认值，和输入区域左对齐
    TextFieldErrorAlignmentLeft  // 整个文本框左对齐
};

@interface JHBaseTextField : UITextField
#pragma mark - 占位符相关设置

///  修改placeholder颜色，默认是nil。如果是nil，使用默认占位符字体颜色
@property (nonatomic, strong, nullable) UIColor *placeholderColor;

///  修改placeholder的字体，默认是nil。如果是nil，使用默认占位符字体
@property (nonatomic, strong, nullable) UIFont *placeholderFont;

#pragma mark - 输入限制相关设置

///  是否在输入过程中实时验证，默认是NO。
///  开启后在输入过程中，如果有错误会直接在输入框下方显示错误消息
@property (nonatomic) BOOL validateOnChange;

///  isValidate当前输入是否符合要求。
///  YES，表示完全符合minLength以及textRegex两个的限制
@property (nonatomic) BOOL isValidate;

///  设置最大输入字数，任何字符都只算一个字数。默认是无限大
@property (nonatomic) NSUInteger maxLength;

///  设置最小输入字数，任何字符都算一个字数。默认是0，表示可以为空，如果大于0，表示不可为空
@property (nonatomic) NSUInteger minLength;

///  输入文本正则表达式，如果输入文本不符合此规则isValidate = NO。默认为nil
@property (nonatomic, strong, nullable) NSString *textRegex;

#pragma mark - 错误提示相关
///  错误提示文本，默认为nil。
@property (nonatomic, strong, nullable) NSString *errorMessage;

///  设置错误消息隐藏，默认是NO。
@property (nonatomic) BOOL errorMessageHidden;

///  设置错误提示显示的左边距，默认是0。
@property (nonatomic) CGFloat errorLeftMargin;

///  错误提示文字颜色
@property (nonatomic, strong) UIColor *errorTextColor;

///  错误提示文字字体，默认是[UIFont systemFontOfSize:12]
@property (nonatomic, strong) UIFont *errorTextFont;

#pragma mark - Over write
/**
 *  以下为子类重写的方法
 */
///  编辑开始时执行的一些动画,需要在子类中重写
- (void)animateViewsForTextEntry;

///  编辑结束是执行的一些动画,需要在子类中重写
- (void)animateViewsForTextDisplay;

///  错误消息显示隐藏时的一些动画，默认是淡出淡入的动画，可重写自定义
///  @param errorLabel 错误提示框
- (void)animateViewsForErrorMessage:(UILabel *)errorLabel;
@end

NS_ASSUME_NONNULL_END
