//
//  SHNetResult.m
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/8.
//

#import "SHNetResult.h"

@implementation SHNetResult

- (BOOL)success
{
    return self.status == 200;
}
- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        
        @try {
            if (dic) {
//              取出返回数据的状态码
                self.status = [[dic objectForKey:@"code"] intValue];
////              提示信息
                self.message = [dic objectForKey:@"message"];
 
                NSDictionary *data = [dic objectForKey:@"data"];
////              返回数据
                self.dic = data;
            } else {
//              没有返回数据
                self.message = @"网络错误";
                self.dic = @{};
                self.status = 1;  // 暂时定义无效的网络
            }
        }
        //        接收到异常
        @catch (NSException *exception) {
            self.dic = dic;
            self.status = 0;
        }
        @finally {
            
        }
    }
    return self;
}


@end
