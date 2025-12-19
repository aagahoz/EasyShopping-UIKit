//
//  ShoppingListRepository.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 19.12.2025.
//

import Foundation

protocol ShoppingListRepository {
    
    // LISTS
    func fetchLists() -> [ShoppingList]
    func createList(title: String) -> ShoppingList
    func updateList(_ list: ShoppingList, newTitle: String)
    func removeList(_ list: ShoppingList)
    
    // ITEMS
    func items(for list: ShoppingList) -> [ShoppingItem]
    func addItem(
        to list: ShoppingList,
        name: String,
        quantity: String
    ) -> ShoppingItem
    func updateItem(
        _ item: ShoppingItem,
        in list: ShoppingList,
        newName: String,
        newQuantity: String
    )
    func removeItem(_ item: ShoppingItem, from list: ShoppingList)
}
