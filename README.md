---

This library is deprecated in favor of [PLXObservers](https://github.com/Polidea/PLXObservers)

---

# PLObservers
<!--
[![CI Status](http://img.shields.io/travis/Antoni Kedracki/PLObservers.svg?style=flat)](https://travis-ci.org/Antoni Kedracki/PLObservers)
-->
[![Version](https://img.shields.io/cocoapods/v/PLObservers.svg?style=flat)](http://cocoadocs.org/docsets/PLObservers)
[![License](https://img.shields.io/cocoapods/l/PLObservers.svg?style=flat)](http://cocoadocs.org/docsets/PLObservers)
[![Platform](https://img.shields.io/cocoapods/p/PLObservers.svg?style=flat)](http://cocoadocs.org/docsets/PLObservers)

Small tool for fast implementation of multi-observer pattern in Objective-C

## Usage
Given you have a observer protocole (basicly the same as a delegate protocole):

```Objective-C
@protocol ObserverProtocol <NSObject>

- (void)somethingDidHappen:(NSString *)message more:(NSInteger)more;

@end
```

Create an instance of PLObservers with your delegate protocol:

```Objective-C
PLObservers <ObserverProtocol> *observers = (PLObservers <ObserverProtocol>*)[[PLObservers alloc] initWithObserverProtocol:@protocol(ObserverProtocol)];
```

Add/remove as many observers (implementing your PLObservers) as you like: 

```Objective-C
[observers addObserver:myObserver1]
[observers removeObserver:myObserver2]
```    

Calling a ObserverProtocol method on the PLObservers instance will be forwarded to the registered observers:

```Objective-C
[observers somethingDidHappen:@"test" more:123] 
```

## Installation

PLObservers is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "PLObservers"

## Author

Antoni Kedracki, akedracki@gmail.com  
Polidea

## License

PLObservers is available under the MIT license. See the LICENSE file for more info.

