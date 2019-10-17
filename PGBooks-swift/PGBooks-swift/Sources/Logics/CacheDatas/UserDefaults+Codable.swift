//
//  UserDefaults+Codable.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation

public extension UserDefaults {
    func set<T: Codable>(object: T, forKey: String) throws {
        let jsonData = try JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }

    func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        guard let result = value(forKey: forKey) as? Data else { return nil }
        return try JSONDecoder().decode(objectType, from: result)
    }
}

 public extension UserDefaults {
    func sets<T: Codable>(objects: [T], forKey: String){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(objects), forKey: forKey)
    }

    func gets<T: Codable>(objectType: T.Type, forKey: String) throws -> [T] {
        guard let data = UserDefaults.standard.object(forKey: forKey) as? Data else { return [T]() }
        return try PropertyListDecoder().decode([T].self, from: data)
    }
}
