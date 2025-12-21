//
//  ShoppingItem.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 18.12.2025.
//

import Foundation

struct ShoppingItem: Equatable {
    let id: UUID
    var name: String
    var quantity: String
    var isCompleted: Bool
    
    init(id: UUID, name: String, quantity: String, isCompleted: Bool) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.isCompleted = isCompleted
    }
}

