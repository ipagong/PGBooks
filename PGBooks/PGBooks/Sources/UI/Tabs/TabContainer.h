//
//  TabContainer.h
//  PGBooks
//
//  Created by ipagong on 11/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabSegue.h"

@class TabContainer;

@protocol TabContainerDelegate <NSObject>
- (void)didChangedTabContainer:(TabContainer *)container selectedTabType:(TabType)type;
@end

@interface TabContainer : UIViewController

@property (nonatomic, readonly) TabType current;

@property (nonatomic, weak) id<TabContainerDelegate> delegate;

- (void)reload;
- (void)load:(TabType)type;

@end

