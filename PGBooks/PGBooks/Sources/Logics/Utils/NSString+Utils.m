//
//  NSString+Utils.m
//  PGBooks
//
//  Created by ipagong on 15/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (nonnull NSString *)orEmpty:(nullable NSString *)checkable {
    if (checkable) { return checkable; }
    return self;
}

@end
