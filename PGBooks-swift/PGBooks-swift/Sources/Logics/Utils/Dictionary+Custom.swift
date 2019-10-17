//
//  Dictionary+Custom.swift
//  acorn
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation

func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>) -> Dictionary<K,V> {
    var map = left
    for (k, v) in right {
        map[k] = v
    }
    return map
}


extension Dictionary {
    public func map<T: Hashable, U>( transform: (Key, Value) -> (T, U)) -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (transformedKey, transformedValue) = transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
    }
    
    public func map<T: Hashable, U>( transform: (Key, Value) throws -> (T, U)) rethrows -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (transformedKey, transformedValue) = try transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
    }
}

extension Dictionary {
    init<C: Collection>(_ collection: C, transform:(_ element: C.Iterator.Element) -> [Key : Value]) {
        self.init()
        collection.forEach { (element) in
            for (k, v) in transform(element) {
                self[k] = v
            }
        }
    }
}
