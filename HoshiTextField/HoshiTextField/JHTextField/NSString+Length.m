//
//  NSString+Length.m
//  门店管理
//
//  Created by 王健功 on 2018/2/6.
//  Copyright © 2018年 广汽出行. All rights reserved.
//

#import "NSString+Length.h"

@implementation NSString (Length)

- (NSUInteger)lengthWithBytes {
    NSUInteger length = 0;
    for (int index = 0; index < [self length]; index ++) {
        NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            length += 2;
        }else {
            length += 1;
        }
    }
    return length;
}

- (NSString *)substringWithMaxLength:(NSUInteger)maxLength {
    NSString *substring = [NSString string];
    if (maxLength > 0) {
        //如果设置了可输入最大长度，按照最大长度截取当前字符串，并将最后的结果返回
        NSUInteger length = 0;
        
        for (int index = 0; index < [self length]; index++) {
            //遍历字符串，获取截取后的字符串
            NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
            
            if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
                length = length+2;//中文
            } else {
                length = length+1;
            }
            if (length <= maxLength) {
                substring = [substring stringByAppendingString:character];
            }else{
                // 超出长度什么都不做
                break;
            }
        }
    }else{
        // 最大长度为0，表示不设置长度显示
        substring = [self copy];
    }
    return substring;
}
@end
