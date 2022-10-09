//
//  LKS_RequestHandler.h
//  LookinServer
//
//  Created by Li Kai on 2019/1/15.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

@interface LKS_RequestHandler : NSObject

- (BOOL)canHandleRequestType:(uint32_t)requestType;

- (void)handleRequestType:(uint32_t)requestType tag:(uint32_t)tag object:(id)object;

@end
