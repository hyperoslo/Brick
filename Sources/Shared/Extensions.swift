import UIKit

extension UIView: KindConvertible {

  public var kindString: String {
    return String(reflecting: self.dynamicType)
  }
}

