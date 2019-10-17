//
//  ForYouViewModel.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ForYouViewModel: ViewModelType {
    struct Input {
        let loadSignal = PublishRelay<Void>()
    }
    
    struct Output {
        let sections = BehaviorRelay<[Book.Section]>(value: [])
    }
    
    let input  = Input()
    let output = Output()
    
    private let disposeBag = DisposeBag()
    
    init() {
        input.loadSignal
            .flatMapLatest{ Local.Data.Favorite.gets() }
            .map{ [Book.Section(items: $0)] }
            .bind(to: self.output.sections)
            .disposed(by: self.disposeBag)
    }
}
