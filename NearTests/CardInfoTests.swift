import XCTest
@testable import Near

final class CardInfoTests: XCTestCase {
    func testGetCardDataReturnsThreeItemsForEachTab() {
        for tab in Tab.allCases {
            let data = getCardData(for: tab)
            XCTAssertEqual(data.count, 3, "Tab \(tab) should have 3 items")
        }
    }

    func testFirstFoodItemMatchesExpected() {
        let items = getCardData(for: .food)
        guard let first = items.first else {
            XCTFail("Expected at least one item")
            return
        }
        XCTAssertEqual(first.title, "Pizza Bar La Strada")
        XCTAssertEqual(first.category, "Restaurant")
    }
}
