//
//  ViewController.m
//  RichTextDemo
//
//  Created by Victor on 16/10/7.
//  Copyright © 2016年 Victor. All rights reserved.
//

#import "SFViewController.h"

@interface SFViewController ()<WKNavigationDelegate,WKScriptMessageHandler,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    NSString *_htmlString;//保存输出的富文本
    NSMutableArray *_imageArr;//保存添加的图片
    NSMutableArray *selectImageArr; // 选择的图片
    NSInteger degree;
    NSMutableArray *urlArr;
    BOOL isDismiss;
   
}

@property (nonatomic,copy)NSString *inHtmlString;
@property (nonatomic,assign)NSInteger numberTS;

@end

@implementation SFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectImageArr = [[NSMutableArray alloc] init];
    urlArr = [[NSMutableArray alloc] initWithCapacity:15];
    
    self.title=@"wkwebviewtest1";
    self.view.backgroundColor = [UIColor whiteColor];
    //添加WkwebView的配置代理

   // self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kTopHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTopHeight)];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *indexFileURL = [bundle URLForResource:@"richTextEditor" withExtension:@"html"];
    
   // [self.webView setKeyboardDisplayRequiresUserAction:NO];
    [self.webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 40, 80, 30);
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:@"添加图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightAction {
    
    if (selectImageArr.count>0) {
        [self uploadingPactImage];
    } else {
        [self saveText];
    }
}
 
#pragma mark -- WKScriptMessageHandler  20201207

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    

    
    NSLog(@"Message: %@", message.body);
    
}

#pragma  mark==NAvdelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    if (self.inHtmlString.length > 0)
    {
        NSString *place = [NSString stringWithFormat:@"window.placeHTMLToEditor('%@')",self.inHtmlString];
//        place = @"window.placeHTMLToEditor('喜欢电话回电话电话<img src="https://dev.images2.17duu.com/uploads/pictures/2018/12/27/89a3112c276bbe87898a21edd4329b0c.jpg'/><div><br></div>')";
        place = [self removeSpaceAndNewline:place];
     //   [webView stringByEvaluatingJavaScriptFromString:place];
        [webView evaluateJavaScript:place completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"window.placeHTML===%@",result);
        }];
    }
    
}

- (NSString *)removeSpaceAndNewline:(NSString *)str {
//    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *temp = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

- (void)addImage
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.navigationBar.translucent = NO;
    isDismiss = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}



#pragma mark - ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [self removeHUD];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDate *now = [NSDate date];
    NSString *imageName = [NSString stringWithFormat:@"iOS%@.jpg", [self stringFromDate:now]];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *tempImg;
    if ([mediaType isEqualToString:@"public.image"])
    {
        tempImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(tempImg, 1);
        [imageData writeToFile:imagePath atomically:YES];
        
       // tempImg =  [RSTools compressImage:tempImg ToSize:CGSizeMake(KscaleSize, tempImg.size.height *KscaleSize/tempImg.size.width) andFieldSize:1024*400 ];
       // [tempImg fixOrientation];
    }
    //对应自己服务器的处理方法,
    //此处是将图片上传ftp中特定位置并使用时间戳命名 该图片地址替换到html文件中去
//    NSString *url = [NSString stringWithFormat:@"http://pic.baikemy.net/apps/kanghubang/%@/%@/%@",[NSString stringWithFormat:@"%ld",userid%1000],[NSString stringWithFormat:@"%ld",(long)userid ],imageName];
    NSString *url = @"www.17duu.com";
    
    NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", url, imagePath];
    NSDictionary *dic = @{@"url":url,@"image":tempImg,@"name":imageName};
    [_imageArr addObject:dic];
    [selectImageArr addObject:tempImg];
    if (isDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   // [self.webView stringByEvaluatingJavaScriptFromString:script];
    [self.webView evaluateJavaScript:script completionHandler:^(id _Nullable result, NSError * _Nullable error) {
       // [self.webView setNeedsLayout];
    }];
    
    
    isDismiss = NO;
}

- (void)saveText
{
   
}


#pragma mark - Method
-(NSString *)changeString:(NSString *)str
{
    
    NSMutableArray * marr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\""]];
    
    for (int i = 0; i < marr.count; i++)
    {
        NSString * subStr = marr[i];
        if ([subStr hasPrefix:@"/var"] || [subStr hasPrefix:@" id="])
        {
            [marr removeObject:subStr];
            i --;
        }
    }
    NSString * newStr = [marr componentsJoinedByString:@"\""];
    return newStr;
    
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

- (void)uploadingPactImage {
    
   
}

- (void)uploadFile:(NSDictionary *)dataDict {
    
   
}

- (void)upError {
   
    if (self.numberTS==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"网络故障，请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
        self.numberTS++;
    }
}

- (void)updateUI {
  
    [self saveText];
}

- (void)removePerchObject:(NSMutableDictionary *)dic {

    NSArray *keyArr = [dic allKeys];
    for (int i = 0; i<keyArr.count; i++) {
        NSString *key = [NSString stringWithFormat:@"image%d",i];
        if (dic[key]) {
            [urlArr addObject:dic[key]];
        }
    }
}

- (IBAction)sender:(UIButton *)sender {
    
    [self addImage];
}


@end
