//
//  ShoppingListsState.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 21.12.2025.
//

import Foundation

struct ShoppingListsState {
    let lists: [ShoppingList]
    
    var isEmpty: Bool {
        lists.isEmpty
    }
    
    var numberOfLists: Int {
        lists.count
    }
}
