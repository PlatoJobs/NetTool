//
//  SFWebViewVC.h
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFWebViewVC : UIViewController

@property (nonatomic,strong)NSString *inHtmlString;

@property(nonatomic,copy) void (^didClickBlock)(NSString *content);


@end

NS_ASSUME_NONNULL_END
