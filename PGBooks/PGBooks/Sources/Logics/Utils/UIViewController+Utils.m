//
//  UIViewController+Utils.m
//  PGBooks
//
//  Created by ipagong on 15/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

- (UIViewController *)lastChildren {
    UIViewController * result = self;
    while (result.childViewControllers.lastObject) {
        result = result.childViewControllers.lastObject;
    }
    return result;
}

@end
