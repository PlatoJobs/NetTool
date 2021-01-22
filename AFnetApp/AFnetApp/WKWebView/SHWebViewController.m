//
//  SHWebViewController.m
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/11.
//

#import "SHWebViewController.h"
#import <WebKit/WebKit.h>
#define JX_SCREEN_TOP (THE_DEVICE_HAVE_HEAD ? 88 : (44+20))
#define JX_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height     //全屏宽度
#define JX_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@interface SHWebViewController ()<WKNavigationDelegate,WKUIDelegate>
//webView
@property(nonatomic,strong)WKWebView *webView;
//进度条
@property(nonatomic,strong)UIProgressView *progressView;

@end

@implementation SHWebViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatWebView];
    // Do any additional setup after loading the view.
}
//创建webView
-(void)creatWebView{
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.cnblogs.com/shinima/p/11753932.html"]]];
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
