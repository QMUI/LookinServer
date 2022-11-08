#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKImageFetchManager.h
//  Lookin_macOS
//
//  Created by 李凯 on 2019/1/15.
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LookinDisplayItem;

@interface LkScreenshotFetchManager : NSObject

+ (instancetype)sharedInstance;

- (void)prepare;

/// 拉取 item 的所有 ancestor 的 groupScreenshot
- (void)fetchGroupScreenshotForAncestorsOfItem:(LookinDisplayItem *)item;
/// 拉取 item 的 soloScreenshot
- (void)fetchSoloScreenshotForItem:(LookinDisplayItem *)item;
/// 拉取 item 的 groupScreenshot
- (void)fetchGroupScreenshotForItem:(LookinDisplayItem *)item;

- (void)submitTasks;

/// 拉取 items 的 soloScreenshot 和 groupScreenshot
- (void)fetchAndUpdateScreenshotsForItems:(NSArray<LookinDisplayItem *> *)items;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
