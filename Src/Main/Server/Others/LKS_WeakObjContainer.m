//
//  LKS_WeakObjContainer.m
//  LookinServer
//
//  Created by andysheng on 2023/1/6.
//

#import "LKS_WeakObjContainer.h"

@implementation LKS_WeakObjContainer

+ (instancetype)containerWithObj:(id)obj {
    LKS_WeakObjContainer *container = [LKS_WeakObjContainer new];
    container.weakObj = obj;
    return container;
}

@end
