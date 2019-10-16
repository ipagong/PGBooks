//
//  ITBookService.h
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGBook;

NS_ASSUME_NONNULL_BEGIN

@interface ITBookService : NSObject

+ (NSURLSessionDataTask *)getNewBooksWithCompletion:(void (^)(NSArray<PGBook *>*books, NSError *error))completion;

+ (NSURLSessionDataTask *)getSearchBooksWithKeyword:(NSString *)query
                                               page:(NSInteger)page
                                         completion:(void (^)(NSArray<PGBook *>*books, NSInteger total, NSError *error))completion;

+ (NSURLSessionDataTask *)getDetailBookInfo:(NSString *)number
                                 completion:(void (^)(PGBook *book, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
