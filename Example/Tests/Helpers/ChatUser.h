#import <Foundation/Foundation.h>
#import "ChatServiceProtocol.h"

@interface ChatUser : NSObject <ChatServiceProtocol>
@property(nonatomic, copy) NSString *removedMessageId;
@property(nonatomic, copy) NSString *postedImageURLString;
@property(nonatomic, copy) NSString *postedMessage;
@end
