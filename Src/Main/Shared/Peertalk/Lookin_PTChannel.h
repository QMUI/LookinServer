#ifdef SHOULD_COMPILE_LOOKIN_SERVER 



//
// Represents a communication channel between two endpoints talking the same
// Lookin_PTProtocol.
//
#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import <netinet/in.h>
#import <sys/socket.h>

#import "Lookin_PTProtocol.h"
#import "Lookin_PTUSBHub.h"

@class Lookin_PTData, Lookin_PTAddress;
@protocol Lookin_PTChannelDelegate;

@interface Lookin_PTChannel : NSObject

// Delegate
@property (strong) id<Lookin_PTChannelDelegate> delegate;

// Communication protocol. Must not be nil.
@property Lookin_PTProtocol *protocol;

// YES if this channel is a listening server
@property (readonly) BOOL isListening;

// YES if this channel is a connected peer
@property (readonly) BOOL isConnected;

// Arbitrary attachment. Note that if you set this, the object will grow by
// 8 bytes (64 bits).
@property (strong) id userInfo;

@property(nonatomic, assign) int uniqueID;
@property(nonatomic, assign) NSInteger targetPort;
- (NSString *)debugTag;

// Create a new channel using the shared Lookin_PTProtocol for the current dispatch
// queue, with *delegate*.
+ (Lookin_PTChannel*)channelWithDelegate:(id<Lookin_PTChannelDelegate>)delegate;


// Initialize a new frame channel, configuring it to use the calling queue's
// protocol instance (as returned by [Lookin_PTProtocol sharedProtocolForQueue:
//   dispatch_get_current_queue()])
- (id)init;

// Initialize a new frame channel with a specific protocol.
- (id)initWithProtocol:(Lookin_PTProtocol*)protocol;

// Initialize a new frame channel with a specific protocol and delegate.
- (id)initWithProtocol:(Lookin_PTProtocol*)protocol delegate:(id<Lookin_PTChannelDelegate>)delegate;


// Connect to a TCP port on a device connected over USB
- (void)connectToPort:(int)port overUSBHub:(Lookin_PTUSBHub*)usbHub deviceID:(NSNumber*)deviceID callback:(void(^)(NSError *error))callback;

// Connect to a TCP port at IPv4 address. Provided port must NOT be in network
// byte order. Provided in_addr_t must NOT be in network byte order. A value returned
// from inet_aton() will be in network byte order. You can use a value of inet_aton()
// as the address parameter here, but you must flip the byte order before passing the
// in_addr_t to this function.
- (void)connectToPort:(in_port_t)port IPv4Address:(in_addr_t)address callback:(void(^)(NSError *error, Lookin_PTAddress *address))callback;

// Listen for connections on port and address, effectively starting a socket
// server. Provided port must NOT be in network byte order. Provided in_addr_t
// must NOT be in network byte order.
// For this to make sense, you should provide a onAccept block handler
// or a delegate implementing ioFrameChannel:didAcceptConnection:.
- (void)listenOnPort:(in_port_t)port IPv4Address:(in_addr_t)address callback:(void(^)(NSError *error))callback;

// Send a frame with an optional payload and optional callback.
// If *callback* is not NULL, the block is invoked when either an error occured
// or when the frame (and payload, if any) has been completely sent.
- (void)sendFrameOfType:(uint32_t)frameType tag:(uint32_t)tag withPayload:(dispatch_data_t)payload callback:(void(^)(NSError *error))callback;

// Lower-level method to assign a connected dispatch IO channel to this channel
- (BOOL)startReadingFromConnectedChannel:(dispatch_io_t)channel error:(__autoreleasing NSError**)error;

// Close the channel, preventing further reading and writing. Any ongoing and
// queued reads and writes will be aborted.
- (void)close;

// "graceful" close -- any ongoing and queued reads and writes will complete
// before the channel ends.
- (void)cancel;

@end


// Wraps a mapped dispatch_data_t object. The memory pointed to by *data* is
// valid until *dispatchData* is deallocated (normally when the receiver is
// deallocated).
@interface Lookin_PTData : NSObject
@property (readonly) dispatch_data_t dispatchData;
@property (readonly) void *data;
@property (readonly) size_t length;
@end


// Represents a peer's address
@interface Lookin_PTAddress : NSObject
// For network addresses, this is the IP address in textual format
@property (readonly) NSString *name;
// For network addresses, this is the port number. Otherwise 0 (zero).
@property (readonly) NSInteger port;
@end


// Protocol for Lookin_PTChannel delegates
@protocol Lookin_PTChannelDelegate <NSObject>

@required
// Invoked when a new frame has arrived on a channel.
- (void)ioFrameChannel:(Lookin_PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(Lookin_PTData*)payload;

@optional
// Invoked to accept an incoming frame on a channel. Reply NO ignore the
// incoming frame. If not implemented by the delegate, all frames are accepted.
- (BOOL)ioFrameChannel:(Lookin_PTChannel*)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize;

// Invoked when the channel closed. If it closed because of an error, *error* is
// a non-nil NSError object.
- (void)ioFrameChannel:(Lookin_PTChannel*)channel didEndWithError:(NSError*)error;

// For listening channels, this method is invoked when a new connection has been
// accepted.
- (void)ioFrameChannel:(Lookin_PTChannel*)channel didAcceptConnection:(Lookin_PTChannel*)otherChannel fromAddress:(Lookin_PTAddress*)address;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
