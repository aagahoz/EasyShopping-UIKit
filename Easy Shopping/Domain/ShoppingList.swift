//
//  ShoppingList.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 18.12.2025.
//

import Foundation

struct ShoppingList: Equatable {
    let id: UUID
    var title: String
    
    init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
}
