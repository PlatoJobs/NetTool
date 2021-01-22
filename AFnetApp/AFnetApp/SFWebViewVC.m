//
//  SFWebViewVC.m
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/18.
//

//
//  ViewController.m
//  RichTextDemo
//
//  Created by Victor on 16/10/7.
//  Copyright © 2016年 Victor. All rights reserved.
//

#import "SFWebViewVC.h"
#import "UIImage+FixOrientation.h"

@interface SFWebViewVC ()<UIWebViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    NSString *_htmlString;//保存输出的富文本
    NSMutableArray *_imageArr;//保存添加的图片
    NSMutableArray *selectImageArr; // 选择的图片
    NSInteger degree;
    NSMutableArray *urlArr;
    BOOL isDismiss;
  
}

@property (nonatomic,strong)UIWebView *webView;

@property (nonatomic,assign)NSInteger numberTS;

@end

@implementation SFWebViewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectImageArr = [[NSMutableArray alloc] init];
    urlArr = [[NSMutableArray alloc] initWithCapacity:15];
    
    self.title=@"webviewtest1";
    // 导航栏
   // [self initNavTitle:@"服务详情" rightBtn:@"保存"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 40, 80, 30)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSBundle *bundle = [NSBundle mainBundle];
    //richTextEditor
    
    NSURL *indexFileURL = [bundle URLForResource:@"test" withExtension:@"html"];

    [self.webView setKeyboardDisplayRequiresUserAction:NO];
    
   
    [self.webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
    
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
    self.navigationItem.rightBarButtonItems=@[item];
    
    
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
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


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.inHtmlString.length > 0)
    {
        NSString *place = [NSString stringWithFormat:@"window.placeHTMLToEditor('%@')",self.inHtmlString];
//        place = @"window.placeHTMLToEditor('喜欢电话回电话电话<img src="https://dev.images2.17duu.com/uploads/pictures/2018/12/27/89a3112c276bbe87898a21edd4329b0c.jpg'/><div><br></div>')";
        place = [self removeSpaceAndNewline:place];
        NSString*sstr= [place stringByReplacingOccurrencesOfString:@".jpeg" withString:@".jpeg/1920x1080"];
        NSLog(@"=====%@",sstr);
        [webView stringByEvaluatingJavaScriptFromString:sstr];
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



- (void)printHTML
{
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('title-input').value"];
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerHTML"];
    
    NSString *first = [html substringToIndex:1];

    NSMutableString *mStr = [[NSMutableString alloc] initWithString:html];
    if ([first isEqualToString:@"<"]) {
        // 不作处理
    } else if ([mStr containsString:@"<img"]) {
        NSRange range = [mStr rangeOfString:@"<"];
        [mStr insertString:@"</p>" atIndex:range.location];
        [mStr insertString:@"<p>" atIndex:0];
        
        html = [mStr copy];
    } else {
        html = [NSString stringWithFormat:@"<p>%@</p>",html];
    }
    html = [html stringByReplacingOccurrencesOfString:@"<div>" withString:@"<p>"];
    html = [html stringByReplacingOccurrencesOfString:@"</div>" withString:@"</p>"];
    if ([html containsString:@"www.17duu.com"]) {
        
    }
    
    NSString *script = [self.webView stringByEvaluatingJavaScriptFromString:@"window.alertHtml()"];
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    NSLog(@"Title: %@", title);
    NSLog(@"Inner HTML: %@", html);
    
    if (html.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
    }
    else
    {
        _htmlString = html;
        //对输出的富文本进行处理后上传
        NSString *htmlStr = [self changeString:_htmlString];
        
        NSError *error;
        NSString *regexStr = @".?www.17duu.com.?";
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
        NSArray *array = [regex matchesInString:htmlStr options:0 range:NSMakeRange(0, htmlStr.length)];
        for (int i = (int)array.count -1; i >= 0; i--) {
            NSTextCheckingResult *str2 = array[i];
            NSString *url;
            if (i<urlArr.count) {
                 url = [NSString stringWithFormat:@"\"%@\"/",urlArr[i]];
            }
            if (url.length>0) {
                htmlStr = [htmlStr stringByReplacingCharactersInRange:str2.range withString:url];
            }
        }
        
       
        if (self.didClickBlock) {
            self.didClickBlock(htmlStr);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
        
        //tempImg =  [RSTools compressImage:tempImg ToSize:CGSizeMake(KscaleSize, tempImg.size.height *KscaleSize/tempImg.size.width) andFieldSize:1024*400 ];
        [tempImg fixOrientation];
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
  NSString*str= [self.webView stringByEvaluatingJavaScriptFromString:script];
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
    NSLog(@"+++%@",str);
    NSLog(@"+++++++%@",html);
    
    isDismiss = NO;
}

- (void)saveText
{
    [self printHTML];
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
    
//    NSString *url = [NSString stringWithFormat:@"%@aliyun/oss/client/signature?type=image&image_type=%d",DuuOldURL,UpimageWithShortRental];
//    [RSNetWorkingClass getDataWithUrl:url andSuccess:^(id data) {
//
//        if ([data[@"code"] integerValue] == 200) {
//            [self uploadFile:data[@"data"]];
//        } else {
//            [self showAlertText:[CodeShowMsg showErrorMsg:[data[@"code"] integerValue]]];
//        }
//    } andFail:^(NSString *errorMessage) {
//        [self showAlertText:errorMessage];
//    }];
}

- (void)uploadFile:(NSDictionary *)dataDict {
    
//    if (![dataDict isKindOfClass:[NSDictionary class]] || ![dataDict[@"sign"] isKindOfClass:[NSDictionary class]]) {
//        return;
//    }
//
//    // 添加占位元素
//    [urlArr removeAllObjects];
//
//    NSMutableDictionary *myDic = [[NSMutableDictionary alloc] init];
//
//    self.numberTS = 0;
//    degree = 0;
//
//    NSDictionary *sign = dataDict[@"sign"];
//    NSString *endpoint = Endpoint;
//    // 移动端建议使用STS方式初始化OSSClient。可以通过sample中STS使用说明了解更多(https://github.com/aliyun/aliyun-oss-ios-sdk/tree/master/DemoByOC)
//    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:sign[@"AccessKeyId"] secretKeyId:sign[@"AccessKeySecret"] securityToken:sign[@"SecurityToken"]];
//    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
//
//    //    NSArray *arr = [self.manager selectedPhotoArray];
//    [self showHUDonNav:nil];
//    for (int i = 0; i<selectImageArr.count; i++) {
////        NSData *data = UIImagePNGRepresentation(selectImageArr[i]);
//        NSData *data =  UIImageJPEGRepresentation(selectImageArr[i], 0.5);
//        NSString *imageSuffix = [RSTools imageTypeWithData:data];
//        NSString *filename = [NSString stringWithFormat:@"%@.%@",[RSTools randomStringWithLength:6],imageSuffix];
//        NSString *currentDate = [RSTools currentTimeStr];
//        NSString *objectKey = [NSString stringWithFormat:@"%@%@",currentDate,filename];
//        objectKey = [objectKey MD5Hash];
//        objectKey = [NSString stringWithFormat:@"%@%@.%@",dataDict[@"dir"],objectKey,imageSuffix];
//
//        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
//        put.bucketName = dataDict[@"bucket"];
//        put.objectKey = objectKey;
//        put.uploadingData = data; // 直接上传NSData
//        put.callbackParam = @{@"callbackUrl": sign[@"callback_param"][@"callbackUrl"],@"callbackBody": sign[@"callback_param"][@"callbackBody"]
//                              };
//        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//            NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//        };
//        OSSTask * putTask = [client putObject:put];
//        [putTask continueWithBlock:^id(OSSTask *task) {
//            if (!task.error) {
//                self.numberTS++;
//                OSSCallBackResult *result = (OSSCallBackResult *)task.result;
//                NSDictionary *dict = [RSTools dictionaryWithJsonString:result.serverReturnJsonString];
//                NSDictionary *dataDict = dict[@"data"];
//
//                NSString *url = [NSString stringWithFormat:@"%@%@",DuuImageURL,dataDict[@"filename"]];
////                [urlArr insertObject:url atIndex:i];
//                [myDic setValue:url forKey:[NSString stringWithFormat:@"image%d",i]];
//                degree++;
//                if (degree == selectImageArr.count) {
//                    // 同步到主线程
//                    [self removePerchObject:myDic];
//                    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
//                }
//            } else {
//                // 同步到主线程
//                [self performSelectorOnMainThread:@selector(upError) withObject:nil waitUntilDone:NO];
//            }
//            return nil;
//        }];
//    }
}

- (void)upError {
    //[self removeHUD];
    if (self.numberTS==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"网络故障，请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
        self.numberTS++;
    }
}

- (void)updateUI {
   // [self removeHUD];
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


/*
 
 <div id="content" contenteditable="true" onmouseup="saveSelection();" onkeyup="saveSelection();" onfocus="restoreSelection();" placeholder="轻触屏幕开始编辑正文">&nbsp;Try h I u<img src="/var/mobile/Containers/Data/Application/56DAB5AF-75DB-426C-821D-A2086278EE88/Documents/iOS1610937271.jpg" id="www.17duu.com"><div><br></div></div>
 
 
 
 
 
 */
@end
