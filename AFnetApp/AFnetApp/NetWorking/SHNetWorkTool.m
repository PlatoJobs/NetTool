//
//  SHNetWorkTool.m
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/8.
//

#import "SHNetWorkTool.h"
#import <AFNetworking/AFNetworking.h>

static AFHTTPSessionManager *SHhttpManager =nil;
static SHNetWorkTool*manager = nil;


@implementation SHNetWorkTool

+(SHNetWorkTool*)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager=[[SHNetWorkTool alloc]init];
        NSURLSessionConfiguration*config=[NSURLSessionConfiguration defaultSessionConfiguration];
        SHhttpManager=[[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
        SHhttpManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/gif", nil];
        SHhttpManager.requestSerializer.timeoutInterval=15;
        SHhttpManager.securityPolicy =[AFSecurityPolicy defaultPolicy];
    });
    return manager;
}


-(void)sh_getDataWithUrl:(NSString*)url paramas:(NSDictionary*)paramas withHead:(NSDictionary*)header success:(SHNetSuccess)success failure:(SHNetFailure)failure{
    
    [SHhttpManager GET:url parameters:paramas headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

-(void)sh_postDataWithUrl:(NSString*)url paramas:(NSDictionary*)paramas withHead:(NSDictionary*)header success:(SHNetSuccess)success failure:(SHNetFailure)failure{
    
    [SHhttpManager POST:url parameters:paramas headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    
}

-(void)sh_downLoadWithUrl:(NSString*)url headers:(NSDictionary*)headers withProgress:(SHDownLoadProgress)dLprogress success:(SHNetSuccess)success failure:(SHNetFailure)failure{
    
    NSMutableURLRequest *dLRequest =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask*downTask=[SHhttpManager downloadTaskWithRequest:dLRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        dLprogress(downloadProgress.fractionCompleted*100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString*path=[NSHomeDirectory() stringByAppendingString:@"Documents"];
        NSString*filePath=[path stringByAppendingPathComponent:[NSURL URLWithString:url].lastPathComponent];
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else{
            success(filePath.path);
        }
    }];
    [downTask resume];
}

-(void)sh_upLoadWithUrl:(NSString*)url paramas:(NSDictionary*)paramas withHead:(NSDictionary*)header withThumName:(NSString*)imageKey withImage:(UIImage*)image withProgress:(SHUpLoadProgress)uLProgress success:(SHNetSuccess)success failure:(SHNetFailure)failure{
    
    NSData *data = UIImagePNGRepresentation(image);
    [SHhttpManager POST:url parameters:paramas headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:imageKey fileName:@"sh00.png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        uLProgress(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}







@end
