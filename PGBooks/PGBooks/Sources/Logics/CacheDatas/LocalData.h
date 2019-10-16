//
//  LocalData.h
//  PGBooks
//
//  Created by ipagong on 14/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalData : NSObject

+ (instancetype)shared;

- (void)addToListWithObject:(id)object key:(NSString *)key;
- (void)addToListWithObject:(id)object key:(NSString *)key limit:(NSInteger)limit;

- (NSArray *)objectFromListWithKey:(NSString *)key;
- (NSArray *)objectFromListWithKey:(NSString *)key limit:(NSInteger)limit;

- (void)removeListWithKey:(NSString *)key;
- (void)removeListWithKey:(NSString *)key object:(id)object;

@end

NS_ASSUME_NONNULL_END
