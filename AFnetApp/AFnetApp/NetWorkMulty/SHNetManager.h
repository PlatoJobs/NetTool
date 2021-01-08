//
//  SHNetManager.h
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/8.
//

#import <Foundation/Foundation.h>
#import "SHNetRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHNetManager : NSObject

/**
 *  APIClient 初始化
 */
+ (SHNetManager *)sharedInstance;
/**
 *  执行不同网络请求
 */
+ (void)execute:(SHNetRequest *)api;

@end

NS_ASSUME_NONNULL_END
