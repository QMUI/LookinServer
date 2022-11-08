#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UITableView+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/9/5.
//  https://lookin.work
//

#import "UITableView+LookinServer.h"
#import "LookinServerDefines.h"

@implementation UITableView (LookinServer)

- (NSArray<NSNumber *> *)lks_numberOfRows {
    NSUInteger sectionsCount = MIN(self.numberOfSections, 10);
    NSArray<NSNumber *> *rowsCount = [NSArray lookin_arrayWithCount:sectionsCount block:^id(NSUInteger idx) {
        return @([self numberOfRowsInSection:idx]);
    }];
    if (rowsCount.count == 0) {
        return nil;
    }
    return rowsCount;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
