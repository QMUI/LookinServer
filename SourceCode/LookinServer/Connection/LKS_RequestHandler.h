//
//  LKS_RequestHandler.h
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKS_RequestHandler : NSObject

- (BOOL)canHandleRequestType:(uint32_t)requestType;

- (void)handleRequestType:(uint32_t)requestType tag:(uint32_t)tag object:(id)object;

@end
