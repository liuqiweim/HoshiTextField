//
//  NSString+Length.h
//  门店管理
//
//  Created by 王健功 on 2018/2/6.
//  Copyright © 2018年 广汽出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Length)
///  获取字符串长度，一个中文对应两个字节，一个非中文对应1个字节
- (NSUInteger)lengthWithBytes;

///  限制字符串长度，截取超出部分。一个中文对应两个字节，一个非中文对应1个字节
///  @param maxLength 最大长度，超出部分截取掉。如果是0，表示不限制长度
///  @warning 执行此方法后会生成一个新的字符串
- (NSString *)substringWithMaxLength:(NSUInteger)maxLength;
-(BOOL)isNotBlank;
@end
