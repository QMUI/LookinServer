//
//  ECONetServiceBrowser.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/17. Maintain by 陈爱彬
//  Description 
//

#import "ECONetServiceBrowser.h"
#import "LookinDefines.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface ECONetServiceBrowser()
<NSNetServiceDelegate,
NSNetServiceBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSNetServiceBrowser *serviceBrowser;

@end

@implementation ECONetServiceBrowser

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - Browser Services
//启动Bonjour服务搜索
- (void)startBrowsing {
    [self.services removeAllObjects];
    //创建Browser对象
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    self.serviceBrowser.includesPeerToPeer = YES;
    [self.serviceBrowser setDelegate:self];
    [self.serviceBrowser searchForServicesOfType:LookinNetServiceType inDomain:LookinNetServiceDomain];
}
//重置查找服务
- (void)resetBrowserService {
    [self.serviceBrowser stop];
    self.serviceBrowser = nil;
    //重启查找
    [self startBrowsing];
}
#pragma mark - NSNetServiceBrowserDelegate methods

/* Sent to the NSNetServiceBrowser instance's delegate for each service discovered. If there are more services, moreComing will be YES. If for some reason handling discovered services requires significant processing, accumulating services until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"%s",__func__);
    //解析服务
    [self.services addObject:service];
    service.delegate = self;
    [service resolveWithTimeout:LookinNetServiceResolveAddressTimeout];
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered service is no longer published.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"%s",__func__);
    //移除服务
    [self.services removeObject:service];
    service.delegate = nil;
}

/* Sent to the NSNetServiceBrowser instance's delegate when an error in searching for domains or services has occurred. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a search has been started successfully.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> *)errorDict {
    NSLog(@"%s",__func__);
    //重试
#if TARGET_OS_IPHONE
    if (@available(iOS 14.0, *)) {
        NSNetServicesError errorCode = [errorDict[@"NSNetServicesErrorCode"] integerValue];
        if (errorCode == -72008) {
            //iOS14新增本地网络隐私权限，提示用户如何设置并忽略
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *title = @"Echo 连接提示";
                NSString *message = @"由于iOS14本地网络权限限制，请在Info.plist中设置NSLocalNetworkUsageDescription和NSBonjourServices，详细内容见：https://github.com/didi/echo";
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                }];
                [alertController addAction:confirmAction];
                UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                [rootVC presentViewController:alertController animated:YES completion:nil];
            });
            NSLog(@">>Echo Warning：Bonjour服务错误，由于iOS14本地网络权限限制，请在Info.plist中设置NSLocalNetworkUsageDescription和NSBonjourServices，详细内容见：https://github.com/didi/echo");
            return;
        }
    }
#endif
    [self resetBrowserService];
}
#pragma mark - NSNetServiceDelegate methods

/* Sent to the NSNetService instance's delegate when one or more addresses have been resolved for an NSNetService instance. Some NSNetService methods will return different results before and after a successful resolution. An NSNetService instance may get resolved more than once; truly robust clients may wish to resolve again after an error, or to resolve more than once.
 */
- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    NSLog(@"%s",__func__);
    //解析address地址
    NSString *name = [sender name];
    NSString *hostName = name ?: [sender hostName];
    NSArray *addresses = [[sender addresses] copy];
    !self.addressesBlock ?: self.addressesBlock(addresses, hostName ?: @"");
}

/* Sent to the NSNetService instance's delegate when the instance's previously running publication or resolution request has stopped.
 */
- (void)netServiceDidStop:(NSNetService *)sender {
    NSLog(@"%s",__func__);
}

#pragma mark - getters
- (NSMutableArray *)services {
    if (!_services) {
        _services = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _services;
}

@end
