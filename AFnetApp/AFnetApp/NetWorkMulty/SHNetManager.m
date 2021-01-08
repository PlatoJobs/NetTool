//
//  SHNetManager.m
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/8.
//

#import "SHNetManager.h"
#import <AFNetworking/AFNetworking.h>
static AFHTTPSessionManager *SHhttpManager =nil;
@implementation SHNetManager

//  采用单例方法创建对象
+ (SHNetManager *)sharedInstance
{
    static SHNetManager *netManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netManager = [[self alloc] init];
        NSURLSessionConfiguration*config=[NSURLSessionConfiguration defaultSessionConfiguration];
        SHhttpManager=[[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
        SHhttpManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/gif", nil];
        SHhttpManager.requestSerializer.timeoutInterval=15;
        SHhttpManager.securityPolicy =[AFSecurityPolicy defaultPolicy];
    });
    return netManager;
}
/** 执行post网络请求 */
- (void)executePostRequestWithApi:(SHNetRequest *)api {
    
    [SHhttpManager POST:api.fullUrl parameters:api.params headers:api.headers progress:^(NSProgress * _Nonnull downloadProgress) {
        [api callBackProgress:downloadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *outDic = (NSDictionary *)responseObject;
        [api callBackFinishedWithDictionary:outDic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [api callBackFailed:error];
    }];
    
}
/** 执行Get网络请求 */
- (void)executeGetRequestWithApi:(SHNetRequest *)api {
    
    [SHhttpManager GET:api.fullUrl parameters:api.params headers:api.headers progress:^(NSProgress * _Nonnull downloadProgress) {
        [api callBackProgress:downloadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *outDic = (NSDictionary *)responseObject;
        [api callBackFinishedWithDictionary:outDic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [api callBackFailed:error];
    }];
    
}

/** 执行post网络请求 */
- (void)executeDownloadRequestWithApi:(SHNetRequest *)api {
    
    NSMutableURLRequest *dLRequest =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:api.fullUrl]];
    
    NSURLSessionDownloadTask*downTask=[SHhttpManager downloadTaskWithRequest:dLRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        [api callBackProgress:downloadProgress];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString*path=[NSHomeDirectory() stringByAppendingString:@"Documents"];
        NSString*filePath=[path stringByAppendingPathComponent:[NSURL URLWithString:api.fullUrl].lastPathComponent];
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
          [api callBackFailed:error];
        }else{
            [api callBackFinishedWithDictionary:@{@"sh_Image":filePath.path}];
        }
    }];
    [downTask resume];
    
}
/** 执行上传网络请求 */
- (void)executeUpLoadRequestWithApi:(SHNetRequest *)api {
    
    NSData *data = UIImagePNGRepresentation(api.sh_Image);
    [SHhttpManager POST:api.fullUrl parameters:api.params headers:api.headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:api.imageKey fileName:@"sh00.png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [api callBackProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [api callBackFinishedWithDictionary:(NSDictionary*)responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [api callBackFailed:error];
    }];
   
}

/** 执行上传多图网络请求 */
- (void)executeMultiUpLoadRequestWithApi:(SHNetRequest *)api {
    
    [SHhttpManager POST:api.fullUrl parameters:api.params headers:api.headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [api.imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = UIImagePNGRepresentation((UIImage*)obj);
            if (data) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyyMMddHHmmss";
                        NSString *str = [formatter stringFromDate:[NSDate date]];
                        NSString *imageFileName = [NSString stringWithFormat:@"ios%@%ld",str, idx];
            [formData appendPartWithFileData:data name:api.imageKey fileName:imageFileName mimeType:@"image/jpeg"];
            NSLog(@"上传图片 %lu 成功", (unsigned long)idx);
            };
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [api callBackProgress:uploadProgress];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [api callBackFinishedWithDictionary:(NSDictionary*)responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [api callBackFailed:error];
    }];

}

//  执行不同的网络请求
+ (void)execute:(SHNetRequest *)api
{
    [[SHNetManager sharedInstance] sh_ReponseResultForm:api];
    [[SHNetManager sharedInstance]sh_RequestResultForm:api];
    switch (api.accessType)
    {
        case khttpMethodGet:
        {
            [[SHNetManager sharedInstance] executeGetRequestWithApi:api];
            break;
        }
        case khttpMethodPost:
        {
            [[SHNetManager sharedInstance] executePostRequestWithApi:api];
            break;
        }
        case khttpMethodDownLoad:{
            [[SHNetManager sharedInstance]executeDownloadRequestWithApi:api];
        }
        case khttpMethodPostUpload:{
            [[SHNetManager sharedInstance]executeUpLoadRequestWithApi:api];
        }
            
        default:
            [[SHNetManager sharedInstance]executeMultiUpLoadRequestWithApi:api];
            
            break;
    }
}

-(void)sh_ReponseResultForm:(SHNetRequest *)api{
    
    switch (api.responsResultFormat) {
        case kSHResponseResultJson:
        {
            SHhttpManager.responseSerializer=[AFJSONResponseSerializer serializer] ;
        }
            break;
            
        default:
        {
            SHhttpManager.responseSerializer=[AFHTTPResponseSerializer serializer];
        }
            break;
    }
       

}

-(void)sh_RequestResultForm:(SHNetRequest *)api{
    
    switch (api.requestResultFormat) {
        case kSHRequestResultHttp:
        {
            SHhttpManager.requestSerializer=[AFHTTPRequestSerializer serializer];
        }
            break;
            
        default:
            SHhttpManager.requestSerializer= [AFJSONRequestSerializer serializer];
            break;
    }
    
}

@end
