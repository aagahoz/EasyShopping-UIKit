//
//  Observable.swift
//  Easy Shopping
//
//  Created by Agah Ozdemir on 21.12.2025.
//

import Foundation

final class Observable<Value> {

    private var observer: ((Value) -> Void)?

    var value: Value {
        didSet {
            observer?(value)
        }
    }

    init(_ value: Value) {
        self.value = value
    }

    func bind(_ observer: @escaping (Value) -> Void) {
        self.observer = observer
        observer(value)
    }
}

