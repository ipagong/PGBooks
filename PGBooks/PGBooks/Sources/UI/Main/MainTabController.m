//
//  MainTabController.m
//  PGBooks
//
//  Created by ipagong on 11/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "MainTabController.h"

@interface MainTabController () <TabContainerDelegate>
@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UIStackView *tabContainer;

@property (weak, nonatomic) IBOutlet UIButton *tabNew;
@property (weak, nonatomic) IBOutlet UIButton *tabList;
@property (weak, nonatomic) IBOutlet UIButton *tabForYou;
@property (weak, nonatomic) IBOutlet UIButton *tabSearch;

@property (weak, nonatomic) IBOutlet TabContainer *embedContainer;

@end

@implementation MainTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tabNew    setTag: TabTypeNew];
    [_tabList   setTag: TabTypeList];
    [_tabForYou setTag: TabTypeForYou];
    [_tabSearch setTag: TabTypeSearch];
    
    [self.embedContainer setDelegate:self];
    
    [self.embedContainer load:TabTypeNew];
}

- (IBAction)onClickTab:(UIButton *)sender {
    [self.embedContainer load:sender.tag];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[TabContainer class]] == NO) { return; }
    
    self.embedContainer = (TabContainer *)segue.destinationViewController;
}

#pragma mark - TabContainer Delegate

- (void)didChangedTabContainer:(TabContainer *)container selectedTabType:(TabType)type
{
    for (UIView *subview in self.tabContainer.subviews) {
        if ([subview isKindOfClass:[UIButton class]] == NO) { return; }
        [((UIButton *)subview) setSelected:(subview.tag == type)];
    }
}

@end
