// MARK: - Array

public extension _ArrayType where Generator.Element == ViewModel {

  mutating func refreshIndexes() {
    enumerate().forEach {
      self[$0.index].index = $0.index
    }
  }
}

// MARK: - Dictionary

extension Dictionary where Key: StringLiteralConvertible {

  func property<T>(name: ViewModel.Key) -> T? {
    return property(name.string)
  }

  subscript(key: ViewModel.Key) -> Value? {
    set(value) {
      guard let key = key.string as? Key else { return }
      self[key] = value
    }
    get {
      guard let key = key.string as? Key else { return nil }
      return self[key]
    }
  }
}
