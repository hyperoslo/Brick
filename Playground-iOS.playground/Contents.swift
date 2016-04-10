// Brick iOS Playground

import UIKit
import Brick

let item = ViewModel(
  title: "John Hyperseed",
  subtitle: "Build machine",
  meta: [
    "operatingSystem" : "OS X",
    "xcodeVersion" : 7.3
  ])

item.meta("operatingSystem", "") // prints "OS X"
item.meta("xcodeVersion", 0.0) // prints 7.3
