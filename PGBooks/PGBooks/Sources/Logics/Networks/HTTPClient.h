//
//  HTTPClient.h
//  PGBooks
//
//  Created by ipagong on 11/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTPClient : AFHTTPSessionManager

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
