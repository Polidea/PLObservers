//
//  PLObservers.h
//  PLObservers
//
//  Created by Antoni Kedracki on 07/02/14.
//  Copyright (c) 2014 Antoni Kedracki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLObservers : NSObject

- (id)initWithObserverProtocol:(Protocol *)observerProtocol;

- (void)addObserver:(id<NSObject>)observer;
- (void)removeObserver:(id<NSObject>)observer;

@end
