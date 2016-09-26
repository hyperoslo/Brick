@testable import Brick
import Quick
import Nimble
import Fakery

class ItemSpec: QuickSpec {

  override func spec() {
    describe("Item") {
      var Item: Item!
      var data: [String : AnyObject]!
      let faker = Faker()

      beforeEach {
        data = [
          "title": faker.lorem.paragraph(),
          "subtitle": faker.lorem.paragraph(),
          "image" : faker.internet.image(),
          "kind" : faker.team.name(),
          "action" : faker.internet.ipV6Address(),
          "meta" : [
            "domain" : faker.internet.domainName()
          ]
        ]
      }

      describe("#mapping") {
        beforeEach {
          Item = Item(data)
        }

        it("it creates an instance") {
          expect(Item).notTo(beNil())
        }

        it("sets values") {
          expect(Item.title).to(equal(data["title"] as? String))
          expect(Item.subtitle).to(equal(data["subtitle"] as? String))
          expect(Item.image).to(equal(data["image"] as? String))
          expect(Item.kind).to(equal(data["kind"] as? String))
          expect(Item.action).to(equal(data["action"] as? String))
          expect(Item.meta("domain", "")).to(equal(data["meta"]!["domain"]))
        }
      }

      describe("#relations") {
        it("sets relations") {
          data["relations"] = ["Items" : [data, data, data]]
          Item = Item(data)

          expect(Item.relations["Items"]!.count).to(equal(3))
          expect(Item.relations["Items"]!.first!.title).to(equal(data["title"] as? String))
          expect(Item.relations["Items"]!.first!.subtitle).to(equal(data["subtitle"] as? String))
          expect(Item.relations["Items"]!.first!.image).to(equal(data["image"] as? String))
          expect(Item.relations["Items"]!.first!.kind).to(equal(data["kind"] as? String))
          expect(Item.relations["Items"]!.first!.action).to(equal(data["action"] as? String))

          expect(Item.relations["Items"]!.last!.title).to(equal(data["title"] as? String))
          expect(Item.relations["Items"]!.last!.subtitle).to(equal(data["subtitle"] as? String))
          expect(Item.relations["Items"]!.last!.image).to(equal(data["image"] as? String))
          expect(Item.relations["Items"]!.last!.kind).to(equal(data["kind"] as? String))
          expect(Item.relations["Items"]!.last!.action).to(equal(data["action"] as? String))

          let Item2 = Item
          expect(Item == Item2).to(beTrue())

          Item.relations["Items"]![2].title = "new"
          expect(Item == Item2).to(beFalse())
        }
      }

      describe("#meta") {
        it("resolves meta data created from JSON") {
          Item = Item(data)
          expect(Item.meta("domain", "")).to(equal(data["meta"]!["domain"]))
        }

        it("resolves meta data created from object") {
          var data = ["id": 11, "name": "Name"]

          Item = Item(meta: Meta(data))
          expect(Item.meta("id", 0)).to(equal(data["id"]))
          expect(Item.meta("name", "")).to(equal(data["name"]))
        }
      }

      describe("#metaInstance") {
        it("resolves meta data created from object") {
          var data = ["id": 11, "name": "Name"]
          Item = Item(meta: Meta(data))
          let result: Meta = Item.metaInstance()

          expect(result.id).to(equal(data["id"]))
          expect(result.name).to(equal(data["name"]))
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
          Item = Item(data)
        }

        it("returns a dictionary representation of the view model") {
          let newItem = Item(Item.dictionary)

          expect(newItem == Item).to(beTrue())
          expect(newItem.relations["Items"]!.count).to(equal(Item.relations["Items"]!.count))
          expect(newItem.relations["Items"]!.first!
            == Item.relations["Items"]!.first!).to(beTrue())
          expect(newItem.relations["Items"]!.last!
            == Item.relations["Items"]!.last!).to(beTrue())
        }
      }

      describe("#update:kind") {
        beforeEach {
          Item = Item(data)
        }

        it("updates kind") {
          Item.update(kind: "test")
          expect(Item.kind).to(equal("test"))
        }
      }

      describe("#compareRelations") {
        beforeEach {
          data["relations"] = ["Items" : [data, data, data]]
          Item = Item(data)
        }

        it("compare relations properly") {
          var Item2 = Item(data)
          expect(compareRelations(Item, Item2)).to(beTrue())

          Item2.relations["Items"]![2].title = "new"
          expect(compareRelations(Item, Item2)).to(beFalse())

          data["relations"] = ["Items" : [data, data]]
          Item2 = Item(data)
          expect(compareRelations(Item, Item2)).to(beFalse())
        }
      }
    }
  }
}
