#import <Foundation/Foundation.h>

@protocol ChatServiceProtocol <NSObject>
- (void)postMessage:(NSString *)message;
- (void)postImageAtURLString:(NSString *)filePath;
- (void)removeMessageWithId:(NSString *)messageId;
@end
