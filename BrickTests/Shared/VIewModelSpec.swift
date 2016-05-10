@testable import Brick
import Quick
import Nimble
import Fakery

class ViewModelSpec: QuickSpec {

  override func spec() {
    describe("ViewModel") {
      var viewModel: ViewModel!
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
          viewModel = ViewModel(data)
        }

        it("it creates an instance") {
          expect(viewModel).notTo(beNil())
        }

        it("sets values") {
          expect(viewModel.title).to(equal(data["title"] as? String))
          expect(viewModel.subtitle).to(equal(data["subtitle"] as? String))
          expect(viewModel.image).to(equal(data["image"] as? String))
          expect(viewModel.kind).to(equal(data["kind"] as? String))
          expect(viewModel.action).to(equal(data["action"] as? String))
          expect(viewModel.meta("domain", "")).to(equal(data["meta"]!["domain"]))
        }
      }

      describe("#relations") {
        it("sets relations") {
          data["relations"] = ["viewmodels" : [data, data, data]]
          viewModel = ViewModel(data)

          expect(viewModel.relations["viewmodels"]!.count).to(equal(3))
          expect(viewModel.relations["viewmodels"]!.first!.title).to(equal(data["title"] as? String))
          expect(viewModel.relations["viewmodels"]!.first!.subtitle).to(equal(data["subtitle"] as? String))
          expect(viewModel.relations["viewmodels"]!.first!.image).to(equal(data["image"] as? String))
          expect(viewModel.relations["viewmodels"]!.first!.kind).to(equal(data["kind"] as? String))
          expect(viewModel.relations["viewmodels"]!.first!.action).to(equal(data["action"] as? String))

          expect(viewModel.relations["viewmodels"]!.last!.title).to(equal(data["title"] as? String))
          expect(viewModel.relations["viewmodels"]!.last!.subtitle).to(equal(data["subtitle"] as? String))
          expect(viewModel.relations["viewmodels"]!.last!.image).to(equal(data["image"] as? String))
          expect(viewModel.relations["viewmodels"]!.last!.kind).to(equal(data["kind"] as? String))
          expect(viewModel.relations["viewmodels"]!.last!.action).to(equal(data["action"] as? String))

          let viewModel2 = viewModel
          expect(viewModel == viewModel2).to(beTrue())

          viewModel.relations["viewmodels"]![2].title = "new"
          expect(viewModel == viewModel2).to(beFalse())
        }
      }

      describe("#meta") {
        it("resolves meta data created from JSON") {
          viewModel = ViewModel(data)
          expect(viewModel.meta("domain", "")).to(equal(data["meta"]!["domain"]))
        }

        it("resolves meta data created from object") {
          var data = ["id": 11, "name": "Name"]

          viewModel = ViewModel(meta: Meta(data))
          expect(viewModel.meta("id", 0)).to(equal(data["id"]))
          expect(viewModel.meta("name", "")).to(equal(data["name"]))
        }
      }

      describe("#metaInstance") {
        it("resolves meta data created from object") {
          var data = ["id": 11, "name": "Name"]
          viewModel = ViewModel(meta: Meta(data))
          let result: Meta = viewModel.metaInstance()

          expect(result.id).to(equal(data["id"]))
          expect(result.name).to(equal(data["name"]))
        }
      }

      describe("#dictionary") {
        beforeEach {
          data["relations"] = ["viewmodels" : [data, data]]
          viewModel = ViewModel(data)
        }

        it("returns a dictionary representation of the view model") {
          let newViewModel = ViewModel(viewModel.dictionary)

          expect(newViewModel == viewModel).to(beTrue())
          expect(newViewModel.relations["viewmodels"]!.count).to(equal(viewModel.relations["viewmodels"]!.count))
          expect(newViewModel.relations["viewmodels"]!.first!
            == viewModel.relations["viewmodels"]!.first!).to(beTrue())
          expect(newViewModel.relations["viewmodels"]!.last!
            == viewModel.relations["viewmodels"]!.last!).to(beTrue())
        }
      }

      describe("#update:kind") {
        beforeEach {
          viewModel = ViewModel(data)
        }

        it("updates kind") {
          viewModel.update(kind: "test")
          expect(viewModel.kind).to(equal("test"))
        }
      }

      describe("#compareRelations") {
        beforeEach {
          data["relations"] = ["viewmodels" : [data, data, data]]
          viewModel = ViewModel(data)
        }

        it("compare relations properly") {
          var viewModel2 = ViewModel(data)
          expect(compareRelations(viewModel, viewModel2)).to(beTrue())

          viewModel2.relations["viewmodels"]![2].title = "new"
          expect(compareRelations(viewModel, viewModel2)).to(beFalse())

          data["relations"] = ["viewmodels" : [data, data]]
          viewModel2 = ViewModel(data)
          expect(compareRelations(viewModel, viewModel2)).to(beFalse())
        }
      }
    }
  }
}
