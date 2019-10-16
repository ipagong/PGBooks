//
//  SearchHistoryCell.h
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *queryLabel;

+ (void)registOnTableView:(UITableView *)tableview;
+ (NSString *)identifier;
- (void)bindData:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
