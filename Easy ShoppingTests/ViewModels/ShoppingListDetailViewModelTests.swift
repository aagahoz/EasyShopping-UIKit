//
//  ShoppingListDetailViewModelTests.swift
//  Easy ShoppingTests
//
//  Created by Agah Ozdemir on 20.12.2025.
//

import XCTest
@testable import Easy_Shopping

final class ShoppingListDetailViewModelTests: XCTestCase {

    // MARK: - SUT & Dependencies

    private var repository: MockShoppingListRepository!
    private var list: ShoppingList!
    private var viewModel: ShoppingListDetailViewModel!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        repository = MockShoppingListRepository()
        list = repository.createList(title: "Market")
        viewModel = ShoppingListDetailViewModel(
            list: list,
            repository: repository
        )
    }

    override func tearDown() {
        repository = nil
        viewModel = nil
        list = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func test_initialState_isEmpty() {
        XCTAssertTrue(viewModel.state.value.isEmpty)
        XCTAssertEqual(viewModel.state.value.numberOfItems, 0)
    }

    // MARK: - Add Item

    func test_addItem_increasesItemCount() {
        viewModel.addItem(name: "Elma", quantity: "1 kg")

        XCTAssertEqual(viewModel.state.value.numberOfItems, 1)
        XCTAssertFalse(viewModel.state.value.isEmpty)
    }

    // MARK: - Delete Item

    func test_deleteItem_removesItem() {
        viewModel.addItem(name: "Elma", quantity: "1 kg")
        viewModel.addItem(name: "Muz", quantity: "2 adet")

        viewModel.deleteItem(at: 0)

        XCTAssertEqual(viewModel.state.value.numberOfItems, 1)
        XCTAssertEqual(viewModel.state.value.items.first?.name, "Muz")
    }

    func test_deleteItem_invalidIndex_doesNothing() {
        viewModel.addItem(name: "Elma", quantity: "1 kg")

        viewModel.deleteItem(at: 99)

        XCTAssertEqual(viewModel.state.value.numberOfItems, 1)
    }

    // MARK: - Update Item

    func test_updateItem_updatesFields() {
        viewModel.addItem(name: "Elma", quantity: "1 kg")

        viewModel.updateItem(
            at: 0,
            newName: "Yeşil Elma",
            newQuantity: "2 kg",
            isCompleted: true
        )

        let updatedItem = viewModel.state.value.items[0]
        XCTAssertEqual(updatedItem.name, "Yeşil Elma")
        XCTAssertEqual(updatedItem.quantity, "2 kg")
        XCTAssertTrue(updatedItem.isCompleted)
    }

    // MARK: - Toggle Completion

    func test_toggleItemCompletion_togglesState() {
        viewModel.addItem(name: "Elma", quantity: "1 kg")

        viewModel.toggleItemCompletion(at: 0)
        XCTAssertTrue(viewModel.state.value.items[0].isCompleted)

        viewModel.toggleItemCompletion(at: 0)
        XCTAssertFalse(viewModel.state.value.items[0].isCompleted)
    }

    func test_toggleItemCompletion_invalidIndex_doesNothing() {
        viewModel.addItem(name: "Elma", quantity: "1 kg")

        viewModel.toggleItemCompletion(at: 5)

        XCTAssertFalse(viewModel.state.value.items[0].isCompleted)
    }
}
