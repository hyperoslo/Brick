import Tailor
import Sugar

struct Meta {
  var id = 0
  var name: String?
}

extension Meta: Mappable {

  init(_ map: JSONDictionary) {
    id <- map.property("id")
    name <- map.property("name")
  }
}
