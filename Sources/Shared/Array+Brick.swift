public extension _ArrayType where Generator.Element == ViewModel {

  mutating func refreshIndexes() {
    enumerate().forEach {
      self[$0.index].index = $0.index
    }
  }
}
