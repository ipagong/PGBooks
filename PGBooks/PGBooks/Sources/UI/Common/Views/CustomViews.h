//
//  CustomViews.h
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (radius)
@property (nonatomic, assign) IBInspectable CGFloat   cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat   borderWidth;
@property (nonatomic, strong) IBInspectable UIColor * borderColor;
@end

IB_DESIGNABLE
@interface PaddingLabel : UILabel
@property (nonatomic, assign) IBInspectable CGFloat topInset;
@property (nonatomic, assign) IBInspectable CGFloat bottomInset;
@property (nonatomic, assign) IBInspectable CGFloat leftInset;
@property (nonatomic, assign) IBInspectable CGFloat rightInset;
@end

NS_ASSUME_NONNULL_END
