#import "ChatUser.h"


@implementation ChatUser

- (void)postMessage:(NSString *)message {
    self.postedMessage = message;
}

- (void)postImageAtURLString:(NSString *)filePath {
    self.postedImageURLString = filePath;
}

- (void)removeMessageWithId:(NSString *)messageId {
    self.removedMessageId = messageId;
}

@end
