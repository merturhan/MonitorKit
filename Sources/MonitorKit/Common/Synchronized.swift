//
//  Synchronized.swift
//  MonitorKit
//
//  Created by Mert Urhan on 30.04.2025.
//

import Foundation

public class Synchronized<T> {
    private var value: T?
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue, value: T? = nil) {
        self.queue = queue
        self.value = value
    }
    
    func get() -> T? {
        var value: T?
        queue.sync {
            value = self.value
        }
        return value
    }
    
    func set(_ value: T?) {
        queue.sync(flags: .barrier) {
            self.value = value
        }
    }
}
