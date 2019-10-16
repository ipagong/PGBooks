//
//  BookDetailController+Transition.m
//  PGBooks
//
//  Created by ipagong on 15/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "BookDetailController+Transition.h"
#import "BookSimpleCell.h"
#import "PGBook.h"
#import "UIViewController+Utils.h"

#define TAG_TRANSITION_CONTAINER    1000
#define TAG_TRANSITION_COVER        1001
#define TAG_TRANSITION_BG           1002
#define TAG_TRANSITION_CELL         1003

@implementation BookDetailController (Transition) 

#pragma mark - Destinationable

- (void)appearWhenPresentWithStatus:(enum PGStatus)status
                           animator:(PGAnimator * _Nonnull)animator
                            context:(PGContext * _Nonnull)context {
    switch (status) {
        case PGStatusPrepare:
        {
            [context.container addSubview:[context.opposite.view snapshotViewAfterScreenUpdates:YES]];
            
            BookSimpleCell * cell = [self originalCellWithContext:context];
            
            self.coverView.alpha = 0.0;
            
            UIView *container = [self.view snapshotViewAfterScreenUpdates:YES];
            container.frame = [cell convertRect:cell.bounds toView:context.container];
            container.tag   = TAG_TRANSITION_CONTAINER;
            container.alpha = 0.0;
            [context.container addSubview:container];
            
            UIView *cover = [cell.coverView snapshotViewAfterScreenUpdates:YES];
            cover.frame = [cell.coverView convertRect:cell.coverView.bounds toView:context.container];
            cover.tag   = TAG_TRANSITION_COVER;
            [context.container addSubview:cover];
            
            break;
        }
        case PGStatusDoing:
        {
            UIView *container = [context.container viewWithTag:TAG_TRANSITION_CONTAINER];
            container.frame = context.target.view.frame;
            container.alpha = 1.0;
            
            UIView *cover = [context.container viewWithTag:TAG_TRANSITION_COVER];
            cover.frame = [self.coverView convertRect:self.coverView.bounds toView:context.container];
            
            break;
        }
        case PGStatusDone:
        case PGStatusCancel:
        {
            [context.container addSubview:context.target.view];
            self.coverView.alpha = 1.0;
            [[context.container viewWithTag:TAG_TRANSITION_CONTAINER] removeFromSuperview];
            [[context.container viewWithTag:TAG_TRANSITION_COVER] removeFromSuperview];
            
            break;
        }
    }
}

- (void)disppearWhenDismissWithStatus:(enum PGStatus)status
                             animator:(PGAnimator * _Nonnull)animator
                              context:(PGContext * _Nonnull)context {
    switch (status) {
        case PGStatusPrepare:
        {
            [context.container addSubview:context.opposite.view];
            
            BookSimpleCell * cell = [self originalCellWithContext:context];
            
            if (cell) { self.coverView.alpha = 0.0; }
            
            UIView *bg = [UIView new];
            bg.frame = context.container.frame;
            bg.backgroundColor = [UIColor whiteColor];
            bg.tag = TAG_TRANSITION_BG;
            [context.container addSubview:bg];
            
            UIView *container = [self.view snapshotViewAfterScreenUpdates:YES];
            container.frame = context.container.frame;
            container.tag = TAG_TRANSITION_CONTAINER;
            [context.container addSubview:container];
            
            cell.coverView.alpha = 0.0;
            UIView *sCell = [cell snapshotViewAfterScreenUpdates:YES];
            sCell.frame = [cell convertRect:cell.bounds toView:context.container];
            sCell.alpha = 0.0;
            sCell.tag = TAG_TRANSITION_CELL;
            [context.container addSubview:sCell];
            
            cell.coverView.alpha = 1.0;
            UIView *cover = [cell.coverView snapshotViewAfterScreenUpdates:YES];
            cover.frame = [self.coverView convertRect:self.coverView.bounds toView:context.container];
            cover.tag = TAG_TRANSITION_COVER;
            [context.container addSubview:cover];
            
            break;
        }
        case PGStatusDoing:
        {
            BookSimpleCell * cell = [self originalCellWithContext:context];
            
            UIView *bg        = [context.container viewWithTag:TAG_TRANSITION_BG];
            UIView *container = [context.container viewWithTag:TAG_TRANSITION_CONTAINER];
            UIView *sCell     = [context.container viewWithTag:TAG_TRANSITION_CELL];
            UIView *cover     = [context.container viewWithTag:TAG_TRANSITION_COVER];
            
            if (cell) {
                bg.frame        = [cell convertRect:cell.bounds toView:context.container];
                container.frame = [cell convertRect:cell.bounds toView:context.container];
                sCell.frame     = [cell convertRect:cell.bounds toView:context.container];
                cover.frame     = [cell.coverView convertRect:cell.coverView.bounds toView:context.container];
            } else {
                CGRect rect = CGRectMake(0,
                                         context.container.frame.size.height,
                                         context.container.frame.size.width,
                                         context.container.frame.size.height/2);
                bg.frame        = rect;
                container.frame = rect;
                sCell.frame     = rect;
                cover.frame     = rect;
            }
            
            [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:1.0 animations:^{ bg.alpha = 0.0; }];
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{ container.alpha = 0.0; }];
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:1.0 animations:^{ sCell.alpha = 1.0; }];
            
            break;
        }
        case PGStatusDone:
        case PGStatusCancel:
        {
            for (UIView *view in self.stackContainer.subviews) { view.alpha = 1.0; }
            self.coverView.alpha = 1.0;
            [[context.container viewWithTag:TAG_TRANSITION_BG] removeFromSuperview];
            [[context.container viewWithTag:TAG_TRANSITION_CONTAINER] removeFromSuperview];
            [[context.container viewWithTag:TAG_TRANSITION_CELL] removeFromSuperview];
            [[context.container viewWithTag:TAG_TRANSITION_COVER] removeFromSuperview];
            
            break;
        }
    }
}

#pragma mark - utils

- (nullable BookSimpleCell *)originalCellWithContext:(PGContext * _Nonnull)context {
    UIViewController<BookDetailTransitionTargetProtocol> *vc = (UIViewController<BookDetailTransitionTargetProtocol> *)context.opposite.lastChildren;
    
    if (vc == nil) { return nil; }
    if ([vc conformsToProtocol:@protocol(BookDetailTransitionTargetProtocol)] == NO) { return nil; }
    if ([vc respondsToSelector:@selector(tableview)] == NO) { return nil; }
    
    for (BookSimpleCell *visible in [vc.tableview visibleCells]) {
        if ([visible isKindOfClass:[BookSimpleCell class]] == NO)  { continue; }
        if ([visible.key isEqualToString:self.book.isbn13] == YES) { return visible; }
    }
    
    return nil;
}

@end
