//
//  SectionData.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxDataSources

extension Book {
    struct Section : SectionModelType {
        var items:[Book]
    }
}

extension Book.Section {
    init(original: Book.Section, items: [Book]) {
        self = original
        self.items = items
    }
}


enum SearchData {
    case book(Book)
    case history(String)

    var book:Book? {
        switch self {
        case .book(let book): return book
        default: return nil
        }
    }
    
    var history:String? {
        switch self {
        case .history(let text): return text
        default: return nil
        }
    }
}

extension SearchData {
    struct Section : SectionModelType {
        var items:[SearchData]
    }
}

extension SearchData.Section {
    init(original: SearchData.Section, items: [SearchData]) {
        self = original
        self.items = items
    }
}
