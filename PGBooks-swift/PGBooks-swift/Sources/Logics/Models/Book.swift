//
//  Book.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Book {
    let title     : String
    let subtitle  : String
    let isbn13    : String
    let price     : String
    let image     : String
    let url       : String
    
    let authors   : String?
    let publisher : String?
    let language  : String?
    let isbn10    : String?
    let pages     : String?
    let year      : String?
    let rating    : String?
    let desc      : String?
}

extension Book {
    
    init(input:JSON) {
        self.title       = input["title"].stringValue
        self.subtitle    = input["subtitle"].stringValue
        self.isbn13      = input["isbn13"].stringValue
        self.price       = input["price"].stringValue
        self.image       = input["image"].stringValue
        self.url         = input["url"].stringValue
        
        self.authors     = input["authors"].string
        self.publisher   = input["publisher"].string
        self.language    = input["language"].string
        self.isbn10      = input["isbn10"].string
        self.pages       = input["pages"].string
        self.year        = input["year"].stringValue
        self.rating      = input["rating"].string
        self.desc        = input["desc"].string
    }
    
    var pageString:String? {
        guard let page = self.pages?.collapseIfEmpty else { return nil }
        return "(\(page) pages))"
    }
    
    var etcs:String? {
        return [self.year, self.pageString].unwrap().joined(separator: ", ")
    }
    
    var needUpdate:Bool {
        return isbn10 == .none
    }
}

extension Book : Equatable {
    public static func ==(lhs:Book, rhs:Book) -> Bool {
        return lhs.isbn13 == rhs.isbn13
    }
}

extension Book : Codable { }
