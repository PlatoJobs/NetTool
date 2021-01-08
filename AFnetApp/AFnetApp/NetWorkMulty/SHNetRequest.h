//
//  SHNetRequest.h
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/8.
//

#import <Foundation/Foundation.h>
#import "SHNetResult.h"
NS_ASSUME_NONNULL_BEGIN

@class SHNetRequest;

//  默认的网络请求的延时时间
#define defaultAPIRequestTimeOutSeconds     15

//  错误类型枚举暂未收集

typedef enum SHHttpMethodType {
    khttpMethodGet,                      // Get方式
    khttpMethodPost,                     // Post方式
    khttpMethodDownLoad,   //download
    khttpMethodPostUpload,                   // 上传
    khttpMethodPostMultiUpload              // 多张图片上传
}SHHttpMethodType;

// 没有进行验证的这个步骤 属性可以不写了
typedef enum SHResponseResultFormat {
    kSHResponseResultJson,                     // Json格式
    kSHResponseResultHttp,                      // Xml格式
}SHResponseResultFormat;

// 没有进行验证的这个步骤 属性可以不写了
typedef enum SHRequestResultFormat {
    kSHRequestResultJson,                     // Json格式
    kSHRequestResultHttp,                      // Xml格式
}SHRequestResultFormat;


@protocol SHNetRequestDelegate <NSObject>

@optional

- (void)serverApi_FinishedSuccessed:(SHNetRequest *)api result:(SHNetResult *)sr;
- (void)serverApi_RequestFailed:(SHNetRequest *)api error:(NSError *)error;
- (void)serverApi_FinishedFailed:(SHNetRequest *)api result:(SHNetResult *)sr;
- (void)serverApi_FinishedProgress:(SHNetRequest *)api result:(CGFloat )sr;

@end
@interface SHNetRequest : NSObject

#pragma mark - 基本属性

/** 请求类型 */
@property (nonatomic, assign) SHHttpMethodType accessType;
/** 请求返回的格式 */
@property (nonatomic, assign) SHResponseResultFormat responsResultFormat;
/** 请求的格式 */
@property (nonatomic, assign) SHRequestResultFormat requestResultFormat;
/** 请求超时时间 */
/** 请求超时时间 */
@property (nonatomic, readonly) NSTimeInterval timeout;
/** 服务器地址 */
@property (nonatomic, copy) NSString *serviceUrl;
/** 排序 */
@property (nonatomic, copy) NSString *sort;
/** 分页大小 */
@property (nonatomic, copy) NSString *pagesize;
/** 应用Key */
@property (nonatomic, copy) NSString *key;
/** 第几页 */
@property (nonatomic, copy) NSString *page;
/** 时间戳 */
@property (nonatomic, copy) NSString *time;
/** 请求路径 */
@property (nonatomic, copy) NSString *fullUrl;
/** 代理 */
@property (nonatomic, weak) id<SHNetRequestDelegate> delegate;
/** 请求参数数组 */
@property (nonatomic, copy) NSDictionary *params;
/** 请求头 */
@property(nonatomic,copy)NSDictionary*headers;
/**上传的图片*/
@property(nonatomic,strong)UIImage*sh_Image;
/**上传的数据名称*/
@property(nonatomic,copy)NSString*imageKey;
/**上传的数据名称*/
@property(nonatomic,copy)NSArray*imageArr;

#pragma mark - 基本方法
- (id)initWithDelegate:(id<SHNetRequestDelegate>)delegate;
/**
 *  拼接公共参数
 */
- (void)appendBaseParams;

#pragma mark - SHNetRequestDelegate回调方法
/**
 *  返回数据调用方法
 */
- (void)callBackFinishedWithDictionary:(NSDictionary *)dic;
/**
 *  返回数据错误
 */
- (void)callBackFailed:(NSError *)error;
/**
 *  完成进度
 */
-(void)callBackProgress:(NSProgress *)progress;


@end

NS_ASSUME_NONNULL_END
