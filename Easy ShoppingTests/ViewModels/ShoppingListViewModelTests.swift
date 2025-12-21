//
//  ShoppingListViewModelTests.swift
//  Easy ShoppingTests
//
//  Created by Agah Ozdemir on 20.12.2025.
//

import XCTest
@testable import Easy_Shopping

final class ShoppingListViewModelTests: XCTestCase {

    // MARK: - SUT & Dependencies

    private var repository: MockShoppingListRepository!
    private var viewModel: ShoppingListsViewModel!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        repository = MockShoppingListRepository()
        viewModel = ShoppingListsViewModel(repository: repository)
    }

    override func tearDown() {
        repository = nil
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func test_initialState_isEmpty() {
        XCTAssertTrue(viewModel.state.value.isEmpty)
        XCTAssertEqual(viewModel.state.value.numberOfLists, 0)
    }

    // MARK: - Create List

    func test_createList_increasesListCount() {
        viewModel.createList(title: "Market")

        XCTAssertEqual(viewModel.state.value.numberOfLists, 1)
        XCTAssertFalse(viewModel.state.value.isEmpty)
    }

    func test_createMultipleLists_keepsOrder() {
        viewModel.createList(title: "Market")
        viewModel.createList(title: "Elektronik")

        XCTAssertEqual(viewModel.state.value.numberOfLists, 2)
        XCTAssertEqual(viewModel.list(at: 0).title, "Market")
        XCTAssertEqual(viewModel.list(at: 1).title, "Elektronik")
    }

    // MARK: - Delete List

    func test_deleteList_removesList() {
        viewModel.createList(title: "Market")
        viewModel.createList(title: "Elektronik")

        viewModel.deleteList(at: 0)

        XCTAssertEqual(viewModel.state.value.numberOfLists, 1)
        XCTAssertEqual(viewModel.list(at: 0).title, "Elektronik")
    }

    func test_deleteList_invalidIndex_doesNothing() {
        viewModel.createList(title: "Market")

        viewModel.deleteList(at: 10)

        XCTAssertEqual(viewModel.state.value.numberOfLists, 1)
        XCTAssertEqual(viewModel.list(at: 0).title, "Market")
    }

    // MARK: - Update List

    func test_updateList_changesTitle() {
        viewModel.createList(title: "Market")

        viewModel.updateList(at: 0, newTitle: "Haftalik Market")

        let updatedList = viewModel.list(at: 0)
        XCTAssertEqual(updatedList.title, "Haftalik Market")
    }

    func test_updateList_invalidIndex_doesNothing() {
        viewModel.createList(title: "Market")

        viewModel.updateList(at: 5, newTitle: "New Title")

        XCTAssertEqual(viewModel.state.value.numberOfLists, 1)
        XCTAssertEqual(viewModel.list(at: 0).title, "Market")
    }
}
