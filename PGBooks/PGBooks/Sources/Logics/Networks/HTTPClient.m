//
//  HTTPClient.m
//  PGBooks
//
//  Created by ipagong on 11/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "HTTPClient.h"

#define ITBOOKS_BASE_URL @"https://api.itbook.store"

@implementation HTTPClient

+ (instancetype)shared
{
    static HTTPClient * client = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        client = [[HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:ITBOOKS_BASE_URL]];
        
        client.requestSerializer  = [AFHTTPRequestSerializer  serializer];
        client.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [client.operationQueue setMaxConcurrentOperationCount:1];
    });
    
    return client;
}

@end
