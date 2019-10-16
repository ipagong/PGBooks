//
//  TabSegue.m
//  PGBooks
//
//  Created by ipagong on 11/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "TabSegue.h"

@implementation TabSegue

+ (NSString *)storyboarKey:(TabType)type {
    switch (type) {
        case TabTypeNew:
            return @"New";
        case TabTypeList:
            return @"List";
        case TabTypeForYou:
            return @"ForYou";
        case TabTypeSearch:
            return @"Search";
    }
}

- (void)perform { }

@end
