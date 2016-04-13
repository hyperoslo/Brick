public protocol KindConvertible {
  var kindString: String { get }
}

extension String: KindConvertible {

  public var kindString: String {
    return self
  }
}
