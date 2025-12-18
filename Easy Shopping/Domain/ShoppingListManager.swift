//
//  ShoppingListManager.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 18.12.2025.
//

import Foundation

final class ShoppingListManager {
    
    private(set) var lists: [ShoppingList] = []
    private var itemsByListID: [UUID: [ShoppingItem]] = [:]
    
    // MARK: - Lists

    func createList(title: String) -> ShoppingList {
        
        let list = ShoppingList(
            id: UUID(),
            title: title
        )
        
        lists.append(list)
        itemsByListID[list.id] = []
        
        return list
    }
    
    func removeList(_ list: ShoppingList) {
        lists.removeAll { $0.id == list.id }
    }
    
    // MARK: - Items
    
    func items(for list: ShoppingList) -> [ShoppingItem] {
        return itemsByListID[list.id] ?? []
    }
    
    @discardableResult
    func addItem(
        to list: ShoppingList,
        name: String,
        quantity: String
    ) -> ShoppingItem {
        
        let item = ShoppingItem(
            id: UUID(),
            name: name,
            quantity: quantity,
            isCompleted: false
        )
        
        itemsByListID[list.id, default: []].append(item)
        return item
    }
    
    func removeItem(_ item: ShoppingItem, from list: ShoppingList) {
        guard var items = itemsByListID[list.id] else { return }
        items.removeAll { $0.id == item.id }
        itemsByListID[list.id] = items
    }
}
