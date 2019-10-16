//
//  TabSegue.h
//  PGBooks
//
//  Created by ipagong on 11/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TabType) {
    TabTypeNew = 0,
    TabTypeForYou,
    TabTypeList,
    TabTypeSearch,
};

@interface TabSegue : UIStoryboardSegue

+ (nonnull NSString *)storyboarKey:(TabType)type;

@end
