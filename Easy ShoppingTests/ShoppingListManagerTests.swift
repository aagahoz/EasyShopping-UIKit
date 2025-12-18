//
//  ShoppingListManagerTests.swift
//  Easy ShoppingTests
//
//  Created by Agah Ozdemir on 18.12.2025.
//

import XCTest
@testable import Easy_Shopping

final class ShoppingListManagerTests: XCTestCase {

    private var manager: ShoppingListManager!

    override func setUp() {
        super.setUp()
        manager = ShoppingListManager()
    }

    override func tearDown() {
        manager = nil
        super.tearDown()
    }

    func test_createList_addsNewListToManager() {
        // Act
        let list = manager.createList(title: "Haftalık Alışveriş")

        // Assert
        XCTAssertEqual(manager.lists.count, 1)
        XCTAssertEqual(manager.lists.first, list)
    }

    func test_addItem_addsItemToGivenList() {
        // Arrange
        let list = manager.createList(title: "Market")

        // Act
        let item = manager.addItem(
            to: list,
            name: "Süt",
            quantity: "1 Litre"
        )

        // Assert
        let items = manager.items(for: list)
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first, item)
    }

    func test_items_areKeptSeparateBetweenDifferentLists() {
        // Arrange
        let list1 = manager.createList(title: "Market")
        let list2 = manager.createList(title: "Eczane")

        // Act
        manager.addItem(to: list1, name: "Süt", quantity: "1")
        manager.addItem(to: list2, name: "Vitamin", quantity: "2")

        // Assert
        XCTAssertEqual(manager.items(for: list1).count, 1)
        XCTAssertEqual(manager.items(for: list2).count, 1)
    }
}
