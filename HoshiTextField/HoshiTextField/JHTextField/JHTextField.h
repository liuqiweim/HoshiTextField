//
//  JHTextField.h
//  ezichart
//
//  Created by 刘淇伟 on 2019/7/17.
//  Copyright © 2019 刘淇伟. All rights reserved.
//

#import "JHBaseTextField.h"

NS_ASSUME_NONNULL_BEGIN

///  底部边框的位置
typedef NS_ENUM(NSUInteger, JHYTextFieldBorderType) {
    JHYTextFieldBorderTypeLeftMarginToTextLeft, // 左侧跟文本区域左侧对齐，右侧跟textField的右侧对齐
    JHYTextFieldBorderTypeRightMarginToTextRight, // 右侧跟文本区域右侧对齐，左侧跟textField的左侧对齐
    JHYTextFieldBorderTypeAligmentWithText, // 完全跟文本区域左右对齐
    JHYTextFieldBorderTypeFull // 从左到右覆盖整个textField的底部
};

///  自定义左右view的类型，分为文本类型，图片类型
typedef NS_ENUM(NSInteger, JHYTextFieldType) {
    JHYTextFieldTypeText,
    JHYTextFieldTypeImage,
    JHYTextFieldTypeNone
};

@interface JHTextField : JHBaseTextField

///  文本区域左右边距距，默认是0。
///  @warning 尽量不要直接使用此值用于计算，因为只有文本区域不覆盖左右view的情况下，此值才能代表左右边距
@property (nonatomic) CGFloat textLeftMargin;
@property (nonatomic) CGFloat textRightMargin;

///  自定义左侧view类型，默认是GACTextFieldTypeNone
@property (nonatomic) JHYTextFieldType leftViewType;

///  左侧文本对应的Label，leftViewType = GACTextFieldTypeText，此变量才会生效
@property (nonatomic, strong, readonly) UILabel *leftLabel;
///  设置左侧文本，leftViewType = GACTextFieldTypeText，此变量才会生效
@property (nonatomic, copy) NSString *leftText;
///  设置左侧文本颜色，leftViewType = GACTextFieldTypeText，此变量才会生效
@property (nonatomic, strong) UIColor *leftTextColor;
///  设置左侧文本字体，leftViewType = GACTextFieldTypeText，此变量才会生效
@property (nonatomic, strong) UIFont *leftTextFont;

///  左侧区域的图片，eftViewType = GACTextFieldTypeImage，此变量才会生效
@property (nonatomic, strong, readonly) UIImageView *leftImageView;
///  设置左侧图片，leftViewType = GACTextFieldTypeImage，此变量会生效
@property (nonatomic, strong) UIImage *leftImage;
///  设置左侧view宽度，默认是0，此时根据图片的宽度或者leftText字体宽度进行显示
@property (nonatomic) CGFloat leftWidth;
@property (nonatomic) CGFloat leftLabelMarginX;

- (void)LabelAlightLeftAndRightWithWidth:(CGFloat)labelWidth;
@end

NS_ASSUME_NONNULL_END
