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
    
    func test_removeItem_removesItemFromList() {
        // Arrange
        let list = manager.createList(title: "Market")
        let item = manager.addItem(
            to: list,
         name: "Süt",
         quantity: "1L"
        )
        
        // Act
        manager.removeItem(item, from: list)
        
        // Assert
        XCTAssertTrue(manager.items(for: list).isEmpty)
    }
    
    func test_removeList_removesListFromManager() {
        // Arrange
        let list1 = manager.createList(title: "Market")
        let list2 = manager.createList(title: "Eczane")
        
        XCTAssertEqual(manager.lists.count, 2)
        
        // Act
        manager.removeList(list1)
        
        // Assert-2
        XCTAssertEqual(manager.lists.count, 1)
        XCTAssertEqual(manager.lists.first, list2)
    }
    
    func test_removeList_nonExistingList_doesNothing() {
        // Arrange
        let list1 = manager.createList(title: "Market")
        let fakeList = ShoppingList(id: UUID(), title: "Yok")
        
        // Act
        manager.removeList(fakeList)
        
        // Assert
        XCTAssertEqual(manager.lists.count, 1)
        XCTAssertEqual(manager.lists.first, list1)
    }
    
    func test_updateList_updatesTitle() {
        // Arrange
        let list = manager.createList(title: "Market")
        
        // Act
        manager.updateList(list, newTitle: "Yeni Liste")
        
        // Assert
        XCTAssertEqual(manager.lists.first?.title, "Yeni Liste")
    }
    
    func test_updateItem_updatesNameAndQuantity() {
        // Arrange
        let list = manager.createList(title: "Market")
        let item = manager.addItem(to: list, name: "Süt", quantity: "1 Litre")
        
        // Act
        manager.updateItem(item, in: list, newName: "Yoğurt", newQuantity: "2 Litre")
        
        // Assert
        let updatedItem = manager.items(for: list).first
        XCTAssertEqual(updatedItem?.name, "Yoğurt")
        XCTAssertEqual(updatedItem?.quantity, "2 Litre")
    }
    
    func test_updateItem_noneExistingItem_doesNothing() {
        // Arrange
        let list = manager.createList(title: "Market")
        let fakeItem = ShoppingItem(id: UUID(), name: "Fake", quantity: "0", isCompleted: false)
        
        // Act
        manager.updateItem(fakeItem, in: list, newName: "X", newQuantity: "Y")
        
        // Assert
        XCTAssertTrue(manager.items(for: list).isEmpty)
    }
}
