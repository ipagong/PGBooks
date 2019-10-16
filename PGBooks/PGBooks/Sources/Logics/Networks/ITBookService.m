//
//  ITBookService.m
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "ITBookService.h"
#import "PGBook.h"
#import "HTTPClient.h"

@implementation ITBookService

+ (NSURLSessionDataTask *)getNewBooksWithCompletion:(void (^)(NSArray<PGBook *>*books, NSError *error))completion
{
    NSString * path = @"/1.0/new";
    
    return [[HTTPClient shared] GET:path
                         parameters:@{}
                           progress:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                if (!completion) { return; }
                                
                                NSArray *array = [JSON valueForKeyPath:@"books"];
                                
                                NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:array.count];
                                
                                [array enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                                    [list addObject:[[PGBook alloc] initWithAttributes:attributes]];
                                }];
                                
                                completion(list, nil);
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                            }];
}

+ (NSURLSessionDataTask *)getSearchBooksWithKeyword:(NSString *)query
                                               page:(NSInteger)page
                                         completion:(void (^)(NSArray<PGBook *>*books, NSInteger total, NSError *error))completion
{
    query = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSString * path = [NSString stringWithFormat:@"/1.0/search/%@/%ld", query, MAX(page + 1, 1)];
    
    return [[HTTPClient shared] GET:path
                         parameters:@{}
                           progress:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                if (!completion) { return; }
                                
                                NSArray *array = [JSON valueForKeyPath:@"books"];
                                
                                NSInteger total = [[JSON valueForKeyPath:@"total"] integerValue];
                                
                                NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:array.count];
                                
                                [array enumerateObjectsUsingBlock:^(id attributes, NSUInteger idx, BOOL *stop) {
                                    [list addObject:[[PGBook alloc] initWithAttributes:attributes]];
                                }];
                                
                                completion(list, total, nil);
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, 0, error);
                            }];
}

+ (NSURLSessionDataTask *)getDetailBookInfo:(NSString *)number
                                 completion:(void (^)(PGBook *book, NSError *error))completion
{
    NSString * path = [NSString stringWithFormat:@"/1.0/books/%@", number];
    
    return [[HTTPClient shared] GET:path
                         parameters:@{}
                           progress:nil
                            success:^(NSURLSessionDataTask *task, id JSON) {
                                if (!completion) { return; }
                                
                                NSDictionary *dic = JSON;
                                
                                PGBook *book = [[PGBook alloc] initWithAttributes:dic];
                                
                                completion(book, nil);
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                            }];
}

@end
