//
//  BookSimpleCell.m
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "BookSimpleCell.h"
#import "PGBook.h"
#import "CustomViews.h"
#import "UIImageView+AFNetworking.h"

@interface BookSimpleCell ()

@property (nonatomic, strong) NSString * url;

@end

@implementation BookSimpleCell

+ (void)registOnTableView:(UITableView *)tableview
{
    [tableview registerNib:[UINib nibWithNibName:[BookSimpleCell identifier] bundle:nil]
    forCellReuseIdentifier:[BookSimpleCell identifier]];
}

+ (NSString *)identifier {
    return NSStringFromClass([BookSimpleCell class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.coverView.contentMode = UIViewContentModeScaleToFill;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.coverView cancelImageDownloadTask];
    
    self.coverView.image        = nil;
    self.titleLabel.text        = nil;
    self.subtitleLabel.text     = nil;
    self.priceLabel.text        = nil;
    self.url                    = nil;
    self.numberLabel.text       = nil;
}

- (void)bindData:(PGBook *)book
{
    self.key = book.isbn13;
    
    self.titleLabel.text        = book.title;
    self.subtitleLabel.text     = book.subtitle;
    self.priceLabel.text        = book.price;
    self.url                    = book.url;
    self.numberLabel.text       = book.isbn13;
    
    [self loadIamge:book.image];
}

- (void)loadIamge:(NSString *)imageURL {
    if (!imageURL) { return; }
    
    NSURLRequest * url = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    
    __weak __typeof(self)weakSelf = self;
    [self.coverView setImageWithURLRequest:url
                          placeholderImage:nil
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       __strong __typeof(self)strongSelf = weakSelf;
                                       strongSelf.coverView.image = image;
                                       
                                       [strongSelf.coverView setNeedsLayout];
                                       [strongSelf.coverView layoutIfNeeded];
                                   } failure:nil];
}

- (IBAction)onClickButton:(id)sender {
    if (self.url == nil) { return; }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]
                                       options:@{}
                             completionHandler:nil];
}

@end
