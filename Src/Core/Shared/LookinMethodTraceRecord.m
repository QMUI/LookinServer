//
//  LookinMethodTraceRecord.m
//  Lookin
//
//  Created by Li Kai on 2019/5/27.
//  https://lookin.work
//



#import "LookinMethodTraceRecord.h"

#import "NSArray+Lookin.h"

@implementation LookinMethodTraceRecordStackItem

@end

@implementation LookinMethodTraceRecord

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.targetAddress forKey:@"targetAddress"];
    [aCoder encodeObject:self.selClassName forKey:@"selClassName"];
    [aCoder encodeObject:self.selName forKey:@"selName"];
    [aCoder encodeObject:self.args forKey:@"args"];
    [aCoder encodeObject:self.callStacks forKey:@"callStacks"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.targetAddress = [aDecoder decodeObjectForKey:@"targetAddress"];
        self.selClassName = [aDecoder decodeObjectForKey:@"selClassName"];
        self.selName = [aDecoder decodeObjectForKey:@"selName"];
        self.args = [aDecoder decodeObjectForKey:@"args"];
        self.callStacks = [aDecoder decodeObjectForKey:@"callStacks"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        
        _combinedTitle = [self _makeCombinedTitle];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSArray<LookinMethodTraceRecordStackItem *> *)briefFormattedCallStacks {
    return [self _formattedStacksFromRawStacks:self.callStacks brief:YES];
}

- (NSArray<LookinMethodTraceRecordStackItem *> *)completeFormattedCallStacks {
    return [self _formattedStacksFromRawStacks:self.callStacks brief:NO];
}

- (NSString *)_makeCombinedTitle {
    NSString *selString;
    if (self.args.count) {
        NSArray<NSString *> *selParts = [[self.selName componentsSeparatedByString:@":"] lookin_filter:^BOOL(NSString *obj) {
            return obj.length > 0;
        }];
        NSMutableString *mutableSelString = [NSMutableString string];
        [selParts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableSelString appendString:obj];
            NSString *arg = [self.args lookin_safeObjectAtIndex:idx];
            if (arg) {
                [mutableSelString appendFormat:@":%@", arg];
            } else {
                [mutableSelString appendString:@":?"];
            }
            if (idx < selParts.count - 1) {
                [mutableSelString appendString:@" "];
            }
        }];
        selString = mutableSelString.copy;
    } else {
        selString = self.selName;
    }
    
    NSString *combinedTitle = [NSString stringWithFormat:@"[(%@ *)%@ %@]", self.selClassName, self.targetAddress, selString];
    return combinedTitle;
}

- (NSArray<LookinMethodTraceRecordStackItem *> *)_formattedStacksFromRawStacks:(NSArray<NSString *> *)strings brief:(BOOL)brief {
    NSMutableArray<LookinMethodTraceRecordStackItem *> *items = [NSMutableArray array];
    [items addObject:({
        LookinMethodTraceRecordStackItem *item = [LookinMethodTraceRecordStackItem new];
        item.idx = 0;
        item.detail = [NSString stringWithFormat:@"-[%@ %@]", self.selClassName, self.selName];
        item;
    })];
    [items addObjectsFromArray:[strings lookin_map:^id(NSUInteger idx, NSString *value) {
        if (idx <= 2) {
            // 过滤掉 Lookin 相关
            return nil;
        }
        LookinMethodTraceRecordStackItem *item = [self _formattedStackItemFromRawString:value];
        item.idx = idx - 2;
        return item;
    }]];
    
    if (!brief) {
        return items.copy;
    }
    
    NSMutableArray<LookinMethodTraceRecordStackItem *> *briefItems = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(LookinMethodTraceRecordStackItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.category isEqualToString:@"???"]) {
            return;
        }
        if (!obj.isSystemItem) {
            [briefItems addObject:obj];
            return;
        }
        if (!briefItems.lastObject.isSystemItem) {
            [briefItems addObject:obj];
            return;
        }
        
        LookinMethodTraceRecordStackItem *nextItem = [items lookin_safeObjectAtIndex:idx + 1];
        if (!nextItem || !nextItem.isSystemItem) {
            [briefItems addObject:obj];
            
            LookinMethodTraceRecordStackItem *prevItem = [items lookin_safeObjectAtIndex:idx - 1];
            LookinMethodTraceRecordStackItem *prevPrevItem = [items lookin_safeObjectAtIndex:idx - 2];
            if (prevItem && prevPrevItem && prevItem.isSystemItem && prevPrevItem.isSystemItem) {
                obj.isSystemSeriesEnding = YES;
            }
        }
    }];
    return briefItems.copy;
}

- (LookinMethodTraceRecordStackItem *)_formattedStackItemFromRawString:(NSString *)string {
    LookinMethodTraceRecordStackItem *item = [LookinMethodTraceRecordStackItem new];
    item.category = ({
        NSArray<NSString *> *strs = [[string componentsSeparatedByString:@" "] lookin_filter:^BOOL(NSString *obj) {
            return obj.length > 0;
        }];
        strs[1];
    });
    item.detail = ({
        NSString *tmpStr = [[string componentsSeparatedByString:@"    "].lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSUInteger loc0 = [tmpStr rangeOfString:@" "].location;
        NSUInteger loc1 = [tmpStr rangeOfString:@" + "].location;
        NSString *str = [tmpStr substringWithRange:NSMakeRange(loc0 + 1, loc1 - loc0)];
        str;
    });
    if ([item.category isEqualToString:@"UIKitCore"] ||
        [item.category isEqualToString:@"libdyld.dylib"] ||
        [item.category isEqualToString:@"CoreFoundation"]) {
        item.isSystemItem = YES;
    }
    return item;
}

@end
