//
//  LKS_WeakObjContainer.h
//  LookinServer
//
//  Created by andysheng on 2023/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKS_WeakObjContainer<__covariant ObjectType> : NSObject

@property (nonatomic, weak) ObjectType weakObj;
 
+ (instancetype)containerWithObj:(ObjectType)obj;

@end

NS_ASSUME_NONNULL_END
