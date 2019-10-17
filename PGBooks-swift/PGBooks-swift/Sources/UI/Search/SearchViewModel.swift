//
//  SearchViewModel.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewModel: ViewModelType {
    struct Input {
        let loadSignal   = PublishRelay<Void>()
        let pageSignal   = PublishRelay<Void>()
        let textSignal   = PublishRelay<String?>()
        let activeSignal = PublishRelay<Bool>()
        let searchSignal = PublishRelay<Void>()
        
        let selectSignal = PublishRelay<SearchData>()
    }
    
    struct Output {
        let sections = BehaviorRelay<[SearchData.Section]>(value: [])
        
        let changedText = BehaviorRelay<String?>(value: nil)
        
        let showBook  = PublishRelay<Book>()
    }
    
    private let saveQuery    = PublishRelay<String>()
    private let loadData     = PublishRelay<Void>()
    private let clearData    = PublishRelay<Void>()
    
    private let mode = BehaviorRelay<SearchViewModel.Mode>(value: .typing)
    private let text = BehaviorRelay<String?>(value: nil)
    
    private let total = BehaviorRelay<Int>(value: 0)
    
    private let historyQuery  = BehaviorRelay<[SearchData.Section]>(value: [])
    private let historyResult = BehaviorRelay<[SearchData.Section]>(value: [])
    
    private let searchResult  = BehaviorRelay<[SearchData.Section]>(value: [])
    
    let input  = Input()
    let output = Output()
    
    private let disposeBag = DisposeBag()
    
    init() {
        Observable.merge(input.textSignal.mapTo(.typing),
                         input.loadSignal.mapTo(.history),
                         input.activeSignal.filter(!).mapTo(.history),
                         input.searchSignal.mapTo(.search),
                         output.changedText.mapTo(.search))
            .bind(to: self.mode)
            .disposed(by: self.disposeBag)
        
        self.mode.filter{ $0 == .history }.collapseType()
            .flatMapLatest{
                Observable.zip(Local.Data.Query.gets().map{ $0.compactMap{ SearchData.history($0) }},
                               Local.Data.Search.gets().map{ $0.compactMap{ SearchData.book($0) }})
            }.map{ [SearchData.Section(items:$0.0)] + [SearchData.Section(items:$0.1)] }
            .bind(to: self.output.sections)
            .disposed(by: self.disposeBag)
        
        self.mode.filter{ $0 == .typing }.collapseType()
            .map{ [SearchData.Section]() }
            .bind(to: self.output.sections)
            .disposed(by: self.disposeBag)
        
        self.mode.filter{ $0 == .search }.collapseType()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: self.clearData, self.loadData)
            .disposed(by: self.disposeBag)
        
        input.pageSignal
            .withLatestFrom(self.mode).filter{ $0 == .search }.collapseType()
            .withLatestFrom(self.searchResult.map{ $0.reduce(0) { $0 + $1.items.count } })
            .withLatestFrom(self.total) { ($1 == NSNotFound || $0 < $1) }
            .filter{$0}.collapseType()
            .bind(to: self.loadData)
            .disposed(by: self.disposeBag)
        
        input.selectSignal
            .map{ $0.book }.unwrap()
            .bind(to: output.showBook)
            .disposed(by: self.disposeBag)
        
        input.selectSignal
            .map{ $0.history }.unwrap()
            .bind(to: self.text, self.output.changedText)
            .disposed(by: self.disposeBag)
        
        input.textSignal.unwrap()
            .bind(to: self.text)
            .disposed(by: self.disposeBag)
        
        // 데이타 클리어
        self.clearData.mapTo(NSNotFound)
            .bind(to: self.total)
            .disposed(by: self.disposeBag)
        
        self.clearData.mapTo([])
            .bind(to: self.historyResult)
            .disposed(by: self.disposeBag)

        // 검색
        let rx_result =
            self.loadData
                .delay(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
                .withLatestFrom(self.text).unwrap()
                .withLatestFrom(self.output.sections) { (text: $0, data: $1) }
                .flatMapLatest{ API.Store.Search.init(query: $0.text, page: $0.data.count).request() }
                .share(replay: 1)
        
        rx_result.map{ $0.total }
            .bind(to: self.total)
            .disposed(by: self.disposeBag)
        
        rx_result.map{ $0.books }
            .map{ $0.compactMap{ SearchData.book($0) } }
            .map{ [SearchData.Section(items: $0)] }
            .withLatestFrom(self.searchResult) { $1 + $0 }
            .bind(to: self.searchResult, self.output.sections)
            .disposed(by: self.disposeBag)
        
        self.searchResult.map{ $0.first }.unwrap()
            .filter{ $0.items.count > 0 }.map{ $0.items.compactMap{ $0.book } }
            .subscribe(onNext: { Local.Data.Search.save(books: $0) })
            .disposed(by: self.disposeBag)
        
        self.searchResult.map{ $0.first }.unwrap()
            .filter{ $0.items.count > 0 }
            .withLatestFrom(self.text).unwrap().distinctUntilChanged()
            .subscribe(onNext: { Local.Data.Query.save(query: $0) })
            .disposed(by: self.disposeBag)
    }
}

extension SearchViewModel {
    enum Mode {
        case history
        case search
        case typing
    }
}
