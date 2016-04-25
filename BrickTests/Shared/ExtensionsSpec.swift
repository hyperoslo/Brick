@testable import Brick
import Quick
import Nimble
import Fakery

class ExtensionsSpec: QuickSpec {

  override func spec() {
    describe("Array+Brick") {
      var items =  [ViewModel]()

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
  }
}
