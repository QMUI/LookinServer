//
//  LookinHierarchyInfo+LookinServer.h
//  LookinServer
//
//  Created by JH on 2024/11/5.
//

#import "LookinHierarchyInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LookinHierarchyInfo (LookinServer)
/// version 可能为 nil，此时说明 Client 版本号 < 1.0.4
+ (instancetype)staticInfoWithLookinVersion:(NSString *)version;

+ (instancetype)exportedInfo;
@end

NS_ASSUME_NONNULL_END
