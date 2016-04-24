/**
 A protocol for returning a string representation of self
 */
public protocol StringConvertible {
  var string: String { get }
}

/**
  A protocol extension on String to make it conform to StringConvertible
 */
extension String: StringConvertible {

  /**
   - Returns: self as string
  */
  public var string: String {
    return self
  }
}
