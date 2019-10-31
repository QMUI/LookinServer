//
//  UITableView+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/9/5.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <UIKit/UIKit.h>

@interface UITableView (LookinServer)

- (NSArray<NSNumber *> *)lks_numberOfRows;

@end

#endif
