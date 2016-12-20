@testable import Brick
import Quick
import Nimble
import Fakery

class ItemSpec: QuickSpec {

  override func spec() {
    describe("Item") {
      var item: Item!
      var data: [String : Any]!
      let faker = Faker()

      beforeEach {
        data = [
          "title": faker.lorem.paragraph(),
          "subtitle": faker.lorem.paragraph(),
          "text": faker.lorem.paragraph(),
          "image" : faker.internet.image(),
          "kind" : faker.team.name(),
          "size" : ["width" : 320.0, "height" : 240.0],
          "action" : faker.internet.ipV6Address(),
          "children" : [
            "child 1" : "Anna",
            "child 2" : "Elsa"
          ],
          "meta" : [
            "domain" : faker.internet.domainName()
          ]
        ]
      }

      describe("#mapping") {
        beforeEach {
          item = Item(data)
        }

        it("it creates an instance") {
          expect(item).notTo(beNil())
        }

        it("sets values") {
          expect(item.title).to(equal(data["title"] as? String))
          expect(item.subtitle).to(equal(data["subtitle"] as? String))
          expect(item.text).to(equal(data["text"] as? String))
          expect(item.image).to(equal(data["image"] as? String))
          expect(item.kind).to(equal(data["kind"] as? String))
          expect(item.action).to(equal(data["action"] as? String))
          expect(item.size.width).to(equal(CGFloat(320.0)))
          expect(item.size.height).to(equal(CGFloat(240.0)))
          expect(item.meta("domain", "")).to(equal(((data["meta"] as! [String : AnyObject])["domain"] as? String)))
        }
      }

      describe("#relations") {
        it("sets relations") {
          data["relations"] = ["Items" : [data, data, data]]
          item = Item(data)

          expect(item.relations["Items"]!.count).to(equal(3))
          expect(item.relations["Items"]!.first!.title).to(equal(data["title"] as? String))
          expect(item.relations["Items"]!.first!.subtitle).to(equal(data["subtitle"] as? String))
          expect(item.relations["Items"]!.first!.image).to(equal(data["image"] as? String))
          expect(item.relations["Items"]!.first!.kind).to(equal(data["kind"] as? String))
          expect(item.relations["Items"]!.first!.action).to(equal(data["action"] as? String))

          expect(item.relations["Items"]!.last!.title).to(equal(data["title"] as? String))
          expect(item.relations["Items"]!.last!.subtitle).to(equal(data["subtitle"] as? String))
          expect(item.relations["Items"]!.last!.image).to(equal(data["image"] as? String))
          expect(item.relations["Items"]!.last!.kind).to(equal(data["kind"] as? String))
          expect(item.relations["Items"]!.last!.action).to(equal(data["action"] as? String))

          let item2 = item
          expect(item == item2!).to(beTrue())

          item.relations["Items"]![2].title = "new"
          expect(item == item2!).to(beFalse())
        }
      }

      describe("#meta") {
        it("resolves meta data created from JSON") {
          item = Item(data)
          expect(item.meta("domain", "")).to(equal((data["meta"] as! [String : AnyObject])["domain"] as? String))
        }

        it("resolves meta data created from object") {
          var data: [String : Any] = ["id": 11, "name": "Name"]

          item = Item(meta: Meta(data))
          expect(item.meta("id", 0)).to(equal(data["id"] as? Int))
          expect(item.meta("name", "")).to(equal(data["name"] as? String))
        }
      }

      describe("#metaInstance") {
        it("resolves meta data created from object") {
          var data: [String : Any] = ["id": 11, "name": "Name"]
          item = Item(meta: Meta(data))
          let result: Meta = item.metaInstance()

          expect(result.id).to(equal(data["id"] as? Int))
          expect(result.name).to(equal(data["name"] as? String))
        }
      }

      describe("#equality") {
        it("compares two view models that are equal using identifier") {
          let left = Item(identifier: "foo".hashValue)
          let right = Item(identifier: "foo".hashValue)

          expect(left === right).to(beTrue())
        }

        it("compares two view models that are not equal using identifier") {
          let left = Item(identifier: "foo".hashValue)
          let right = Item(identifier: "bar".hashValue)

          expect(left === right).to(beFalse())
        }

        it("compares two view models that are equal") {
          let left = Item(title: "foo", size: CGSize(width: 40, height: 40))
          let right = Item(title: "foo", size: CGSize(width: 40, height: 40))

          expect(left === right).to(beTrue())
        }

        it("compares two unequal view model") {
          let left = Item(title: "foo", size: CGSize(width: 40, height: 40))
          let right = Item(title: "foo", size: CGSize(width: 60, height: 60))

          expect(left === right).to(beFalse())
        }

        it("compares a collection of view models that are equal") {
          let left = [
            Item(title: "foo", size: CGSize(width: 40, height: 40)),
            Item(title: "foo", size: CGSize(width: 40, height: 40))
          ]
          let right = [
            Item(title: "foo", size: CGSize(width: 40, height: 40)),
            Item(title: "foo", size: CGSize(width: 40, height: 40))
          ]

          expect(left === right).to(beTrue())
        }

        it("compares a collection of view models that are not equal") {
          let left = [
            Item(title: "foo", size: CGSize(width: 40, height: 40)),
            Item(title: "foo", size: CGSize(width: 60, height: 40))
          ]
          let right = [
            Item(title: "foo", size: CGSize(width: 40, height: 40)),
            Item(title: "foo", size: CGSize(width: 40, height: 40))
          ]

          expect(left === right).to(beFalse())
        }
      }

      describe("#dictionary") {
        beforeEach {
          data["relations"] = ["Items" : [data, data]]
          item = Item(data)
        }

        it("returns a dictionary representation of the view model") {
          let newItem = Item(item.dictionary)

          expect(newItem == item).to(beTrue())
          expect(newItem.relations["Items"]!.count).to(equal(item.relations["Items"]!.count))
          expect(newItem.relations["Items"]!.first!
            == item.relations["Items"]!.first!).to(beTrue())
          expect(newItem.relations["Items"]!.last!
            == item.relations["Items"]!.last!).to(beTrue())
        }
      }

      describe("#update:kind") {
        beforeEach {
          item = Item(data)
        }

        it("updates kind") {
          item.update(kind: "test")
          expect(item.kind).to(equal("test"))
        }
      }

      describe("#compareChildren") {
        beforeEach {
          item = Item(data)
        }

        it("compare children properly") {
          let sameItem = Item(data)

          var newData: [String : Any] = data!
          newData["children"] = [["child 1" : "Anna"]]
          let otherItem = Item(newData)

          expect(item === sameItem).to(beTrue())
          expect(item === otherItem).to(beFalse())
        }
      }

      describe("#compareRelations") {
        beforeEach {
          data["relations"] = ["Items" : [data, data, data]]
          item = Item(data)
        }

        it("compare relations properly") {
          var Item2 = Item(data)
          expect(compareRelations(item, Item2)).to(beTrue())

          Item2.relations["Items"]![2].title = "new"
          expect(compareRelations(item, Item2)).to(beFalse())

          data["relations"] = ["Items" : [data, data]]
          Item2 = Item(data)
          expect(compareRelations(item, Item2)).to(beFalse())
        }
      }
    }
  }
}
