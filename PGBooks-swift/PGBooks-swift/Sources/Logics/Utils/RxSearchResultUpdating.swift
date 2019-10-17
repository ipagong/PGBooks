//
//  RxSearchResultUpdating.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class RxSearchResultsUpdatingProxy: DelegateProxy<UISearchController, UISearchResultsUpdating>, UISearchResultsUpdating {

    lazy var didUpdateSearchResults = PublishSubject<UISearchController>()
    
    init(searchController: UISearchController) {
        super.init(parentObject: searchController, delegateProxy: RxSearchResultsUpdatingProxy.self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        didUpdateSearchResults.onNext(searchController)
    }
}

extension RxSearchResultsUpdatingProxy: DelegateProxyType {
    static func currentDelegate(for object: UISearchController) -> UISearchResultsUpdating? {
        return object.searchResultsUpdater
    }
    
    static func setCurrentDelegate(_ delegate: UISearchResultsUpdating?, to object: UISearchController) {
        object.searchResultsUpdater = delegate
    }
    
    static func registerKnownImplementations() {
        register { RxSearchResultsUpdatingProxy(searchController: $0) }
    }
}

public extension Reactive where Base: UISearchController {
    
    var delegate: DelegateProxy<UISearchController, UISearchResultsUpdating> {
        return RxSearchResultsUpdatingProxy.proxy(for: base)
    }
    
    var didUpdateSearchResults: Observable<UISearchController> {
        return RxSearchResultsUpdatingProxy.proxy(for: base).didUpdateSearchResults.asObservable()
    }
}
