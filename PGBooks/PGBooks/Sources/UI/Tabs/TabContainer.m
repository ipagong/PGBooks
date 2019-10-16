//
//  TabContainer.m
//  PGBooks
//
//  Created by ipagong on 11/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "TabContainer.h"

@interface TabContainer ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, UIViewController*>* viewControllers;

@end

@implementation TabContainer

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_viewControllers setValue:segue.destinationViewController
                        forKey:segue.identifier];
 
    [self performSwapWithFrom:self.childViewControllers.firstObject
                           to: segue.destinationViewController];
}

#pragma mark - private

- (void)setup {
    _current = TabTypeNew;
    
    self.viewControllers = [NSMutableDictionary dictionary];
    
    [self reload];
}

- (void)performSwapWithFrom:(nullable UIViewController *)from
                         to:(nonnull UIViewController *)to
{
    [from willMoveToParentViewController:nil];
    [from.view removeFromSuperview];
    [from removeFromParentViewController];
    
    [self addChildViewController:to];
    
    [self.view addSubview:to.view];
    to.view.frame = self.view.bounds;
    [to didMoveToParentViewController:self];
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didChangedTabContainer:selectedTabType:)] == YES) {
        [self.delegate didChangedTabContainer:self selectedTabType:_current];
    }
}

#pragma mark - public

- (void)reload
{
    [self load: _current];
}

- (void)load:(TabType)type
{
    _current = type;
    
    NSString * key = [TabSegue storyboarKey:type];
    
    UIViewController * to = _viewControllers[key];
    
    if (to == nil) {
        [self performSegueWithIdentifier:key sender:nil];
    } else {
        [self performSwapWithFrom:self.childViewControllers.firstObject to: to];
    }
}

@end
