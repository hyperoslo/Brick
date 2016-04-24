#if os(iOS) || os(watchOS) || os(tvOS)
  import UIKit
#else
  import Foundation
#endif

import Tailor
import Sugar

public struct ViewModel: Mappable {
  public var index = 0
  public var title = ""
  public var subtitle = ""
  public var image = ""
  public var kind: String = ""
  public var action: String?
  public var size = CGSize(width: 0, height: 0)
  public var meta = [String : AnyObject]()
  public var relations = [String : [ViewModel]]()

  // MARK: - Initialization

  /**
   Initialization a new instance of a ViewModel and map it to a JSON dictionary

   - Parameter map: A JSON dictionary
  */
  public init(_ map: JSONDictionary) {
    title    <- map.property("title")
    subtitle <- map.property("subtitle")
    image    <- map.property("image")
    kind     <- map.property("type") ?? map.property("kind")
    action   <- map.property("action")
    meta     <- map.property("meta")

    if let relation = map["relations"] as? [String : [ViewModel]] {
      relations = relation
    }

    if let relations = map["relations"] as? [String : [JSONDictionary]] {
      var newRelations = [String : [ViewModel]]()
      relations.forEach { key, array in
        if newRelations[key] == nil { newRelations[key] = [ViewModel]() }
        array.forEach { newRelations[key]?.append(ViewModel($0)) }

        self.relations = newRelations
      }
    }

    size = CGSize(
      width:  ((map["size"] as? JSONDictionary)?["width"] as? Int) ?? 0,
      height: ((map["size"] as? JSONDictionary)?["height"] as? Int) ?? 0
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
 ViewModel Equatable implemetnation
 */
public func ==(lhs: ViewModel, rhs: ViewModel) -> Bool {
  let equal = lhs.title == rhs.title &&
    lhs.subtitle == rhs.subtitle &&
    lhs.image == rhs.image &&
    lhs.kind == rhs.kind &&
    lhs.action == rhs.action &&
    (lhs.meta as NSDictionary).isEqual(rhs.meta as NSDictionary)

  return equal
}

/**
 Check if ViewModel's are truly equal by including size in comparison
 */
public func ===(lhs: ViewModel, rhs: ViewModel) -> Bool {
  let equal = lhs.title == rhs.title &&
    lhs.subtitle == rhs.subtitle &&
    lhs.image == rhs.image &&
    lhs.kind == rhs.kind &&
    lhs.action == rhs.action &&
    lhs.size == rhs.size &&
    (lhs.meta as NSDictionary).isEqual(rhs.meta as NSDictionary)

  return equal
}

/**
 A reverse Equatable implemetnation for comparing ViewModel's
 */
public func !=(lhs: ViewModel, rhs: ViewModel) -> Bool {
  return !(lhs == rhs)
}
