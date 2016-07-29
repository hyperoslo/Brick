#if os(iOS) || os(watchOS) || os(tvOS)
  import UIKit
#else
  import Foundation
#endif

import Tailor
import Sugar

/**
 A value type struct, it conforms to the Mappable protocol so that it can be instantiated with JSON
*/
public struct ViewModel: Mappable {

  /**
   An enum with all the string keys used in the view model
  */
  public enum Key: String {
    case Index
    case Title
    case Subtitle
    case Image
    case Type
    case Kind
    case Action
    case Meta
    case Relations
    case Size
    case Width
    case Height

    var string: String {
      return rawValue.lowercaseString
    }
  }

  /// The index of the ViewModel when appearing in a list, should be computed and continuously updated by the data source
  public var index = 0
  /// The main representation of the ViewModel
  public var title = ""
  /// Supplementary information to the ViewModel
  public var subtitle = ""
  /// A visual representation of the ViewModel, usually a string URL or image name
  public var image = ""
  /// Determines what kind of UI should be used to represent the ViewModel
  public var kind: String = ""
  /// A string representation of what should happens when a ViewModel is tapped, usually a URN or URL
  public var action: String?
  /// The width and height of the view model, usually calculated and updated by the UI component
  public var size = CGSize(width: 0, height: 0)
  /// A key-value dictionary for any additional information
  public var meta = [String : AnyObject]()
  /// A key-value dictionary for related view models
  public var relations = [String : [ViewModel]]()

  /// A dictionary representation of the view model
  public var dictionary: JSONDictionary {
    var dictionary: [String: AnyObject] = [
      Key.Index.string : index,
      Key.Title.string : title,
      Key.Subtitle.string : subtitle,
      Key.Image.string : image,
      Key.Kind.string : kind,
      Key.Meta.string : meta,
      Key.Size.string : [
        Key.Width.string : size.width,
        Key.Height.string : size.height
      ]
    ]

    if let action = action {
      dictionary[Key.Action.string] = action
    }

    var relationItems = [String : [JSONDictionary]]()

    relations.forEach { key, array in
      if relationItems[key] == nil { relationItems[key] = [JSONDictionary]() }
      array.forEach { relationItems[key]?.append($0.dictionary) }
    }

    dictionary[Key.Relations.string] = relationItems

    return dictionary
  }

  // MARK: - Initialization

  /**
   Initialization a new instance of a ViewModel and map it to a JSON dictionary

   - Parameter map: A JSON dictionary
  */
  public init(_ map: JSONDictionary) {
    index    <- map.property(.Index)
    title    <- map.property(.Title)
    subtitle <- map.property(.Subtitle)
    image    <- map.property(.Image)
    kind     <- map.property(.Type) ?? map.property(.Kind)
    action   <- map.property(.Action) ?? nil
    meta     <- map.property(.Meta)

    if let relation = map[.Relations] as? [String : [ViewModel]] {
      relations = relation
    }

    if let relations = map[.Relations] as? [String : [JSONDictionary]] {
      var newRelations = [String : [ViewModel]]()
      relations.forEach { key, array in
        if newRelations[key] == nil { newRelations[key] = [ViewModel]() }
        array.forEach { newRelations[key]?.append(ViewModel($0)) }

        self.relations = newRelations
      }
    }

    size = CGSize(
      width:  ((map[.Size] as? JSONDictionary)?[.Width] as? Int) ?? 0,
      height: ((map[.Size] as? JSONDictionary)?[.Height] as? Int) ?? 0
    )
  }

  /**
   Initialization a new instance of a ViewModel and map it to a JSON dictionary

   - Parameter title: The title string for the view model, defaults to empty string
   - Parameter subtitle: The subtitle string for the view model, default to empty string
   - Parameter image: Image name or URL as a string, default to empty string
   */
  public init(title: String = "", subtitle: String = "", image: String = "", kind: StringConvertible = "", action: String? = nil, size: CGSize = CGSize(width: 0, height: 0), meta: JSONDictionary = [:], relations: [String : [ViewModel]] = [:]) {
    self.title = title
    self.subtitle = subtitle
    self.image = image
    self.kind = kind.string
    self.action = action
    self.size = size
    self.meta = meta
    self.relations = relations
  }

  /**
   Initialization a new instance of a ViewModel and map it to a JSON dictionary

   - Parameter title: The title string for the view model, defaults to empty string
   - Parameter subtitle: The subtitle string for the view model, default to empty string
   - Parameter image: Image name or URL as a string, default to empty string
   */
  public init(title: String = "", subtitle: String = "", image: String = "", kind: StringConvertible = "", action: String? = nil, size: CGSize = CGSize(width: 0, height: 0), meta: Mappable, relations: [String : [ViewModel]] = [:]) {
    self.init(title: title, subtitle: subtitle, image: image, kind: kind, action: action,
              size: size, meta: meta.metaProperties, relations: relations)
  }

  // MARK: - Helpers

  /**
   A generic convenience method for resolving meta attributes

   - Parameter key: String
   - Parameter defaultValue: A generic value that works as a fallback if the key value object cannot be cast into the generic type
   - Returns: A generic value based on `defaultValue`, it falls back to `defaultValue` if type casting fails
  */
  public func meta<T>(key: String, _ defaultValue: T) -> T {
    return meta[key] as? T ?? defaultValue
  }

  /**
   A generic convenience method for resolving meta attributes

   - Parameter key: String
   - Parameter type: A generic type used for casting the meta property to a specific value or reference type
   - Returns: An optional generic value based on `type`
   */
  public func meta<T>(key: String, type: T.Type) -> T? {
    return meta[key] as? T
  }

  /**
   A generic convenience method for resolving meta instance

   - Returns: A generic meta instance based on `type`
   */
  public func metaInstance<T: Mappable>() -> T {
    return T(meta)
  }

  /**
   A convenience lookup method for resolving view model relations

   - Parameter key: String
   - Parameter index: The index of the object inside of `self.relations`
   */
  public func relation(key: String, _ index: Int) -> ViewModel? {
    if let items = relations[key] where index < items.count {
      return items[index]
    } else {
      return nil
    }
  }

  /**
   A method for mutating the kind of a view model

   - Parameter kind: A StringConvertible object
   */
  public mutating func update(kind kind: StringConvertible) {
    self.kind = kind.string
  }
}

/**
 A collection of ViewModel Equatable implementation
 - Parameter lhs: Left hand collection of ViewModels
 - Parameter rhs: Right hand collection of ViewModels
 - Returns: A boolean value, true if both ViewModel are equal
 */
public func ==(lhs: [ViewModel], rhs: [ViewModel]) -> Bool {
  var equal = lhs.count == rhs.count

  if !equal { return false }

  for (index, item) in lhs.enumerate() {
    if item != rhs[index] { equal = false; break }
  }

  return equal
}

/**
 A collection of ViewModel Equatable implementation to see if they are truly equal
 - Parameter lhs: Left hand collection of ViewModels
 - Parameter rhs: Right hand collection of ViewModels
 - Returns: A boolean value, true if both ViewModel are equal
 */
public func ===(lhs: [ViewModel], rhs: [ViewModel]) -> Bool {
  var equal = lhs.count == rhs.count

  if !equal { return false }

  for (index, item) in lhs.enumerate() {
    if !(item === rhs[index]) { equal = false; break }
  }

  return equal
}

/**
 ViewModel Equatable implementation
 - Parameter lhs: Left hand ViewModel
 - Parameter rhs: Right hand ViewModel
 - Returns: A boolean value, true if both ViewModel are equal
 */
public func ==(lhs: ViewModel, rhs: ViewModel) -> Bool {
  return lhs.title == rhs.title &&
    lhs.subtitle == rhs.subtitle &&
    lhs.image == rhs.image &&
    lhs.kind == rhs.kind &&
    lhs.action == rhs.action &&
    (lhs.meta as NSDictionary).isEqual(rhs.meta as NSDictionary) &&
    compareRelations(lhs, rhs)
}

/**
 Check if ViewModel's are truly equal by including size in comparison

 - Parameter lhs: Left hand ViewModel
 - Parameter rhs: Right hand ViewModel
 - Returns: A boolean value, true if both ViewModel are equal
 */
public func ===(lhs: ViewModel, rhs: ViewModel) -> Bool {
  let equal = lhs.title == rhs.title &&
    lhs.subtitle == rhs.subtitle &&
    lhs.image == rhs.image &&
    lhs.kind == rhs.kind &&
    lhs.action == rhs.action &&
    lhs.size == rhs.size &&
    (lhs.meta as NSDictionary).isEqual(rhs.meta as NSDictionary) &&
    compareRelations(lhs, rhs)

  return equal
}

/**
 A reverse Equatable implementation for comparing ViewModel's
 - Parameter lhs: Left hand ViewModel
 - Parameter rhs: Right hand ViewModel
 - Returns: A boolean value, false if both ViewModel are equal
 */
public func !=(lhs: ViewModel, rhs: ViewModel) -> Bool {
  return !(lhs == rhs)
}

func compareRelations(lhs: ViewModel, _ rhs: ViewModel) -> Bool {
  guard lhs.relations.count == rhs.relations.count else {
    return false
  }

  var equal = true

  for (key, value) in lhs.relations {
    guard let rightValue = rhs.relations[key] where value == rightValue
      else { equal = false; break }
  }

  return equal
}
