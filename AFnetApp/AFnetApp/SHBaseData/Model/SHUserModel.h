//
//  SHUserModel.h
//  AFnetApp
//
//  Created by Jobs Plato on 2021/1/8.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
NS_ASSUME_NONNULL_BEGIN


@interface SHMall :NSObject
@property (nonatomic , copy) NSString              * key;
@property (nonatomic , assign) NSInteger              userid;
@property (nonatomic , copy) NSString              * username;

@end

@interface SHUserModel : NSObject

@property (nonatomic , copy) NSString              * chat_token;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , assign) NSInteger              uid;
@property (nonatomic , copy) NSString              * huanxin_password;
@property (nonatomic , assign) NSInteger              is_first_time;
@property (nonatomic , strong) SHMall              * mall;

@end

NS_ASSUME_NONNULL_END
