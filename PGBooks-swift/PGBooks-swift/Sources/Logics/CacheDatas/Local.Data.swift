//
//  Local.Data.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Local { struct Data {  } }

extension Local.Data {
    fileprivate
    enum Key : String {
        case query
        case search
        case favorite
        case glance
    }
}

extension Local.Data {
    struct Search {
        static func gets() -> Observable<[Book]> {
            return Observable<[Book]>.create { (observer) -> Disposable in
                
                DispatchQueue.global().async {
                    let books = try? UserDefaults.standard.gets(objectType: Book.self,
                                                                forKey: Local.Data.Key.search.rawValue)
                    
                    DispatchQueue.main.async {
                        if let _ = books { observer.onNext(books!) }
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
        
        static func save(books:[Book]) {
            UserDefaults.standard.sets(objects: books, forKey: Local.Data.Key.search.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}

extension Local.Data {
    struct Query {
        static func gets() -> Observable<[String]> {
            return Observable<[String]>.create { (observer) -> Disposable in
                DispatchQueue.global().async {
                    let query = try? UserDefaults.standard.gets(objectType: String.self,
                                                                forKey: Local.Data.Key.query.rawValue)
                    
                    DispatchQueue.main.async {
                        if let _ = query { observer.onNext(query!) }
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
        
        static func save(query: String) {
            var loaded = (try? UserDefaults.standard.gets(objectType: String.self,
                                                         forKey: Local.Data.Key.query.rawValue)) ?? []
            loaded.removeAll{ $0 == query }
            loaded.insert(query, at: 0)
            
            UserDefaults.standard.sets(objects: loaded, forKey: Local.Data.Key.query.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}

extension Local.Data {
    struct Glance {
        static func gets() -> Observable<[Book]> {
            return Observable<[Book]>.create { (observer) -> Disposable in
                DispatchQueue.global().async {
                    let books = try? UserDefaults.standard.gets(objectType: Book.self,
                                                                forKey: Local.Data.Key.glance.rawValue)
                    
                    DispatchQueue.main.async {
                        if let _ = books { observer.onNext(Array(books!.prefix(20))) }
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
        
        static func save(book: Book) {
            var loaded = (try? UserDefaults.standard.gets(objectType: Book.self,
                                                          forKey: Local.Data.Key.glance.rawValue)) ?? []
            loaded.removeAll{ $0 == book }
            loaded.insert(book, at: 0)
            
            UserDefaults.standard.sets(objects: Array(loaded.prefix(20)), forKey: Local.Data.Key.glance.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}

extension Local.Data {
    struct Favorite {
        static func gets() -> Observable<[Book]> {
            return Observable<[Book]>.create { (observer) -> Disposable in
                DispatchQueue.global().async {
                    let books = try? UserDefaults.standard.gets(objectType: Book.self,
                                                                forKey: Local.Data.Key.favorite.rawValue)
                    
                    DispatchQueue.main.async {
                        if let _ = books { observer.onNext(books!) }
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
        
        static func toggle(book: Book) -> Observable<[Book]> {
            return Local.Data.Favorite.gets()
                .map{ books in
                    if books.contains(book) {
                        return books.filter{$0 != book}
                    } else {
                        return ([book] + books)
                    }
                }.do(onNext: { (books) in
                    UserDefaults.standard.sets(objects: books, forKey: Local.Data.Key.favorite.rawValue)
                    UserDefaults.standard.synchronize()
                })
        }
    }
}
