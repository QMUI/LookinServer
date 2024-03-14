//
//  ECONetServiceBrowser.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/17. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>

typedef void(^ECONetServiceBrowserResolvedAddressesBlock)(NSArray<NSData *> *addresses, NSString *hostName);

@interface ECONetServiceBrowser : NSObject

@property (nonatomic, copy) ECONetServiceBrowserResolvedAddressesBlock addressesBlock;

- (void)startBrowsing;

@end
