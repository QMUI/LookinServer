//
//  ECOChannelDeviceInfo.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/17. Maintain by 陈爱彬
//  Description 
//

#import "ECOChannelDeviceInfo.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <sys/utsname.h>

static NSInteger const ECOINET_ADDRSTRLEN = 16;
static NSInteger const ECOINET6_ADDRSTRLEN = 46;
static NSString *_macUUIDString = nil;

@interface ECOChannelDeviceInfo()

@property (nonatomic, readwrite) NSString *ipAddress;
@property (nonatomic, readwrite) NSString *uuid;
@property (nonatomic, readwrite) NSString *deviceName;
@property (nonatomic, readwrite) NSString *systemVersion;
@property (nonatomic, readwrite) NSString *deviceModel;
@property (nonatomic, readwrite) ECODeviceType deviceType;
@property (nonatomic, readwrite) ECOChannelAppInfo *appInfo;

@end

@implementation ECOChannelDeviceInfo

//解析网络信息传输过来的设备信息
- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSError *error = nil;
        NSDictionary *deviceDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (deviceDict) {
            self.uuid = deviceDict[@"uuid"];
            self.ipAddress = deviceDict[@"ipAddress"];
            self.deviceName = deviceDict[@"deviceName"];
            self.deviceType = [deviceDict[@"deviceType"] integerValue];
            self.systemVersion = deviceDict[@"systemVersion"];
            self.deviceModel = deviceDict[@"model"];
            self.authorizedType = [deviceDict[@"authType"] integerValue];
            self.showAuthAlert = [deviceDict[@"showAuth"] boolValue];
            self.hostName = deviceDict[@"hostName"];
            
            ECOChannelAppInfo *appInfo = [[ECOChannelAppInfo alloc] initWithDictionary:deviceDict[@"appInfo"]];
            self.appInfo = appInfo;
        }
    }
    return self;
}

- (id)copy {
    ECOChannelDeviceInfo *deviceInfo = [ECOChannelDeviceInfo new];
    deviceInfo.hostName = self.hostName;
    deviceInfo.ipAddress = self.ipAddress;
    deviceInfo.uuid = self.uuid;
    deviceInfo.deviceName = self.deviceName;
    deviceInfo.systemVersion = self.systemVersion;
    deviceInfo.deviceModel = self.deviceModel;
    deviceInfo.deviceType = self.deviceType;
    deviceInfo.authorizedType = self.authorizedType;
    deviceInfo.showAuthAlert = self.showAuthAlert;
    deviceInfo.appInfo = self.appInfo;
    
    return deviceInfo;
}

- (instancetype)init {
    self = [super init];
    if (self) {
#if TARGET_OS_OSX
        [self setupMacDeviceInfo];
#else
        [self setupIOSDeviceInfo];
#endif
        //ipAddress
        NSDictionary *addresses = [self getIPAddresses];
        //这里只取局域网的en0/ipv4地址，ipv6和pdp_ip0/ipv4暂时先忽略
        NSString *address = addresses[@"en0/ipv4"];
        self.ipAddress = address ?: @"0.0.0.0";
    }
    return self;
}
- (void)setupMacDeviceInfo {
    //uuid
    if (!_macUUIDString) {
        _macUUIDString = [[NSUUID UUID] UUIDString];
    }
    self.uuid = _macUUIDString;
    //设备
    self.deviceName = @"MacApp";
    self.deviceType = ECODeviceType_MacApp;
}
#if TARGET_OS_IPHONE
- (void)setupIOSDeviceInfo {
    //设备名称
    UIDevice *device = [UIDevice currentDevice];
    self.deviceName = device.name;
    self.deviceModel = device.model;
    self.systemVersion = device.systemVersion;
    //是否为模拟器
#if TARGET_IPHONE_SIMULATOR
    self.deviceType = ECODeviceType_Simulator;
#else
    self.deviceType = ECODeviceType_Device;
#endif
    //uuid
    //        self.uuid = [[NSUUID UUID] UUIDString];
    self.uuid = [[device identifierForVendor] UUIDString];
    
    ECOChannelAppInfo *appInfo = [ECOChannelAppInfo new];
    self.appInfo = appInfo;
}
#endif
#pragma mark - IPAddress
//获取本机的ip地址表
- (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(ECOINET_ADDRSTRLEN, ECOINET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, ECOINET_ADDRSTRLEN)) {
                        type = @"ipv4";
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, ECOINET6_ADDRSTRLEN)) {
                        type = @"ipv6";
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark - Helper
- (NSDictionary *)toJSONObject {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setValue:self.uuid ?: @"" forKey:@"uuid"];
    [json setValue:self.ipAddress ?: @"0.0.0.0" forKey:@"ipAddress"];
    [json setValue:self.deviceName ?: @"" forKey:@"deviceName"];
    [json setValue:self.deviceModel ?: @"" forKey:@"model"];
    [json setValue:@(self.deviceType) forKey:@"deviceType"];
    [json setValue:self.systemVersion ?: @"" forKey:@"systemVersion"];
    [json setValue:@(self.authorizedType) forKey:@"authType"];
    [json setValue:@(self.showAuthAlert) forKey:@"showAuth"];
    [json setValue:self.hostName ?: @"" forKey:@"hostName"];
    [json setValue:[self.appInfo toDictionary] forKey:@"appInfo"];
    
    return [json copy];
}
// 返回调试信息
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"uuid": self.uuid ?: @"",
                                               @"ipAddress": self.ipAddress ?: @"0.0.0.0",
                                               @"deviceName": self.deviceName ?: @"",
                                               @"deviceModel": self.deviceModel ?: @"",
                                               @"deviceType": @(self.deviceType),
                                               @"systemVersion": self.systemVersion ?: @"",
                                               @"authType": @(self.authorizedType),
                                               @"showAuth": @(self.showAuthAlert),
                                               @"appId": self.appInfo.appId ?: @"",
                                               @"appName": self.appInfo.appName ?: @"",
                                               @"hostName": self.hostName ?: @""
                                               }];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ECOChannelDeviceInfo class]]) {
        return NO;
    }
    ECOChannelDeviceInfo *device = (ECOChannelDeviceInfo *)object;
    if ([device.uuid isEqualToString:self.uuid] &&
        [device.appInfo.appId isEqualToString:self.appInfo.appId]) {
        return YES;
    }
    return NO;
}

@end
