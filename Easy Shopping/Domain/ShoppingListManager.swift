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
    
    @discardableResult
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
    
    func updateList(_ list: ShoppingList, newTitle: String) {
        guard let index = lists.firstIndex(where: { $0.id == list.id}) else { return }
        lists[index].title = newTitle
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
    
    func updateItem(_ item: ShoppingItem, in list: ShoppingList, newName: String, newQuantity: String) {
        guard var items = itemsByListID[list.id],
              let index = items.firstIndex(where: {$0.id == item.id}) else {
            return
        }
        
        items[index].name = newName
        items[index].quantity = newQuantity
        
        itemsByListID[list.id] = items
        
    }
}
