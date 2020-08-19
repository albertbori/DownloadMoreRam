//
//  File.swift
//  
//
//  Created by Albert Bori on 8/18/20.
//

import Foundation

class ThreadSafeCounter {
    private let countQueue = DispatchQueue(label: "SafeCounter.count")
    private var _count: Int = 0
    var count: Int {
        get { countQueue.sync { _count } }
        set { countQueue.sync { _count = newValue } }
    }
}
