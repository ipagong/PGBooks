//
//  UserDataService.m
//  PGBooks
//
//  Created by ipagong on 14/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "UserDataService.h"
#import "LocalData.h"

static NSString * const ArchiveKeySearchQuery   = @"ArchiveKeySearchQuery";
static NSString * const ArchiveKeySearchResult  = @"ArchiveKeySearchResult";
static NSString * const ArchiveKeyFavorite      = @"ArchiveKeyFavorite";
static NSString * const ArchiveKeyGlance        = @"ArchiveKeyGlance";

@implementation UserDataService

#pragma mark - query

+ (void)addSearchQuery:(NSString *)query {
    [[LocalData shared] addToListWithObject:query key:ArchiveKeySearchQuery limit:0];
}

+ (NSArray *)queryHistory {
    return [[LocalData shared] objectFromListWithKey:ArchiveKeySearchQuery limit:0];
}

+ (void)removeAllQueryHistory {
    [[LocalData shared] removeListWithKey:ArchiveKeySearchQuery];
}

#pragma mark - search result book

+ (void)addSearchedBook:(PGBook *)book {
    [[LocalData shared] addToListWithObject:book key:ArchiveKeySearchResult limit:0];
}

+ (NSArray *)searchedBooks {
    return [[LocalData shared] objectFromListWithKey:ArchiveKeySearchResult limit:0];
}

+ (void)removeAllSearchedBooks {
    [[LocalData shared] removeListWithKey:ArchiveKeySearchResult];
}

#pragma mark - Favorite

+ (void)addFavoriteBook:(PGBook *)book {
    [[LocalData shared] addToListWithObject:book key:ArchiveKeyFavorite limit:0];
}

+ (void)removeFavoriteBookWithObject:(PGBook *)book {
    [[LocalData shared] removeListWithKey:ArchiveKeyFavorite object:book];
}

+ (NSArray *)favoriteBooks {
    return [[LocalData shared] objectFromListWithKey:ArchiveKeyFavorite limit:0];
}

+ (void)removeAllFavoriteBooks {
    [[LocalData shared] removeListWithKey:ArchiveKeyFavorite];
}

#pragma mark - glance

+ (void)addGlanceBook:(PGBook *)book {
    [[LocalData shared] addToListWithObject:book key:ArchiveKeyGlance limit:20];
}

+ (void)removeGlanceBookWithObject:(PGBook *)book {
    [[LocalData shared] removeListWithKey:ArchiveKeyGlance object:book];
}

+ (NSArray *)glanceBooks {
    return [[LocalData shared] objectFromListWithKey:ArchiveKeyGlance limit:20];
}

+ (void)removeAllGlanceBooks {
    [[LocalData shared] removeListWithKey:ArchiveKeyGlance];
}

@end
