@testable import Brick
import Quick
import Nimble
import Fakery

class ExtensionsSpec: QuickSpec {

  override func spec() {
    describe("Array+Brick") {
      var items = [ViewModel]()

      beforeEach {
        for index in 0..<10 {
          var item = ViewModel(title: "Test")
          item.index = 9 - index

          items.append(item)
        }
      }

      describe("#refreshIndexes") {
        it("sets proper indexes") {
          for index in 0..<10 {
            expect(items[index].index).to(equal(9 - index))
          }

          items.refreshIndexes()

          for index in 0..<10 {
            expect(items[index].index).to(equal(index))
          }
        }
      }
    }

    describe("Dictionary+Brick") {
      var items = [String: String]()

      beforeEach {
        items = ["title": "test"]
      }

      describe("#subscript") {
        it("sets a proper value based on a string representation of a view model Key") {
          items[.Subtitle] = "subtitle"
          expect(items["subtitle"]).to(equal("subtitle"))
        }

        it("returns a proper value based on a string representation of a view model Key") {
          expect(items[.Title]).to(equal("test"))
        }
      }
    }
  }
}
