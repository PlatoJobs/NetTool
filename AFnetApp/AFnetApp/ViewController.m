//
//  ViewController.m
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/8.
//

#import "ViewController.h"
#import "SHNetWorkTool.h"
#import "SHUserModel.h"
#import "SHNetManager.h"
@interface ViewController ()<SHNetRequestDelegate>
@property(nonatomic,strong)SHUserModel*userModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self N_request];
    
}

-(void)N_request{
    
    //第一种网络请求
    SHNetRequest*resust=[SHNetRequest new];
    resust.serviceUrl=[NSString stringWithFormat:@"%@%@",@"https://baidu/",@"login?"];
    resust.params=@{
        
    };
    resust.headers=@{};
    resust.delegate=self;
    resust.accessType=khttpMethodPost;
    resust.responsResultFormat=kSHResponseResultJson;
    resust.requestResultFormat=kSHRequestResultHttp;
    [SHNetManager execute:resust];
    
    
}


-(void)serverApi_FinishedSuccessed:(SHNetRequest *)api result:(SHNetResult *)sr{
    
    NSLog(@"======%@",sr.dic);
    
}

-(void)serverApi_FinishedFailed:(SHNetRequest *)api result:(SHNetResult *)sr{
    
    
}



-(void)oldRequest{
    
    NSString*url=[NSString stringWithFormat:@"%@%@",@"https://baidu.com/",@"register?"];
    NSDictionary*paramasDic=@{
      
    };
    
    NSDictionary*headersDic=@{};
    
    //第二种网络请求
    
    [[SHNetWorkTool shareManager]sh_postDataWithUrl:url paramas:paramasDic withHead:headersDic success:^(id  _Nullable response) {
        NSLog(@"=======%@",response);
        self.userModel=[SHUserModel mj_objectWithKeyValues:response[@"data"]];
        
        NSLog(@"=======%@==mall=%@",self.userModel.token,self.userModel.mall.username);
        
        
    } failure:^(NSError * _Nullable error) {
        NSLog(@"=======%@",error.userInfo);
    }];

    
}

@end
