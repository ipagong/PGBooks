//
//  Optional+Custom.swift
//  acorn
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation

protocol OptionalType {
    associatedtype T
    associatedtype WrappedT
    
    var asOptional: T? {get}
}

extension Optional: OptionalType {
    typealias WrappedT = Wrapped

    var asOptional: Wrapped? {return self}
}

extension Dictionary where Value: OptionalType {
    func unwrap() -> [Key: Value.T] {
        let a = self.filter { (key: Key, value: Value) -> Bool in return (value.asOptional != nil) }
            .map { (key: Key, value: Value) -> (Key, Value.T) in return (key, value.asOptional!) }
        
        var returnValue: [Key: Value.T] = [:]
        
        for (key, value) in a {
            returnValue[key] = value
        }
        
        return returnValue
    }
}

extension Array where Element: OptionalType {
    func unwrap() -> [Element.T] {
        return self.compactMap { $0.asOptional }
    }
}
