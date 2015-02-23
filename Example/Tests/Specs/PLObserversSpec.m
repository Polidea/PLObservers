#import <PLObservers/PLObservers.h>
#import "ChatUser.h"

SPEC_BEGIN(PLObserversSpec)

describe(@"PLObservers", ^{
    __block PLObservers <ChatServiceProtocol> *chatService;
    __block ChatUser *powerUser;
    __block NSString *filePath;

    beforeEach(^{
        chatService = (PLObservers <ChatServiceProtocol>*)[[PLObservers alloc] initWithObserverProtocol:@protocol(ChatServiceProtocol)];
        powerUser = [ChatUser new];
        filePath = @"http://www.test.com/image.png";
    });

    describe(@"sending message defined in protocol", ^{
        context(@"when there are multiple observers", ^{
            __block ChatUser *anonymousUser;

            beforeEach(^{
                [chatService addObserver:powerUser];

                anonymousUser = [ChatUser new];
                [chatService addObserver:anonymousUser];
            });

            afterEach(^{
                [chatService removeObserver:powerUser];
                [chatService removeObserver:anonymousUser];
            });

            it(@"should forward this message to all observers", ^{
                [chatService postImageAtURLString:filePath];

                [[[powerUser postedImageURLString] should] equal:filePath];
                [[[anonymousUser postedImageURLString] should] equal:filePath];
            });
        });

        context(@"when there is one observer", ^{
            beforeEach(^{
                [chatService addObserver:powerUser];
            });

            afterEach(^{
                [chatService removeObserver:powerUser];
            });

            it(@"should forward this message to the observer", ^{
                [chatService postImageAtURLString:filePath];

                [[[powerUser postedImageURLString] should] equal:filePath];
            });
        });

        context(@"when there are no observers", ^{
            it(@"should not throw any exceptions", ^{
                BOOL exceptionThrown = NO;
                @try {
                    [chatService postImageAtURLString:filePath];
                } @catch(NSException *exception) {
                    exceptionThrown = YES;
                }

                [[theValue(exceptionThrown) should] beFalse];
            });
        });

        context(@"when observer is removed", ^{
            beforeEach(^{
                [chatService addObserver:powerUser];
                [chatService removeObserver:powerUser];
            });

            it(@"should not forward this message to the observer", ^{
                [chatService postImageAtURLString:filePath];
                
                [[[powerUser postedImageURLString] should] beNil];
            });
        });
    });

    describe(@"sending message not defined in protocol", ^{
        it(@"should cause an exception to be thrown", ^{
            BOOL exceptionThrown = NO;
            @try {
                [chatService performSelector:@selector(postImage:) withObject:filePath];

            } @catch(NSException *exception) {
                exceptionThrown = YES;
            }
            
            [[theValue(exceptionThrown) should] beTrue];
        });
    });

    describe(@"removing observer object from observers", ^{
        it(@"should remove correct weak reference from array of observers", ^{
            ChatUser *firstUser = [ChatUser new];
            ChatUser *secondUser = [ChatUser new];
            ChatUser *thirdUser = [ChatUser new];
            [chatService addObserver:firstUser];
            [chatService addObserver:secondUser];
            [chatService addObserver:thirdUser];

            [chatService removeObserver:secondUser];

            [chatService postImageAtURLString:filePath];

            [[[firstUser postedImageURLString] should] equal:filePath];
            [[[secondUser postedImageURLString] should] beNil];
            [[[thirdUser postedImageURLString] should] equal:filePath];
        });
    });
});

SPEC_END
