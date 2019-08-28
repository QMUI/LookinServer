//
//  LKS_Helper.h
//  LookinServer
//
//  
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LKS_Localized(stringKey) NSLocalizedStringFromTableInBundle(stringKey, nil, [NSBundle bundleForClass:self.class], nil)

@interface LKS_Helper : NSObject

@end
