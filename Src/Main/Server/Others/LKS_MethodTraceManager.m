#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_MethodTraceManager.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/22.
//  https://lookin.work
//

#import "LKS_MethodTraceManager.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "LKS_ConnectionManager.h"
#import "LookinMethodTraceRecord.h"
#import "LookinServerDefines.h"

static NSString * const kActiveListKey_Class = @"class";
static NSString * const kActiveListKey_Sels = @"sels";

static NSArray<NSString *> *LKS_ArgumentsDescriptionsFromInvocation(NSInvocation *invocation) {
    NSMethodSignature *signature = [invocation methodSignature];
    NSUInteger argsCount = signature.numberOfArguments;
    
    NSArray<NSString *> *strings = [NSArray lookin_arrayWithCount:(argsCount - 2) block:^id(NSUInteger idx) {
        NSUInteger argIdx = idx + 2;
        
        const char *argType = [signature getArgumentTypeAtIndex:argIdx];
        
        ///TODO:v, *, , [array type], {name=type...}, (name=type...), bnum, ^type, ?
        // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100
        if (strcmp(argType, @encode(char)) == 0) {
            char charValue;
            [invocation getArgument:&charValue atIndex:argIdx];
            return [NSString stringWithFormat:@"%@", @(charValue)];
            
        } else if (strcmp(argType, @encode(int)) == 0) {
            int intValue;
            [invocation getArgument:&intValue atIndex:argIdx];
            if (intValue == INT_MAX) {
                return @"INT_MAX";
            } else if (intValue == INT_MIN) {
                return @"INT_MIN";
            } else {
                return [NSString stringWithFormat:@"%@", @(intValue)];
            }
            
        } else if (strcmp(argType, @encode(short)) == 0) {
            short shortValue;
            [invocation getArgument:&shortValue atIndex:argIdx];
            if (shortValue == SHRT_MAX) {
                return @"SHRT_MAX";
            } else if (shortValue == SHRT_MIN) {
                return @"SHRT_MIN";
            } else {
                return [NSString stringWithFormat:@"%@", @(shortValue)];
            }
            
        } else if (strcmp(argType, @encode(long)) == 0) {
            long longValue;
            [invocation getArgument:&longValue atIndex:argIdx];
            if (longValue == NSNotFound) {
                return @"NSNotFound";
            } else if (longValue == LONG_MAX) {
                return @"LONG_MAX";
            } else if (longValue == LONG_MIN) {
                return @"LONG_MAX";
            } else {
                return [NSString stringWithFormat:@"%@", @(longValue)];
            }
            
        } else if (strcmp(argType, @encode(long long)) == 0) {
            long long longLongValue;
            [invocation getArgument:&longLongValue atIndex:argIdx];
            if (longLongValue == LLONG_MAX) {
                return @"LLONG_MAX";
            } else if (longLongValue == LLONG_MIN) {
                return @"LLONG_MIN";
            } else {
                return [NSString stringWithFormat:@"%@", @(longLongValue)];
            }
            
        } else if (strcmp(argType, @encode(unsigned char)) == 0) {
            unsigned char ucharValue;
            [invocation getArgument:&ucharValue atIndex:argIdx];
            if (ucharValue == UCHAR_MAX) {
                return @"UCHAR_MAX";
            } else {
                return [NSString stringWithFormat:@"%@", @(ucharValue)];
            }
            
        } else if (strcmp(argType, @encode(unsigned int)) == 0) {
            unsigned int uintValue;
            [invocation getArgument:&uintValue atIndex:argIdx];
            if (uintValue == UINT_MAX) {
                return @"UINT_MAX";
            } else {
                return [NSString stringWithFormat:@"%@", @(uintValue)];
            }
            
        } else if (strcmp(argType, @encode(unsigned short)) == 0) {
            unsigned short ushortValue;
            [invocation getArgument:&ushortValue atIndex:argIdx];
            if (ushortValue == USHRT_MAX) {
                return @"USHRT_MAX";
            } else {
                return [NSString stringWithFormat:@"%@", @(ushortValue)];
            }
            
        } else if (strcmp(argType, @encode(unsigned long)) == 0) {
            unsigned long ulongValue;
            [invocation getArgument:&ulongValue atIndex:argIdx];
            if (ulongValue == ULONG_MAX) {
                return @"ULONG_MAX";
            } else {
                return [NSString stringWithFormat:@"%@", @(ulongValue)];
            }
            
        } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
            unsigned long long ulongLongValue;
            [invocation getArgument:&ulongLongValue atIndex:argIdx];
            if (ulongLongValue == ULONG_LONG_MAX) {
                return @"ULONG_LONG_MAX";
            } else {
                return [NSString stringWithFormat:@"%@", @(ulongLongValue)];
            }
            
        } else if (strcmp(argType, @encode(float)) == 0) {
            float floatValue;
            [invocation getArgument:&floatValue atIndex:argIdx];
            if (floatValue == FLT_MAX) {
                return @"FLT_MAX";
            } else if (floatValue == FLT_MIN) {
                return @"FLT_MIN";
            } else {
                return [NSString stringWithFormat:@"%@", @(floatValue)];
            }
            
        } else if (strcmp(argType, @encode(double)) == 0) {
            double doubleValue;
            [invocation getArgument:&doubleValue atIndex:argIdx];
            if (doubleValue == DBL_MAX) {
                return @"DBL_MAX";
            } else if (doubleValue == DBL_MIN) {
                return @"DBL_MIN";
            } else {
                return [NSString stringWithFormat:@"%@", @(doubleValue)];
            }
            
        } else if (strcmp(argType, @encode(BOOL)) == 0) {
            BOOL boolValue;
            [invocation getArgument:&boolValue atIndex:argIdx];
            return boolValue ? @"YES" : @"NO";
            
        } else if (strcmp(argType, @encode(SEL)) == 0) {
            SEL selValue;
            [invocation getArgument:&selValue atIndex:argIdx];
            return [NSString stringWithFormat:@"SEL(%@)", NSStringFromSelector(selValue)];
            
        } else if (strcmp(argType, @encode(Class)) == 0) {
            Class classValue;
            [invocation getArgument:&classValue atIndex:argIdx];
            return [NSString stringWithFormat:@"<%@>", NSStringFromClass(classValue)];
            
        } else if (strcmp(argType, @encode(CGPoint)) == 0) {
            CGPoint targetValue;
            [invocation getArgument:&targetValue atIndex:argIdx];
            return NSStringFromCGPoint(targetValue);
            
        } else if (strcmp(argType, @encode(CGVector)) == 0) {
            CGVector targetValue;
            [invocation getArgument:&targetValue atIndex:argIdx];
            return NSStringFromCGVector(targetValue);
            
        } else if (strcmp(argType, @encode(CGSize)) == 0) {
            CGSize targetValue;
            [invocation getArgument:&targetValue atIndex:argIdx];
            return NSStringFromCGSize(targetValue);
            
        } else if (strcmp(argType, @encode(CGRect)) == 0) {
            CGRect targetValue;
            [invocation getArgument:&targetValue atIndex:argIdx];
            return NSStringFromCGRect(targetValue);
            
        } else if (strcmp(argType, @encode(CGAffineTransform)) == 0) {
            CGAffineTransform targetValue;
            [invocation getArgument:&targetValue atIndex:argIdx];
            return NSStringFromCGAffineTransform(targetValue);
            
        } else if (strcmp(argType, @encode(UIEdgeInsets)) == 0) {
            UIEdgeInsets targetValue;
            [invocation getArgument:&targetValue atIndex:argIdx];
            return NSStringFromUIEdgeInsets(targetValue);
            
        } else if (strcmp(argType, @encode(UIOffset)) == 0) {
            UIOffset targetValue;
            [invocation getArgument:&targetValue atIndex:argIdx];
            return NSStringFromUIOffset(targetValue);
            
        } else if (strcmp(argType, @encode(NSRange)) == 0) {
            NSRange targetValue;
            [invocation getArgument:&targetValue atIndex:argIdx];
            return NSStringFromRange(targetValue);
            
        } else {
            if (@available(iOS 11.0, tvOS 11.0, *)) {
                if (strcmp(argType, @encode(NSDirectionalEdgeInsets)) == 0) {
                    NSDirectionalEdgeInsets targetValue;
                    [invocation getArgument:&targetValue atIndex:argIdx];
                    return NSStringFromDirectionalEdgeInsets(targetValue);
                }
            }
            
            NSString *argType_string = [[NSString alloc] lookin_safeInitWithUTF8String:argType];
            if ([argType_string hasPrefix:@"@"]) {
                __unsafe_unretained id objValue;
                [invocation getArgument:&objValue atIndex:argIdx];
                
                if (objValue) {
                    if ([objValue isKindOfClass:[NSString class]]) {
                        return [NSString stringWithFormat:@"\"%@\"", objValue];
                    }
                    
                    NSString *objDescription = [objValue description];
                    if (objDescription.length > 20) {
                        return [NSString stringWithFormat:@"(%@ *)%p", NSStringFromClass([objValue class]), objValue];
                    } else {
                        return objDescription;
                    }
                } else {
                    return @"nil";
                }
            }
        }
        return @"?";
    }];
    
    return strings.copy;
}


static SEL LKS_AltSelectorFromSelector(SEL originalSelector) {
    NSString *selectorName = NSStringFromSelector(originalSelector);
    return NSSelectorFromString([@"lks_alt_" stringByAppendingString:selectorName]);
}

static NSMutableDictionary<NSString *, NSMutableSet<NSString *> *> *LKS_HookedDict() {
    static NSMutableDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = [NSMutableDictionary dictionary];
    });
    return dict;
}

static NSMutableArray<NSDictionary<NSString *, id> *> *LKS_ActiveList() {
    static NSMutableArray *list;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        list = [NSMutableArray array];
    });
    return list;
}

static void Lookin_PleaseRemoveMethodTraceInLookinAppIfCrashHere(Class targetClass) {
    SEL forwardInvocationSel = @selector(forwardInvocation:);
    Method forwardInvocationMethod = class_getInstanceMethod(targetClass, forwardInvocationSel);
    
    void (*originalForwardInvocation)(id, SEL, NSInvocation *) = NULL;
    if (forwardInvocationMethod != NULL) {
        originalForwardInvocation = (__typeof__(originalForwardInvocation))method_getImplementation(forwardInvocationMethod);
    }
    
    id newForwardInvocation = ^(id target, NSInvocation *invocation) {
        __block BOOL isHookedSel = NO;
        __block BOOL shouldNotify = NO;
        [LKS_HookedDict() enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull enumeratedClassName, NSMutableSet<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([target isKindOfClass:NSClassFromString(enumeratedClassName)]) {
                NSString *invocationSelName = NSStringFromSelector(invocation.selector);
                isHookedSel = [obj containsObject:invocationSelName];
                
                NSArray<NSString *> *activeSels = [[LKS_ActiveList() lookin_firstFiltered:^BOOL(NSDictionary<NSString *,id> *obj) {
                    return [obj[kActiveListKey_Class] isEqualToString:enumeratedClassName];
                }] objectForKey:kActiveListKey_Sels];
                shouldNotify = [activeSels lookin_any:^BOOL(NSString *obj) {
                    return [obj isEqualToString:invocationSelName];
                }];
                
                *stop = YES;
            }
        }];
        if (isHookedSel) {
            if (shouldNotify) {
                LookinMethodTraceRecord *record = [LookinMethodTraceRecord new];
                record.targetAddress = [NSString stringWithFormat:@"%p", invocation.target];
                record.selClassName = NSStringFromClass([invocation.target class]);
                record.selName = NSStringFromSelector(invocation.selector);
                record.callStacks = [NSThread callStackSymbols];
                record.args = LKS_ArgumentsDescriptionsFromInvocation(invocation);
                record.date = [NSDate date];
                [[LKS_ConnectionManager sharedInstance] pushData:record type:LookinPush_MethodTraceRecord];
            }
            invocation.selector = LKS_AltSelectorFromSelector(invocation.selector);
            [invocation invoke];
            return;
        }
        if (originalForwardInvocation == NULL) {
            [target doesNotRecognizeSelector:invocation.selector];
        } else {
            originalForwardInvocation(target, forwardInvocationSel, invocation);
        }
    };
    class_replaceMethod(targetClass, forwardInvocationSel, imp_implementationWithBlock(newForwardInvocation), "v@:@");
    
    [LKS_HookedDict() setValue:[NSMutableSet set] forKey:NSStringFromClass(targetClass)];
}

@interface LKS_MethodTraceManager ()

@end

@implementation LKS_MethodTraceManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKS_MethodTraceManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)removeWithClassName:(NSString *)className selName:(NSString *)selName {
    if (!className.length) {
        return;
    }
    NSUInteger classIdx = [LKS_ActiveList() indexOfObjectPassingTest:^BOOL(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj[kActiveListKey_Class] isEqualToString:className];
    }];
    if (classIdx == NSNotFound) {
        return;
    }
    if (selName) {
        NSDictionary<NSString *, id> *classDict = [LKS_ActiveList() objectAtIndex:classIdx];
        NSMutableArray<NSString *> *sels = classDict[kActiveListKey_Sels];
        [sels removeObject:selName];
        if (sels.count == 0) {
            [LKS_ActiveList() removeObjectAtIndex:classIdx];
        }
        
    } else {
        [LKS_ActiveList() removeObjectAtIndex:classIdx];
    }
}

- (void)addWithClassName:(NSString *)targetClassName selName:(NSString *)targetSelName {
    BOOL isValid = [self _isValidWithClassName:targetClassName selName:targetSelName];
    if (!isValid) {
        return;
    }
    
    BOOL addSucc = [self _addToActiveListWithClassName:targetClassName selName:targetSelName];
    if (!addSucc) {
        return;
    }
    
    Class targetClass = NSClassFromString(targetClassName);
    SEL targetSel = NSSelectorFromString(targetSelName);
    Method targetMethod = class_getInstanceMethod(targetClass, targetSel);
    
    @synchronized (self) {
        if (![LKS_HookedDict() valueForKey:targetClassName]) {
            Lookin_PleaseRemoveMethodTraceInLookinAppIfCrashHere(targetClass);
        }
        
        NSMutableSet<NSString *> *hookedSelNames = [LKS_HookedDict() objectForKey:targetClassName];
        if ([hookedSelNames containsObject:targetSelName]) {
            return;
        }
        class_addMethod(targetClass, LKS_AltSelectorFromSelector(targetSel), method_getImplementation(targetMethod), method_getTypeEncoding(targetMethod));
        if (method_getImplementation(targetMethod) != _objc_msgForward) {
            class_replaceMethod(targetClass, targetSel, _objc_msgForward, method_getTypeEncoding(targetMethod));
        }
        [hookedSelNames addObject:targetSelName];
    }
}

- (BOOL)_addToActiveListWithClassName:(NSString *)targetClassName selName:(NSString *)targetSelName {
    __block BOOL addSuccessfully = YES;
    
    NSDictionary *activeList_dict = [LKS_ActiveList() lookin_firstFiltered:^BOOL(NSDictionary<NSString *,id> *obj) {
        return [obj[kActiveListKey_Class] isEqualToString:targetClassName];
    }];
    if (activeList_dict) {
        NSMutableArray *sels = activeList_dict[kActiveListKey_Sels];
        if ([sels containsObject:targetSelName]) {
            addSuccessfully = NO;
        } else {
            [sels addObject:targetSelName];
        }
    } else {
        activeList_dict = @{kActiveListKey_Class:targetClassName, kActiveListKey_Sels: @[targetSelName].mutableCopy};
        [LKS_ActiveList() addObject:activeList_dict];
    }
    
    return addSuccessfully;
}

- (BOOL)_isValidWithClassName:(NSString *)targetClassName selName:(NSString *)targetSelName {
    if ([targetSelName isEqualToString:@"dealloc"]) {
        return NO;
    }
    Class targetClass = NSClassFromString(targetClassName);
    if (!targetClass) {
        return NO;
    }
    SEL targetSel = NSSelectorFromString(targetSelName);
    Method targetMethod = class_getInstanceMethod(targetClass, targetSel);
    if (targetSel == NULL || targetMethod == NULL) {
        return NO;
    }
    return YES;
}

- (NSArray<NSDictionary<NSString *, id> *> *)currentActiveTraceList {
    return LKS_ActiveList();
}

- (NSArray<NSString *> *)allClassesListInApp {
    NSSet<NSString *> *prefixesToAvoid = [NSSet setWithObjects:@"OS_", @"IBA", @"SKUI", @"HM", @"WBS", @"CDP", @"DMF", @"TimerSupport", @"Swift.", @"Foundation", @"CEM", @"PSUI", @"CPL", @"IPA", @"NSKeyValue", @"ICS", @"INIntent", @"NWConcrete", @"NSSQL", @"SASetting", @"SAM", @"GEO", @"PBBProto", @"AWD", @"MTL", @"PKPhysics", @"TIKeyEvent", @"TITypologyRecord", @"IDS", @"AVCapture", @"AVAsset", @"AVContent", nil];
    
    int numClasses;
    Class * classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    NSMutableArray<NSString *> *array = [NSMutableArray array];
    if (numClasses > 0) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            Class c = classes[i];
            NSString *className = NSStringFromClass(c);
            if (className) {
                BOOL shouldAvoid = [prefixesToAvoid lookin_any:^BOOL(NSString *prefix) {
                    return [className hasPrefix:prefix];
                }];
                if (!shouldAvoid) {
                    [array addObject:className];
                }
            }
        }
        free(classes);
    }
    return array.copy;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
