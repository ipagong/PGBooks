//
//  LocalData.m
//  PGBooks
//
//  Created by ipagong on 14/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "LocalData.h"

@interface LocalData ()

@property (nonatomic, strong) NSMutableDictionary <NSString*, id> * memory;

@end

@implementation LocalData

+ (instancetype)shared
{
    static LocalData * object = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        object = [[LocalData alloc] init];
    });
    
    return object;
}

- (instancetype)init
{
    self = [super init];
    if (!self) { return nil; }
    _memory = [NSMutableDictionary dictionary];
    return self;
}

- (NSUserDefaults *)userDefaults {
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark - List Memory & UserDefault cache

- (void)addToListWithObject:(id)object key:(NSString *)key {
    [self addToListWithObject:object key:key limit:0];
}

- (void)addToListWithObject:(id)object key:(NSString *)key limit:(NSInteger)limit {
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self objectFromListWithKey:key]];
    
    [array removeObject:object];
    [array insertObject:object atIndex:0];
    
    NSArray *target = array;
    
    if (limit > 0) {
        NSRange range = NSMakeRange(0, MIN(limit, array.count));
        target = [array subarrayWithRange:range];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:target];
    
    [[self userDefaults] setObject:data forKey:key];
    [[self userDefaults] synchronize];
    
    [_memory setObject:target forKey:key];
}

- (NSArray *)objectFromListWithKey:(NSString *)key {
    return [self objectFromListWithKey:key limit:0];
}

- (NSArray *)objectFromListWithKey:(NSString *)key limit:(NSInteger)limit {
    NSArray * array = nil;
    
    array = [_memory objectForKey:key];
    
    if (array) { return array; }
    
    NSData *data = [[self userDefaults] objectForKey:key];
    
    if (data) {
        array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        array = [NSMutableArray array];
    }
    
    NSArray *target = array;
    
    if (limit > 0) {
        NSRange range = NSMakeRange(0, MIN(limit, array.count));
        target = [array subarrayWithRange:range];
    }
    
    [_memory setObject:target forKey:key];
    
    return target;
}

- (void)removeListWithKey:(NSString *)key object:(id)object {
    if (!object) { return; }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self objectFromListWithKey:key]];
    
    [array removeObject:object];
    
    [_memory setObject:array forKey:key];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    [[self userDefaults] setObject:data forKey:key];
    [[self userDefaults] synchronize];
}

- (void)removeListWithKey:(NSString *)key {
    [_memory removeObjectForKey:key];
    [[self userDefaults] removeObjectForKey:key];
    [[self userDefaults] synchronize];
}

@end
