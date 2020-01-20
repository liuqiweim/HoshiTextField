//
//  JHHoshiTextField.h
//  ezichart
//
//  Created by 刘淇伟 on 2019/7/17.
//  Copyright © 2019 刘淇伟. All rights reserved.
//

#import "JHTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHHoshiTextField : JHTextField
///  底部边框的位置，默认是JHYTextFieldBorderTypeFull
@property (nonatomic) JHYTextFieldBorderType borderType;
///  未编辑状态底部边框颜色和边框高度
@property (nonatomic, strong) UIColor *borderInactiveColor;
@property (nonatomic) CGFloat borderInactiveHeight;
///  编辑状态底部边框颜色和边框高度
@property (nonatomic, strong) UIColor *borderActiveColor;
@property (nonatomic) CGFloat borderActiveHeight;
@end

NS_ASSUME_NONNULL_END
