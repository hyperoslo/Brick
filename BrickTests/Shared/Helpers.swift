import Tailor
import Sugar

struct Meta: Mappable {
  var id = 0
  var name: String? = ""

  init(_ map: JSONDictionary) {
    id <- map.property("id")
    name <- map.property("name")
  }
}
