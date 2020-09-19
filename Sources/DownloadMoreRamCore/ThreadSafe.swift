//
//  ThreadSafeSet.swift
//  
//
//  Created by Albert Bori on 8/3/20.
//

import Foundation

class ThreadSafe<T> {
    private let lock = DispatchQueue(label: "ThreadSafe\(UUID())")
    private var innerValue: T
    var value: T {
        get {
            lock.sync { return innerValue }
        }
        set {
            lock.sync { innerValue = newValue }
        }
    }
    
    init(value: T) {
        innerValue = value
    }
}
