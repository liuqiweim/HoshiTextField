//
//  JHTextField.m
//  ezichart
//
//  Created by 刘淇伟 on 2019/7/17.
//  Copyright © 2019 刘淇伟. All rights reserved.
//

#import "JHTextField.h"
#import "UIView+Extension.h"
#import "NSString+YYSomeAdd.h"

@interface JHTextField ()

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UIImageView *leftImageView;

@end
@implementation JHTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configDefaultValues];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configDefaultValues];
    }
    return self;
}

- (void)configDefaultValues {
    self.leftViewType = JHYTextFieldTypeNone;
    self.textLeftMargin = 0;
    self.textRightMargin = 0;
    self.leftTextColor = [UIColor blackColor];
    self.leftTextFont = [UIFont systemFontOfSize:14];
}

#pragma mark - Over Write

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    if (_leftWidth > 0) {
        self.leftLabel.width = _leftWidth;
        self.leftImageView.width = _leftWidth;
        if (_leftLabelMarginX>0) {
            self.leftLabel.frame=CGRectMake(_leftLabelMarginX, 0, self.leftLabel.width, 50);
        }
    }
    CGRect rect = bounds;
    switch (_leftViewType) {
        case JHYTextFieldTypeText:
            rect.size.width = self.leftLabel.size.width;
            break;
        case JHYTextFieldTypeImage:
            rect.size.width = self.leftImageView.size.width;
            rect.origin.x = 5;
            break;
        case JHYTextFieldTypeNone:
            rect = [super leftViewRectForBounds:bounds];
            break;
    }
    return rect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect leftRect = [self leftViewRectForBounds:bounds];
    CGRect rightRect = [self rightViewRectForBounds:bounds];
    
    CGFloat left = self.textLeftMargin + CGRectGetMaxX(leftRect);
    CGFloat width = CGRectGetMinX(rightRect) - left - self.textRightMargin;
    ///  文本区域rect
    return CGRectMake(left, CGRectGetMinY(bounds), width, CGRectGetHeight(bounds));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

#pragma mark - Custom Accessors

- (void)setLeftViewType:(JHYTextFieldType)leftViewType {
    _leftViewType = leftViewType;
    self.leftView = nil;
    switch (leftViewType) {
        case JHYTextFieldTypeText: {
            self.leftView = self.leftLabel;
            self.leftViewMode = UITextFieldViewModeAlways;
        }
            break;
        case JHYTextFieldTypeImage:{
            self.leftView = self.leftImageView;
            self.leftViewMode = UITextFieldViewModeAlways;
        }
            break;
        case JHYTextFieldTypeNone:{
            self.leftView = nil;
            self.leftViewMode = UITextFieldViewModeNever;
        }
            break;
    }
    [self setNeedsDisplay];
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.textColor = self.textColor;
        _leftLabel.font = self.font;
    }
    return _leftLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftImageView.contentMode = UIViewContentModeCenter;
    }
    return _leftImageView;
}

- (void)setTextLeftMargin:(CGFloat)textLeftMargin {
    if (_textLeftMargin == textLeftMargin) {
        return;
    }
    _textLeftMargin = textLeftMargin;
    [self setNeedsLayout];
}

- (void)setTextRightMargin:(CGFloat)textRightMargin {
    if (_textRightMargin == textRightMargin) {
        return;
    }
    _textRightMargin = textRightMargin;
    [self setNeedsLayout];
}

- (void)setLeftTextColor:(UIColor *)leftTextColor {
    _leftTextColor = leftTextColor;
    self.leftLabel.textColor = _leftTextColor;
}

- (void)setLeftTextFont:(UIFont *)leftTextFont {
    _leftTextFont = leftTextFont;
    self.leftLabel.font = _leftTextFont;
    
}

- (void)setLeftText:(NSString *)leftText {
    _leftText = leftText;
    self.leftLabel.text = _leftText;
    self.leftLabel.size = [_leftText sizeForFont:self.leftLabel.font size:CGSizeMake(MAXFLOAT, 100) mode:NSLineBreakByWordWrapping];
}

- (void)setLeftImage:(UIImage *)leftImage {
    _leftImage = leftImage;
    self.leftImageView.image = leftImage;
    self.leftImageView.size = leftImage.size;
    
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.leftLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    self.leftLabel.textColor = textColor;
}
- (void)LabelAlightLeftAndRightWithWidth:(CGFloat)labelWidth {
    CGSize testSize = [self.leftLabel.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :self.font} context:nil].size;
    
    CGFloat margin = (labelWidth - testSize.width)/(self.leftLabel.text.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.leftLabel.text];
    
    [attribute addAttribute: NSKernAttributeName value:number range:NSMakeRange(0, self.leftLabel.text.length - 1 )];
    self.leftLabel.attributedText = attribute;
}

@end
