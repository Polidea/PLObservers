//
//  PLObservers.m
//  PLObservers
//
//  Created by Antoni Kedracki on 07/02/14.
//  Copyright (c) 2014 Antoni Kedracki. All rights reserved.
//

#import "PLObservers.h"
#import <objc/runtime.h>

#pragma mark - PLWeakRef

@interface PLWeakRef : NSObject
@property(nonatomic, weak) id weakReference;
@end

@implementation PLWeakRef {
    __weak id _weakReference;
}

- (instancetype)initWithObject:(id)object {
    self = [super init];
    if (self) { _weakReference = object; } return self;
}

+ (instancetype)weakRefWithObject:(id)object {
    return [[self alloc] initWithObject:object];
}

- (BOOL)isEqual:(PLWeakRef *)object {
    if (![object isKindOfClass:[PLWeakRef class]]) { return NO; }
    return object.weakReference == _weakReference;
}
@end

#pragma mark - PLObservers

@implementation PLObservers {
    NSMutableArray * _observers;
    Protocol * _observerProtocol;
}


- (id)initWithObserverProtocol:(Protocol *)observerProtocol {
    self = [super init];
    if (self) {
        NSAssert(observerProtocol != nil, @"PLObservers must have had been created with a target observer protocol");

        _observerProtocol = observerProtocol;

        _observers = [NSMutableArray array];
    }

    return self;
}

- (void)addObserver:(id <NSObject>)observer {
    [_observers addObject:[PLWeakRef weakRefWithObject:observer]];
}

- (void)removeObserver:(id <NSObject>)observer {
    [_observers removeObject:[PLWeakRef weakRefWithObject:observer]];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector])
        return YES;
    else {
        struct objc_method_description methodDescription = [self methodDescriptionForSelector:aSelector fromProtocol:_observerProtocol];
        return methodDescription.name != NULL;
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    struct objc_method_description desc = [self methodDescriptionForSelector:aSelector fromProtocol:_observerProtocol];

    if(desc.name != NULL){
        return [NSMethodSignature signatureWithObjCTypes:desc.types];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL aSelector = [anInvocation selector];

    NSArray *observersCopy = [_observers copy];
    for(PLWeakRef * observerValue in observersCopy) {
        id<NSObject> observer = [observerValue weakReference];
        if([observer respondsToSelector:aSelector]){
            [anInvocation invokeWithTarget:observer];
        }
    }
}

- (struct objc_method_description)methodDescriptionForSelector:(SEL)aSelector fromProtocol:(Protocol *)protocol {
    struct objc_method_description desc;

    //try to retrieve required method first, or the optional one if not found.
    desc = protocol_getMethodDescription(protocol, aSelector, YES, YES);

    if(desc.name == NULL){
        desc = protocol_getMethodDescription(protocol, aSelector, NO, YES);
    }
    return desc;
}

@end
