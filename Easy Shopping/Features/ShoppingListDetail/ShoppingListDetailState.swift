//
//  ShoppingListDetailState.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 21.12.2025.
//

import Foundation

struct ShoppingListDetailState {
    let items: [ShoppingItem]
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    var numberOfItems: Int {
        items.count
    }
}
