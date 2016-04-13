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
        }
      }

      describe("#meta") {
        beforeEach {
          viewModel = ViewModel(data)
        }

        it("resolves meta data") {
          expect(viewModel.meta("domain", "")).to(equal(data["meta"]!["domain"]))
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
    }
  }
}
