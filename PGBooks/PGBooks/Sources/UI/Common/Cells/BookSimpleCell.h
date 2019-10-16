//
//  BookSimpleCell.h
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PaddingLabel;
@class PGBook;

@interface BookSimpleCell : UITableViewCell

@property (nonatomic, strong) NSString * key;

@property (weak, nonatomic) IBOutlet UIImageView  *coverView;
@property (weak, nonatomic) IBOutlet PaddingLabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel      *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel      *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton     *storeLinkButton;
@property (weak, nonatomic) IBOutlet PaddingLabel *numberLabel;

+ (NSString *)identifier;
+ (void)registOnTableView:(UITableView *)tableview;

- (void)bindData:(PGBook *)book;

@end

NS_ASSUME_NONNULL_END
