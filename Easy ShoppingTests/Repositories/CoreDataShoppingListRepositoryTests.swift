//
//  CoreDataShoppingListRepositoryTests.swift
//  Easy ShoppingTests
//
//  Created by Agah Ozdemir on 21.12.2025.
//

import XCTest
@testable import Easy_Shopping

final class CoreDataShoppingListRepositoryTests: XCTestCase {
    
    private var stack: TestCoreDataStack!
    private var repository: CoreDataShoppingListRepository!
    
    override func setUp() {
        super.setUp()
        stack = TestCoreDataStack()
        repository = CoreDataShoppingListRepository(context: stack.context)
    }
    
    override func tearDown() {
        repository = nil
        stack = nil
        super.tearDown()
    }
    
    func test_createList_persistsList() {
        let list = repository.createList(title: "Market")
        
        let lists = repository.fetchLists()
        
        XCTAssertEqual(lists.count, 1)
        XCTAssertEqual(lists.first?.id, list.id)
        XCTAssertEqual(lists.first?.title, "Market")
    }
    
    func test_updateList_updatesTitle() {
        let list = repository.createList(title: "Market")
        
        repository.updateList(listID: list.id, newTitle: "Haftalık Market")
            
        let updated = repository.fetchLists().first
        XCTAssertEqual(updated?.title, "Haftalık Market")
    }
    
    func test_removeList_deleteList() {
        let list = repository.createList(title: "Market")
        
        repository.removeList(listID: list.id)
        
        XCTAssertTrue(repository.fetchLists().isEmpty)
    }
    
    func test_addItem_persistsItem() {
        let list = repository.createList(title: "Market")
        
        repository.addItem(to: list.id, name: "Elma", quantity: "1 kg")
        
        let items = repository.items(for: list.id)
        
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.name, "Elma")
    }
    
    func test_toggleCompletion_persistsState() {
        let list = repository.createList(title: "Market")
        
        repository.addItem(to: list.id, name: "Elma", quantity: "1 kg")
    
        let itemID = repository.items(for: list.id).first!.id
        
        repository.toggleCompletion(itemID: itemID, in: list.id)
        XCTAssertTrue(repository.items(for: list.id).first?.isCompleted ?? false)
    }
    
    func test_removeItem_removesItem() {
        let list = repository.createList(title: "Market")
        
        repository.addItem(to: list.id, name: "Elma", quantity: "1 kg")
        
        let itemID = repository.items(for: list.id).first!.id
        
        repository.removeItem(itemID: itemID, from: list.id)
        XCTAssertTrue(repository.items(for: list.id).isEmpty)
    }
}
