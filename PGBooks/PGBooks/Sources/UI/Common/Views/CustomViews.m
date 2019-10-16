//
//  CustomViews.m
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "CustomViews.h"

@implementation UIView (radius)

@dynamic cornerRadius;
@dynamic borderColor;
@dynamic borderWidth;

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

@end

@implementation PaddingLabel

#pragma mark - Super

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.topInset       = 0;
        self.bottomInset    = 0;
        self.leftInset      = 0;
        self.rightInset     = 0;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(self.topInset,
                                           self.leftInset,
                                           self.bottomInset,
                                           self.rightInset);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + self.leftInset + self.rightInset,
                      size.height + self.topInset + self.bottomInset);
}

@end

//@implementation RoundView
//- (void)setCornerRadius:(CGFloat)cornerRadius {
//    self.layer.cornerRadius = cornerRadius;
//}
//
//- (void)setBorderColor:(UIColor *)borderColor {
//    self.layer.borderColor = borderColor.CGColor;
//}
//
//- (void)setBorderWidth:(CGFloat)borderWidth {
//    self.layer.borderWidth = borderWidth;
//}
//@end

//@implementation RoundLabel
//- (void)setCornerRadius:(CGFloat)cornerRadius {
//    self.layer.cornerRadius = cornerRadius;
//}
//
//- (void)setBorderColor:(UIColor *)borderColor {
//    self.layer.borderColor = borderColor.CGColor;
//}
//
//- (void)setBorderWidth:(CGFloat)borderWidth {
//    self.layer.borderWidth = borderWidth;
//}
//@end
//
//@implementation RoundButton
//- (void)setCornerRadius:(CGFloat)cornerRadius {
//    self.layer.cornerRadius = cornerRadius;
//}
//
//- (void)setBorderColor:(UIColor *)borderColor {
//    self.layer.borderColor = borderColor.CGColor;
//}
//
//- (void)setBorderWidth:(CGFloat)borderWidth {
//    self.layer.borderWidth = borderWidth;
//}
//@end

