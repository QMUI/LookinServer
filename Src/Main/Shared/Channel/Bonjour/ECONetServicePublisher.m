//
//  ECONetServicePublisher.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/17. Maintain by 陈爱彬
//  Description 
//

#import "ECONetServicePublisher.h"
#import "LookinDefines.h"

@interface ECONetServicePublisher()
<NSNetServiceDelegate>

@property (nonatomic, strong) NSNetService *netService;
@end

@implementation ECONetServicePublisher

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - Publish Service
- (void)startPublish {
    if (self.netService) {
        [self.netService stop];
        self.netService.delegate = nil;
        self.netService = nil;
    }
    self.netService = [[NSNetService alloc] initWithDomain:LookinNetServiceDomain type:LookinNetServiceType name:LookinNetServiceName port:LookinNetServicePortNumber];
    self.netService.delegate = self;
    [self.netService publish];
}
#pragma mark - NSNetServiceDelegate methods
/* Sent to the NSNetService instance's delegate when the publication of the instance is complete and successful.
 */
- (void)netServiceDidPublish:(NSNetService *)sender {
    
}
/* Sent to the NSNetService instance's delegate when an error in publishing the instance occurs. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a successful publication.
 */
- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *, NSNumber *> *)errorDict {
    
}

@end
