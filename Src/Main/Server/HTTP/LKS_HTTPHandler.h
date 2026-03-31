#ifdef SHOULD_COMPILE_LOOKIN_SERVER

#import <Foundation/Foundation.h>

/// 路由分发 + 业务逻辑处理，直接调用 LookinServer 现有 API
/// 启动后监听 127.0.0.1:47190，供 lookin-mcp npm 包直连
@interface LKS_HTTPHandler : NSObject

- (void)startHTTPServer;
- (void)stopHTTPServer;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
