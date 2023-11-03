#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LKS_CustomAttrSetterManager.h
//  LookinServer
//
//  Created by likai.123 on 2023/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LKS_StringSetter)(NSString *);

@interface LKS_CustomAttrSetterManager : NSObject

- (void)removeAll;

- (void)saveStringSetter:(LKS_StringSetter)setter uniqueID:(NSString *)uniqueID;

- (nullable LKS_StringSetter)getSetterWithUniqueID:(NSString *)uniqueID;

@end

NS_ASSUME_NONNULL_END

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
