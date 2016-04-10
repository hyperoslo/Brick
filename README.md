# Brick

[![CI Status](http://img.shields.io/travis/hyperoslo/Brick.svg?style=flat)](https://travis-ci.org/hyperoslo/Brick)
[![Version](https://img.shields.io/cocoapods/v/Brick.svg?style=flat)](http://cocoadocs.org/docsets/Brick)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Brick.svg?style=flat)](http://cocoadocs.org/docsets/Brick)
[![Platform](https://img.shields.io/cocoapods/p/Brick.svg?style=flat)](http://cocoadocs.org/docsets/Brick)

## Description

<img src="https://raw.githubusercontent.com/hyperoslo/Brick/master/Images/icon_v2.png" alt="Brick Icon" align="right" />

Brick is a generic view model for both basic and complex scenarios.
Mapping a basic table view cells is as easy as pie, if you have more properties, you can use the `meta` dictionary to add all additional properties that you might need. It also supports relations so that you can nest view models inside of view models.

```swift
public struct ViewModel: Mappable {
  public var index = 0
  public var title = ""
  public var subtitle = ""
  public var image = ""
  public var kind = ""
  public var action: String?
  public var size = CGSize(width: 0, height: 0)
  public var meta = [String : AnyObject]()
}
```

- **.index**
Calculated value to determine the index it has inside of the component.
- **.title**
The headline for your data, in a `UITableViewCell` it is normally used for `textLabel.text` but you are free to use it as you like.
- **.subtitle**
Same as for the title, in a `UITableViewCell` it is normally used for `detailTextLabel.text`.
- **.image**
Can be either a URL string or a local string, you can easily determine if it should use a local or remote asset in your view.
- **.kind**
Is used for the `reuseIdentifier` of your `UITableViewCell` or `UICollectionViewCell`.
- **.action**
Action identifier for you to parse and process when a user taps on a list item. We recommend [Compass](https://github.com/hyperoslo/Compass) as centralized navigation system.
- **.size**
Can either inherit from the `UITableViewCell`/`UICollectionViewCell`, or be manually set by the height calculations inside of your view.
- **.meta**
This is used for extra data that you might need access to inside of your view, it can be a hex color, a unique identifer or additional images for your view.

## Usage

```swift
let item = ViewModel(
  title: "John Hyperseed",
  subtitle: "Build machine",
  meta: [
    "operatingSystem" : "OS X",
    "xcodeVersion" : 7.3
])

print(item.meta("operatingSystem", "")) // prints "OS X"
print(item.meta("xcodeVersion", 0.0)) // prints 7.3

```

## Installation

**Brick** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Brick'
```

**Brick** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "hyperoslo/Brick"
```

## Author

Hyper Interaktiv AS, ios@hyper.no

## Contributing

We would love you to contribute to **Brick**, check the [CONTRIBUTING](https://github.com/hyperoslo/Brick/blob/master/CONTRIBUTING.md) file for more info.

## License

**Brick** is available under the MIT license. See the [LICENSE](https://github.com/hyperoslo/Brick/blob/master/LICENSE.md) file for more info.
