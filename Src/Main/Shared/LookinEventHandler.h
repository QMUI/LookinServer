#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinEventHandler.h
//  Lookin
//
//  Created by Li Kai on 2019/8/7.
//  https://lookin.work
//



#import <Foundation/Foundation.h>

@class LookinObject, LookinIvarTrace, LookinStringTwoTuple;

typedef NS_ENUM(NSInteger, LookinEventHandlerType) {
    LookinEventHandlerTypeTargetAction,
    LookinEventHandlerTypeGesture
};

@interface LookinEventHandler : NSObject <NSSecureCoding>

@property(nonatomic, assign) LookinEventHandlerType handlerType;

/// 比如 "UIControlEventTouchUpInside", "UITapGestureRecognizer"
@property(nonatomic, copy) NSString *eventName;
/// tuple.first => @"<WRHomeView: 0xff>"，tuple.second => @"handleTap"
@property(nonatomic, copy) NSArray<LookinStringTwoTuple *> *targetActions;

/// 返回当前 recognizer 是继承自哪一个基本款 recognizer。
/// 基本款 recognizer 指的是 TapRecognizer, PinchRecognizer 之类的常见 recognizer
/// 如果当前 recognizer 本身就是基本款 recognizer，则该属性为 nil
@property(nonatomic, copy) NSString *inheritedRecognizerName;
@property(nonatomic, assign) BOOL gestureRecognizerIsEnabled;
@property(nonatomic, copy) NSString *gestureRecognizerDelegator;
@property(nonatomic, copy) NSArray<NSString *> *recognizerIvarTraces;
/// recognizer 对象
@property(nonatomic, assign) unsigned long long recognizerOid;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
