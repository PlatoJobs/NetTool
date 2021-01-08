//
//  SHNetResult.h
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SHNetResult : NSObject

/** 提示信息 */
@property (nonatomic, copy) NSString *message;
/** 请求状态 */
@property (nonatomic, assign) NSInteger status;
/** 请求是否成功 */
@property (nonatomic, readonly) BOOL success;
/** 接收数据的字典  */
@property (nonatomic, strong) NSDictionary *dic;
/** 完成进度 */
@property(nonatomic,assign)CGFloat progress;
/** 字典处理 */
- (id)initWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
