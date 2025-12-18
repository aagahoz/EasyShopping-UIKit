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
    
    // MARK - Lists
    
    func createList(title: String) -> ShoppingList {
        
        let list = ShoppingList(
            id: UUID(),
            title: title
        )
        
        lists.append(list)
        itemsByListID[list.id] = []
        
        return list
    }
    
    // MARK - Items
    
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
    
    func items(for list: ShoppingList) -> [ShoppingItem] {
        return itemsByListID[list.id] ?? []
    }
}
