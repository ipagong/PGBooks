//
//  SearchHistoryCell.m
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "SearchHistoryCell.h"

@implementation SearchHistoryCell

+ (void)registOnTableView:(UITableView *)tableview
{
    [tableview registerNib:[UINib nibWithNibName:[SearchHistoryCell identifier] bundle:nil]
    forCellReuseIdentifier:[SearchHistoryCell identifier]];
}

+ (NSString *)identifier {
    return NSStringFromClass([SearchHistoryCell class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.queryLabel.text = nil;
}

- (void)bindData:(NSString *)text {
    self.queryLabel.text = text;
}

@end
