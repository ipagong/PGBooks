//
//  API.Store.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct API { struct Store { } }

extension API.Store {
    
    struct NewItems { }
    
    struct Search {
        let query : String
        let page  : Int
    }
    
    struct BookInfo {
        let number : String
    }
    
}

extension API.Store.NewItems : APIConfig {
    static var domainConfig: DomainConfig.Type = ITStoreServer.self
    var method: Alamofire.HTTPMethod { return .get }
    
    var path: String { return "/1.0/new" }
    
    var parameters: [String: Any?]? { return nil }
    
    func parse(_ input: JSON) -> [Book] {
        return input["books"].arrayValue.map(Book.init)
    }
    
    enum APIError: Error {
        case updateError(String)
    }
    
    func catchError(_ error: RemoteError) -> APIError? {
        return .updateError(error.message)
    }
}

extension API.Store.Search : APIConfig {
    static var domainConfig: DomainConfig.Type = ITStoreServer.self
    var method: Alamofire.HTTPMethod { return .get }
    
    var path: String { return "/1.0/search/\(query)/\(page)" }
    
    var parameters: [String: Any?]? { return nil }
    
    func parse(_ input: JSON) -> (books: [Book], total: Int) {
        return (books: input["books"].arrayValue.map(Book.init), total: input["total"].intValue)
    }
    
    enum APIError: Error {
        case updateError(String)
    }
    
    func catchError(_ error: RemoteError) -> APIError? {
        return .updateError(error.message)
    }
}

extension API.Store.BookInfo : APIConfig {
    static var domainConfig: DomainConfig.Type = ITStoreServer.self
    var method: Alamofire.HTTPMethod { return .get }
    
    var path: String { return "/1.0/books/\(number)" }
    
    var parameters: [String: Any?]? { return nil }
    
    func parse(_ input: JSON) -> Book {
        return Book.init(input: input)
    }
    
    enum APIError: Error {
        case updateError(String)
    }
    
    func catchError(_ error: RemoteError) -> APIError? {
        return .updateError(error.message)
    }
}

