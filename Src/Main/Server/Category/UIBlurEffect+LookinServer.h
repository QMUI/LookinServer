#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIBlurEffect+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/10/8.
//  https://lookin.work
//

#import <UIKit/UIKit.h>

@interface UIBlurEffect (LookinServer)

/// 该 number 包装的对象是 UIBlurEffectStyle，之所以用 NSNumber 是因为想把 0 和 nil 区分开，毕竟这里是在 hook 系统，稳一点好。
/// 该方法的实现需要 Hook，因此若定义了 LOOKIN_SERVER_DISABLE_HOOK 宏，则属性会返回 nil
@property(nonatomic, strong) NSNumber *lks_effectStyleNumber;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
