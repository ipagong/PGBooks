//
//  BookDetailController.h
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGBook;

NS_ASSUME_NONNULL_BEGIN

@protocol BookDetailTransitionTargetProtocol <NSObject>
- (UITableView *)tableview;
@end

@interface BookDetailController : UIViewController

+ (void)showWithBook:(PGBook *)book target:(UIViewController *)target;

@property (nonatomic, copy) PGBook * book;

@property (weak, readonly) UIImageView *coverView;
@property (weak, readonly) UIStackView *stackContainer;
@end

NS_ASSUME_NONNULL_END
