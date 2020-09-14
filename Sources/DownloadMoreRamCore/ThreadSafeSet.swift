//
//  ThreadSafeSet.swift
//  
//
//  Created by Albert Bori on 8/3/20.
//

import Foundation

class ThreadSafeSet<T> where T: Hashable {
    private let lock = DispatchQueue(label: "SafeSet\(UUID())")
    private var set = Set<T>()
    var safeSet: Set<T> {
        get {
            lock.sync { return set }
        }
        set {
            lock.sync { set = newValue }
        }
    }
}
