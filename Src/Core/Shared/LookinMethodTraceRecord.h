//
//  LookinMethodTraceRecord.h
//  Lookin
//
//  Created by Li Kai on 2019/5/27.
//  https://lookin.work
//



#import <Foundation/Foundation.h>

@interface LookinMethodTraceRecordStackItem : NSObject

@property(nonatomic, assign) NSUInteger idx;

@property(nonatomic, copy) NSString *category;

@property(nonatomic, copy) NSString *detail;

@property(nonatomic, assign) BOOL isSystemSeriesEnding;

@property(nonatomic, assign) BOOL isSystemItem;

@end

@interface LookinMethodTraceRecord : NSObject <NSSecureCoding>

@property(nonatomic, copy) NSString *targetAddress;

@property(nonatomic, copy) NSString *selClassName;

@property(nonatomic, copy) NSString *selName;

@property(nonatomic, copy) NSArray<NSString *> *args;

@property(nonatomic, copy) NSArray<NSString *> *callStacks;


@property(nonatomic, strong) NSDate *date;

#pragma mark - Non Coding

@property(nonatomic, copy, readonly) NSString *combinedTitle;

- (NSArray<LookinMethodTraceRecordStackItem *> *)briefFormattedCallStacks;

- (NSArray<LookinMethodTraceRecordStackItem *> *)completeFormattedCallStacks;

@end
