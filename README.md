# Memory Debugger
Easily communicate between iOS devices using BLE.

[![Build Status](https://travis-ci.org/cvladislav/MemoryLeak.svg?branch=main)](https://travis-ci.org/cvladislav/MemoryLeak)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/MemoryLeak.svg)](https://img.shields.io/cocoapods/v/MemoryLeak.svg)

## Features
Easy way to see who release and who retain object

#### Common
- Fast detection who retain and who release object.

## Requirements
- iOS 13.0+
- Xcode 14.0+

## Installation

#### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.38.2 is required to build BluetoothWrapper. It adds support for Xcode 14, Swift 4.0 and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate MemoryLeak into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

pod 'MemoryLeak', '~> 0.2.0'
```

Then, run the following command:

```bash
$ pod install
```

#### Manual
Add the MemoryLeak project to your existing project and add MemoryLeak as an embedded binary of your target(s).

#### Common
Make sure to import the MemoryLeak framework in files that use it.
```swift
import MemoryLeak
```

#### MemoryLeak

Inherite your class from MemoryLeak class
```swift
  class SomeClass: MemoryLeak {

  }
```

Place any breakpoint and use console for watch reatains and releases for your objects by accessing to globalStack variable
```swift
  NSMutableDictionary *globalStack;
}
```

## License
MemoryLeak is released under the MIT License.
