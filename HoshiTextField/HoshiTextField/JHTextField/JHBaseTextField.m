//
//  JHBaseTextField.m
//  ezichart
//
//  Created by 刘淇伟 on 2019/7/17.
//  Copyright © 2019 刘淇伟. All rights reserved.
//

#import "JHBaseTextField.h"

#import "Masonry.h"
#import "NSString+Length.h"


NSString *const JHYTextFieldValidateChangedNotification = @"JHYTextFieldValidateChangedNotification";

@interface JHBaseTextField ()
@property (nonatomic, strong) UILabel *errorLable;
@end
@implementation JHBaseTextField
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefault];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefault];
    }
    return self;
}

- (void)setDefault {
    self.validateOnChange = NO;
    self.maxLength = NSUIntegerMax;
    self.errorMessageHidden = YES;
    self.errorLeftMargin = 0;
    self.errorTextColor = [UIColor colorWithRed:1.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
    self.errorTextFont = [UIFont systemFontOfSize:12];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self];
    }else{
        [self.errorLable removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
- (void)didMoveToSuperview {
    if (self.superview) {
        [self.superview addSubview:self.errorLable];
        [self.errorLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(self.errorLeftMargin);
            make.top.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(@17);
        }];
    }
}

#pragma mark - Events
- (void)textFieldDidBeginEditing:(NSNotification *)obj {
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self animateViewsForTextEntry];
    });
    // 再次开始编辑隐藏error
    self.errorMessageHidden = YES;
}

- (void)textFieldDidEndEditing:(NSNotification *)obj {
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self animateViewsForTextDisplay];
    });
    if (self.validateOnChange) {
        // 判断当前输入结果是否正确，不正确显示错误消息，正确隐藏错误消息
        self.errorMessageHidden = self.isValidate;
    }
}

-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    //长度输入限制
    if (self.maxLength > 0) {
        NSString *toBeString = self.text;
        //记录当前光标位置
        NSRange currentRange = [self selectedRange];
        //用于标记是否有被选择的关联文字(比如中文输入)
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮文字部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        if (position == nil) {
            //根据最大输入长度maxLength截取文本
            textField.text = [toBeString substringWithMaxLength:self.maxLength];
            //如果location已经大于当前文本的长度，说明此时已经达到输入上限,设置光标始终位于末尾。
            //如果不做设置，光标会直接跑到开头
            if (currentRange.location > textField.text.length) {
                currentRange.location = textField.text.length;
            }
            //需要设置焦点位置，保证焦点在当前位置。否则每次value chang后焦点都会在最后显示
            [self setSelectedRange:currentRange];
        }
    }
    if (self.validateOnChange) {
        // 判断当前输入结果是否正确，不正确显示错误消息，正确隐藏错误消息
        self.errorMessageHidden = self.isValidate;
        [[NSNotificationCenter defaultCenter] postNotificationName:JHYTextFieldValidateChangedNotification object:nil];
    }
}

#pragma mark - Over write

- (void)animateViewsForTextEntry {
    NSAssert([self respondsToSelector:@selector(animateViewsForTextEntry)], @"/%s必须被重用/",__FUNCTION__);
}

- (void)animateViewsForTextDisplay {
    NSAssert([self respondsToSelector:@selector(animateViewsForTextDisplay)], @"/%s必须被重用",__FUNCTION__);
}

- (void)animateViewsForErrorMessage:(UILabel *)errorLabel {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (self.errorMessageHidden) {
            // 隐藏
            self.errorLable.alpha = 0;
        }else {
            self.errorLable.alpha = 1;
        }
    } completion:nil];
}

#pragma mark - Private
- (BOOL)validateRegex {
    // 没有正则限制
    if (![self.textRegex isNotBlank]) {
        return YES;
    }
    // 判断输入是否符合正则
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.textRegex];
    return [pred evaluateWithObject:self.text];
}

- (NSRange)selectedRange {
    
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning
                                             toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart
                                           toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange)range {
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:begin
                                                        offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:begin
                                                      offset:range.location + range.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition
                                                   toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}


#pragma mark - Custom Accessors

- (UILabel *)errorLable {
    if (!_errorLable) {
        _errorLable = [[UILabel alloc] init];
        _errorLable.backgroundColor = [UIColor clearColor];
        _errorLable.textAlignment = NSTextAlignmentLeft;
        _errorLable.numberOfLines = 1;//不换行
        _errorLable.lineBreakMode = NSLineBreakByTruncatingTail;
        _errorLable.alpha = 0;
    }
    return _errorLable;
}

- (BOOL)isValidate {
    NSUInteger textLength = [self.text isNotBlank]?self.text.length:0;
    if (textLength == 0 && self.minLength == 0) {
        // minLength = 0表示可以为空，此时未输入，所以验证通过
        return YES;
    }
    /// 输入长度满足最小限制，并且符合格式，验证通过
    /// 任何一项不满足，验证失败
    return (textLength >= self.minLength) && [self validateRegex];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    if (@available(iOS 13, *)) {
        if(self.placeholder.length > 0){
            NSMutableAttributedString *placeAtt = [[NSMutableAttributedString alloc]initWithString:self.placeholder];
            [placeAtt addAttribute:NSForegroundColorAttributeName value:placeholderColor range:NSMakeRange(0, self.placeholder.length)];
            self.attributedPlaceholder = placeAtt;
        }
    } else {
        _placeholderColor = placeholderColor;
        [self setValue:_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
   
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
   
    if (@available(iOS 13, *)) {
        if(self.placeholder.length > 0){
            NSMutableAttributedString *placeAtt = [[NSMutableAttributedString alloc]initWithString:self.placeholder];
            [placeAtt addAttribute:NSFontAttributeName value:placeholderFont range:NSMakeRange(0, self.placeholder.length)];
            self.attributedPlaceholder = placeAtt;
        }
    } else {
        _placeholderFont = placeholderFont;
        [self setValue:_placeholderFont forKeyPath:@"_placeholderLabel.font"];
    }
}

- (void)setErrorMessageHidden:(BOOL)errorMessageHidden {
    if (_errorMessageHidden == errorMessageHidden) {
        return;
    }
    _errorMessageHidden = errorMessageHidden;
    [self animateViewsForErrorMessage:self.errorLable];
}

- (void)setErrorTextFont:(UIFont *)errorTextFont {
    _errorTextFont = errorTextFont;
    self.errorLable.font = _errorTextFont;
}

- (void)setErrorTextColor:(UIColor *)errorTextColor {
    _errorTextColor = errorTextColor;
    self.errorLable.textColor = _errorTextColor;
}

- (void)setErrorLeftMargin:(CGFloat)errorLeftMargin {
    _errorLeftMargin = errorLeftMargin;
    if (self.errorLable.superview) {
        [self.errorLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(_errorLeftMargin);
        }];
    }
}

- (void)setErrorMessage:(NSString *)errorMessage {
    _errorMessage = errorMessage;
    self.errorLable.text = _errorMessage;
}
@end
