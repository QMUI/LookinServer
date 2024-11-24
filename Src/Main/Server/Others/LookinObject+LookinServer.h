//
//  LookinObject+LookinServer.h
//  LookinServer
//
//  Created by JH on 2024/11/5.
//

#import "LookinObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LookinObject (LookinServer)

+ (instancetype)instanceWithObject:(NSObject *)object;
@end

NS_ASSUME_NONNULL_END
