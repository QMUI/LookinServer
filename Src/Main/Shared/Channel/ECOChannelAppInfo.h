//
//  ECOChannelAppInfo.h
//  EchoSDK
//
//  Created by 陈爱彬 on 2019/10/30. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>

@interface ECOChannelAppInfo : NSObject

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appShortVersion;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *appIcon;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)toDictionary;

//由外部设置通用的appid和appname
+ (void)setUniqueAppId:(NSString *)appId
               appName:(NSString *)appName;

@end
