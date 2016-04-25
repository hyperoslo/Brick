/**
  A class protocol that requires configure(item: ViewModel), it can be applied to UI components to annotate that they are intended to use ViewModel.
 */
public protocol ViewConfigurable: class {

  /**
   A configure method that is used on reference types that can be configured using a view model

   - Parameter item: A inout ViewModel so that the ViewConfigurable object can configure the view model width and height based on its UI components
  */
  func configure(inout item: ViewModel)
}
