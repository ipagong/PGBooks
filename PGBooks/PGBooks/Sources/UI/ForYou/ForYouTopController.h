//
//  ForYouTopController.h
//  PGBooks
//
//  Created by ipagong on 11/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDetailController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForYouTopController : UIViewController <BookDetailTransitionTargetProtocol>
- (UITableView *)tableview;
@end

NS_ASSUME_NONNULL_END
