//
//  BookDetailController.m
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "BookDetailController.h"
#import "CustomViews.h"
#import "PGBook.h"
#import "ITBookService.h"
#import "UserDataService.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Utils.h"
#import <PGTransitionKit-Swift.h>

@interface BookDetailController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *coverView;

@property (weak, nonatomic) IBOutlet UIStackView *stackContainer;

@property (weak, nonatomic) IBOutlet PaddingLabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UILabel *isbn13Label;
@property (weak, nonatomic) IBOutlet UILabel *isbn10Label;


@property (weak, nonatomic) IBOutlet UIStackView *ratingContainer;

@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *etcLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *languagesLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic, strong) PGAnimator * animator;
@property (nonatomic, strong) PGScrollDownInteractor * interactor;

@end

@implementation BookDetailController

#pragma mark - create

+ (void)showWithBook:(PGBook *)book target:(UIViewController *)target {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"BookDetail" bundle:nil];
    BookDetailController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BookDetailController class])];
    [UserDataService addGlanceBook:book];
    vc.book = book;
    
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    vc.animator = [[PGAnimator alloc] initWithTarget:target presenting:vc];
    vc.animator.presentDuration = 0.3;
    vc.animator.dismissDuration = 0.3;
    
    [vc.animator presentAnimatorViewControllerWithAnimated:YES];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupUI];
    
    self.interactor = [[PGScrollDownInteractor alloc] initWithTargetView:self.scrollView];
    self.animator.dismissInteractor = self.interactor;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dataLoad];
}

#pragma mark -

- (void)setupUI {
    if (!self.book) { return; }
    
    [self.priceLabel        setText:[@"----" orEmpty:self.book.price]];
    [self.isbn13Label       setText:[@"----" orEmpty:self.book.isbn13]];
    [self.isbn10Label       setText:[@"----" orEmpty:self.book.isbn10]];
    [self.bookTitleLabel    setText:[@"----" orEmpty:self.book.title]];
    [self.bookSubtitleLabel setText:[@"----" orEmpty:self.book.subtitle]];
    [self.etcLabel          setText:[@"----" orEmpty:self.book.etcs]];
    [self.authorsLabel      setText:[@"----" orEmpty:self.book.authors]];
    [self.publisherLabel    setText:[@"----" orEmpty:self.book.publisher]];
    [self.languagesLabel    setText:[@"----" orEmpty:self.book.language]];
    [self.descLabel         setText:[@"----" orEmpty:self.book.desc]];
    
    [self.favoriteButton setSelected:[[UserDataService favoriteBooks] containsObject:self.book]];
    
    if (self.book.image) {
        [self.coverView setImageWithURL:[NSURL URLWithString:self.book.image]];
    }
    
    for (UIImageView *imgView in self.ratingContainer.subviews) {
        if ([imgView isKindOfClass:[UIImageView class]] == NO) { return; }
        if (!self.book.rating) { [imgView setHighlighted:false]; }
        BOOL on = ([self.book.rating integerValue] >= imgView.tag);
        [imgView setHighlighted:on];
    }
}

- (IBAction)onClickFavorite:(id)sender {
    if ([[UserDataService favoriteBooks] containsObject:self.book] == YES) {
        [UserDataService removeFavoriteBookWithObject:self.book];
    } else {
        [UserDataService addFavoriteBook:self.book];
    }
    
    [self setupUI];
}

- (IBAction)onClickLink:(id)sender {
    if (self.book.url == nil) { return; }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.book.url]
                                       options:@{}
                             completionHandler:nil];
}

- (IBAction)onClickClose:(id)sender {
    [self.animator dismissAnimatorViewControllerWithAnimated:YES];
}

- (void)dataLoad {
    if (self.book.isbn10 && self.book.isbn10.length > 0) { return; }
    
    __weak __typeof(self)weakSelf = self;
    [ITBookService getDetailBookInfo:self.book.isbn13
                          completion:^(PGBook * _Nonnull book, NSError * _Nonnull error) {
                              __strong __typeof(self)strongSelf = weakSelf;
                              strongSelf.book = book;
                              [UIView animateWithDuration:0.3 animations:^{
                                  [weakSelf setupUI];
                                  [weakSelf.view setNeedsLayout];
                                  [weakSelf.view layoutIfNeeded];
                              }];
                          }];
}

@end
