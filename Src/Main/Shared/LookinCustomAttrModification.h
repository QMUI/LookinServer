#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LookinCustomAttrModification.h
//  LookinShared
//
//  Created by likaimacbookhome on 2023/11/4.
//

#import <Foundation/Foundation.h>
#import "LookinAttrType.h"

@interface LookinCustomAttrModification : NSObject <NSSecureCoding>

@property(nonatomic, assign) LookinAttrType attrType;
@property(nonatomic, copy) NSString *customSetterID;
@property(nonatomic, strong) id value;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
