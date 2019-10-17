//
//  TabContainer.swift
//  PGBooks-swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit

enum ServiceType : Int {
    case new = 0
    case list
    case forYou
    case search
    
    var segueIdentifier:String {
        switch self {
        case .new:    return "New"
        case .list:   return "List"
        case .forYou: return "ForYou"
        case .search: return "Search"
        }
    }
    
    var title:String {
        switch self {
        case .new:    return "New"
        case .list:   return "Glance"
        case .forYou: return "Favorite"
        case .search: return "Search"
        }
    }
}

class TabContainer: UIViewController {
    public var selected: ServiceType = .new
    
    fileprivate var viewControllers: [UIViewController?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reset()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewControllers[selected.rawValue] = segue.destination
        
        swap(from: children.first, to: segue.destination)
    }
    
    public func swap(_ switchService: ServiceType) {
        load(service: switchService)
    }
    
    public func reload() {
        load(service: selected)
    }
    
    public func reset() {
        viewControllers
            .compactMap { $0?.view }
            .forEach { $0.removeFromSuperview() }
        
        viewControllers = (0...ServiceType.search.rawValue).map { _ in nil }
    }
}

extension TabContainer {
    
    fileprivate func load(service: ServiceType) {
        selected = service
        
        if let to = viewControllers[selected.rawValue] {
            swap(from: children.first, to: to)
        } else {
            performSegue(withIdentifier: selected.segueIdentifier, sender: nil)
        }
    }
    
    fileprivate func swap(from: UIViewController?, to: UIViewController) {
        from?.willMove(toParent: nil)
        from?.view.removeFromSuperview()
        from?.removeFromParent()
        
        addChild(to)
        view.addSubview(to.view)
        
        to.view.frame = view.bounds
        to.didMove(toParent: self)
    }
}

class TabSegue: UIStoryboardSegue {
    override func perform() { }
}



