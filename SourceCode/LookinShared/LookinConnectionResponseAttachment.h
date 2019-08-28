//
//  LookinConnectionResponse.h
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LookinConnectionAttachment.h"

@interface LookinConnectionResponseAttachment : LookinConnectionAttachment

+ (instancetype)attachmentWithError:(NSError *)error;

@property(nonatomic, assign) int lookinServerVersion;
@property(nonatomic, assign) BOOL lookinServerIsExprimental;

@property(nonatomic, strong) NSError *error;

/**
 dataTotalCount 为 0 时表示仅有这一个 response，大于 0 时表示可能有多个 response，当所有 response 的 currentDataCount 的总和大于 dataTotalCount 即表示所有 response 已接收完毕
 默认为 0
 */
@property(nonatomic, assign) NSUInteger dataTotalCount;
@property(nonatomic, assign) NSUInteger currentDataCount;

@end
