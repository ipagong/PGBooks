//
//  Observable+Customs.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Observable {
    func asOptional() -> Observable<Element?> {
        return self.map { value -> Element? in return value }
    }

    func collapseType() -> Observable<Void> {
        return self.map { _ in }
    }
}

extension Driver {

    func collapseType() -> Driver<Void> {
        return self.map { _ in }.asDriver(onErrorRecover: { _ in fatalError() })
    }
}
