//
//  JHHoshiTextField.m
//  ezichart
//
//  Created by 刘淇伟 on 2019/7/17.
//  Copyright © 2019 刘淇伟. All rights reserved.
//

#import "JHHoshiTextField.h"
@interface JHHoshiTextField ()

@property (nonatomic, strong) CALayer *inactiveBorderLayer;
@property (nonatomic, strong) CALayer *activeBorderLayer;

@end
@implementation JHHoshiTextField


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configDefault];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configDefault];
    }
    return self;
}

- (void)configDefault {
    self.borderType = JHYTextFieldBorderTypeFull;
    self.borderInactiveHeight = 1;
    self.borderInactiveColor = [UIColor grayColor];
    self.borderActiveHeight = 1;
    self.borderActiveColor = [UIColor greenColor];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //设置默认显示非活跃状态
    self.inactiveBorderLayer.frame = [self rectForBorder:self.borderInactiveHeight isFull:true];
    self.activeBorderLayer.frame = [self rectForBorder:self.borderActiveHeight isFull:false];
    [self.layer addSublayer:self.inactiveBorderLayer];
    [self.layer addSublayer:self.activeBorderLayer];
}

#pragma mark - OverWrite
- (void)animateViewsForTextEntry {
    // 编辑状态
    self.activeBorderLayer.frame = [self rectForBorder:self.borderActiveHeight isFull:true];
    self.inactiveBorderLayer.frame = [self rectForBorder:self.borderInactiveHeight isFull:false];
}

- (void)animateViewsForTextDisplay {
    //停止编辑时，如果当前输入为nil，视为非活跃状态，如果有输入文本视为活跃状态
    if (self.text.length == 0 || !self.text) {
        self.inactiveBorderLayer.frame = [self rectForBorder:self.borderInactiveHeight isFull:true];
        self.activeBorderLayer.frame = [self rectForBorder:self.borderActiveHeight isFull:false];
    }
}

#pragma mark - Public

#pragma mark - Private

///  计算底框的rect。isFull表示是否显示，通过此控制底框是否显示。isFull是NO时，对应底框宽度为0
- (CGRect)rectForBorder:(CGFloat)thickness isFull:(BOOL)isFull {
    CGRect rect = [self textRectForBounds:self.bounds];
    CGFloat borderX = 0;
    CGFloat borderWidth = 0;
    
    switch (self.borderType) {
        case JHYTextFieldBorderTypeFull: {
            borderX = 0;
            borderWidth = CGRectGetWidth(self.bounds);
        }
            break;
        case JHYTextFieldBorderTypeAligmentWithText: {
            borderX = CGRectGetMinX(rect);
            borderWidth = CGRectGetWidth(rect);
        }
            break;
        case JHYTextFieldBorderTypeRightMarginToTextRight:{
            borderX = 0;
            borderWidth = CGRectGetMaxX(rect);
        }
            
            break;
        case JHYTextFieldBorderTypeLeftMarginToTextLeft:{
            borderX = CGRectGetMinX(rect);
            borderWidth = CGRectGetWidth(self.bounds) - borderX;
        }
            
            break;
    }
    if (isFull) {
        return CGRectMake(borderX, CGRectGetHeight(rect) - thickness, borderWidth, thickness);
    }else{
        return CGRectMake(borderX, CGRectGetHeight(rect) - thickness, 0, thickness);
    }
}

#pragma mark - Custom Accessors

- (CALayer *)inactiveBorderLayer {
    if (!_inactiveBorderLayer) {
        _inactiveBorderLayer = [CALayer layer];
    }
    return _inactiveBorderLayer;
}

- (CALayer *)activeBorderLayer {
    if (!_activeBorderLayer) {
        _activeBorderLayer = [CALayer layer];
    }
    return _activeBorderLayer;
}

- (void)setBorderInactiveColor:(UIColor *)borderInactiveColor {
    _borderInactiveColor = borderInactiveColor;
    self.inactiveBorderLayer.backgroundColor = self.borderInactiveColor.CGColor;
}

- (void)setBorderActiveColor:(UIColor *)borderActiveColor {
    _borderActiveColor = borderActiveColor;
    self.activeBorderLayer.backgroundColor = self.borderActiveColor.CGColor;
}

@end
