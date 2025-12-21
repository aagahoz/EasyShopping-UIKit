//
//  InMemoryShoppingListRepositoryTests.swift
//  Easy ShoppingTests
//
//  Created by Agah Ozdemir on 20.12.2025.
//

import XCTest
@testable import Easy_Shopping

final class InMemoryShoppingListRepositoryTests: XCTestCase {

    private var repository: InMemoryShoppingListRepository!
    private var list: ShoppingList!

    override func setUp() {
        super.setUp()
        repository = InMemoryShoppingListRepository()
        list = repository.createList(title: "Market")
    }

    override func tearDown() {
        repository = nil
        list = nil
        super.tearDown()
    }

    // MARK: - Items

    func test_addItem_persistsItem() {
        repository.addItem(
            to: list.id,
            name: "Elma",
            quantity: "1 kg"
        )

        let items = repository.items(for: list.id)

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.name, "Elma")
    }

    func test_updateItem_persistsChanges() {
        repository.addItem(
            to: list.id,
            name: "Elma",
            quantity: "1 kg"
        )

        let itemID = repository.items(for: list.id).first!.id

        repository.updateItem(
            itemID: itemID,
            in: list.id,
            newName: "Kırmızı Elma",
            newQuantity: "2 kg",
            isCompleted: true
        )

        let updatedItem = repository.items(for: list.id).first
        XCTAssertEqual(updatedItem?.name, "Kırmızı Elma")
        XCTAssertTrue(updatedItem?.isCompleted ?? false)
    }

    func test_toggleCompletion_persistsState() {
        repository.addItem(
            to: list.id,
            name: "Elma",
            quantity: "1 kg"
        )

        let itemID = repository.items(for: list.id).first!.id

        repository.toggleCompletion(itemID: itemID, in: list.id)
        XCTAssertTrue(repository.items(for: list.id).first?.isCompleted ?? false)

        repository.toggleCompletion(itemID: itemID, in: list.id)
        XCTAssertFalse(repository.items(for: list.id).first?.isCompleted ?? true)
    }

    func test_removeItem_removesItem() {
        repository.addItem(
            to: list.id,
            name: "Elma",
            quantity: "1 kg"
        )

        let itemID = repository.items(for: list.id).first!.id

        repository.removeItem(
            itemID: itemID,
            from: list.id
        )

        XCTAssertTrue(repository.items(for: list.id).isEmpty)
    }
}
