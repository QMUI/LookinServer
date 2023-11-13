#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LKS_CustomAttrModificationHandler.h
//  LookinServer
//
//  Created by likaimacbookhome on 2023/11/4.
//

#import <Foundation/Foundation.h>
#import "LookinCustomAttrModification.h"

@interface LKS_CustomAttrModificationHandler : NSObject

/// 返回值表示是否修改成功（有成功调用 setter block 就算成功）
+ (BOOL)handleModification:(LookinCustomAttrModification *)modification;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
