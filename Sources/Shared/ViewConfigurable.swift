public protocol ViewConfigurable: class {

  /**
   A configure method that is used on reference types that can be configured using a view model

   - Parameter item: A inout ViewModel so that the ViewConfigurable object can configure the view model width and height based on its UI components
  */
  func configure(inout item: ViewModel)
}
