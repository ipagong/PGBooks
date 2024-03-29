//
//  RxLifeCycle.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    var lifeCycle: LifeCycle {
        get { return LifeCycle(base: self) }
        set { }
    }
}

extension UIViewController {
    struct LifeCycle {
        weak var base: UIViewController!
    }
}

extension UIViewController.LifeCycle {
    func signalViewWillAppear() -> Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).takeUntil(base.rx.deallocated).map { _ in }
    }
    
    func signalViewDidAppear() -> Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:))).takeUntil(base.rx.deallocated).map { _ in }
    }
    
    func signalViewWillDisappear() -> Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewWillDisappear(_:))).takeUntil(base.rx.deallocated).map { _ in }
    }
    
    func signalViewDidDisappear() -> Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewDidDisappear(_:))).takeUntil(base.rx.deallocated).map { _ in }
    }
    
    func signalViewWillLayoutSubviews() -> Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewWillLayoutSubviews)).takeUntil(base.rx.deallocated).map { _ in }
    }
    
    func signalViewDidLayoutSubviews() -> Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews)).takeUntil(base.rx.deallocated).map { _ in }
    }
}
