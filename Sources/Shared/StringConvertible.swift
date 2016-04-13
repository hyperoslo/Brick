public protocol StringConvertible {
  var string: String { get }
}

extension String: StringConvertible {
  
  public var string: String {
    return self
  }
}