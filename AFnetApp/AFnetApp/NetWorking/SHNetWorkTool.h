//
//  SHNetWorkTool.h
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^SHNetSuccess)(id _Nullable response);

typedef void(^SHNetFailure)(NSError* _Nullable error);

typedef void(^SHDownLoadProgress)(CGFloat progress);

typedef void(^SHUpLoadProgress)(CGFloat progress);

NS_ASSUME_NONNULL_BEGIN

@interface SHNetWorkTool : NSObject


+(SHNetWorkTool*)shareManager;

/// get请求
/// @param url  请求url
/// @param paramas  参数字典
/// @param header  header字典
/// @param success  成功回调
/// @param failure  失败回调
-(void)sh_getDataWithUrl:(NSString*)url paramas:(NSDictionary*)paramas withHead:(NSDictionary*)header success:(SHNetSuccess)success failure:(SHNetFailure)failure;

/// post请求
/// @param url 请求url
/// @param paramas 参数字典
/// @param header header字典
/// @param success success description
/// @param failure failure description
-(void)sh_postDataWithUrl:(NSString*)url paramas:(NSDictionary*)paramas withHead:(NSDictionary*)header success:(SHNetSuccess)success failure:(SHNetFailure)failure;


/// 下载请求
/// @param url url description
/// @param headers headers description
/// @param dLprogress dLprogress description
/// @param success success description
/// @param failure failure description
-(void)sh_downLoadWithUrl:(NSString*)url headers:(NSDictionary*)headers withProgress:(SHDownLoadProgress)dLprogress success:(SHNetSuccess)success failure:(SHNetFailure)failure;



/// 上传图片
/// @param url url description
/// @param paramas paramas description
/// @param header header description
/// @param imageKey imageKey description
/// @param image image description
/// @param uLProgress uLProgress description
/// @param success success description
/// @param failure failure description
-(void)sh_upLoadWithUrl:(NSString*)url paramas:(NSDictionary*)paramas withHead:(NSDictionary*)header withThumName:(NSString*)imageKey withImage:(UIImage*)image withProgress:(SHUpLoadProgress)uLProgress success:(SHNetSuccess)success failure:(SHNetFailure)failure;




@end

NS_ASSUME_NONNULL_END
