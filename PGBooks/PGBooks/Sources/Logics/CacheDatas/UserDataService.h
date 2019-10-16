//
//  UserDataService.h
//  PGBooks
//
//  Created by ipagong on 14/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGBook;

NS_ASSUME_NONNULL_BEGIN

@interface UserDataService : NSObject

+ (void)addSearchQuery:(NSString *)query;
+ (NSArray *)queryHistory;
+ (void)removeAllQueryHistory;

+ (void)addSearchedBook:(PGBook *)book;
+ (NSArray *)searchedBooks;
+ (void)removeAllSearchedBooks;

+ (void)addFavoriteBook:(PGBook *)book;
+ (void)removeFavoriteBookWithObject:(PGBook *)book;
+ (NSArray *)favoriteBooks;
+ (void)removeAllFavoriteBooks;

+ (void)addGlanceBook:(PGBook *)book;
+ (void)removeGlanceBookWithObject:(PGBook *)book;
+ (NSArray *)glanceBooks;
+ (void)removeAllGlanceBooks;

@end

NS_ASSUME_NONNULL_END
