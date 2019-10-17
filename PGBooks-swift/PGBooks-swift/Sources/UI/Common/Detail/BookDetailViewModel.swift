//
//  BookDetailViewModel.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class BookDetailViewModel: ViewModelType {
    struct Input {
        let loadSignal = PublishRelay<Book?>()
        
        let link = PublishRelay<Void>()
        let favoriteToggle = PublishRelay<Void>()
        
    }
    
    struct Output {
        let price       = PublishRelay<String>()
        let isbn13      = PublishRelay<String>()
        let title       = PublishRelay<String>()
        let subtitle    = PublishRelay<String>()
        let isbn10      = PublishRelay<String>()
        let etcs        = PublishRelay<String>()
        let authors     = PublishRelay<String>()
        let publisher   = PublishRelay<String>()
        let language    = PublishRelay<String>()
        let desc        = PublishRelay<String>()
        let favorite    = PublishRelay<Bool>()
        let image       = PublishRelay<UIImage>()
        let rating      = PublishRelay<Int>()
    }
    
    let input  = Input()
    let output = Output()
    
    private let book = BehaviorRelay<Book?>(value: nil)
    
    private let favoriteBooks = PublishRelay<[Book]>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        input.loadSignal.unwrap()
            .bind(to: book)
            .disposed(by: self.disposeBag)
        
        input.loadSignal.unwrap().filter{$0.needUpdate}
            .flatMapLatest{
                API.Store.BookInfo.init(number: $0.isbn13).request()
                    .asOptional().catchErrorJustReturn(nil).unwrap()
            }.bind(to: self.book)
            .disposed(by: self.disposeBag)
        
        input.link.withLatestFrom(self.book).unwrap()
            .map{try? $0.url.asURL()}.unwrap()
            .subscribe(onNext: { (url) in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }).disposed(by: self.disposeBag)
        
        input.loadSignal.asObservable().collapseType()
            .flatMapLatest{Local.Data.Favorite.gets()}
            .bind(to: favoriteBooks)
            .disposed(by: self.disposeBag)
        
        input.favoriteToggle.withLatestFrom(self.book).unwrap()
            .flatMapLatest{Local.Data.Favorite.toggle(book: $0)}
            .bind(to: favoriteBooks)
            .disposed(by: self.disposeBag)
        
        favoriteBooks
            .withLatestFrom(self.book.unwrap()) { (books: $0, current:$1) }
            .map{ $0.books.contains($0.current) }
            .bind(to: self.output.favorite)
            .disposed(by: self.disposeBag)
        
        book.map{$0?.price.collapseIfEmpty      ?? "----"}.bind(to: output.price)    .disposed(by: self.disposeBag)
        book.map{$0?.isbn13.collapseIfEmpty     ?? "----"}.bind(to: output.isbn13)   .disposed(by: self.disposeBag)
        book.map{$0?.title.collapseIfEmpty      ?? "----"}.bind(to: output.title)    .disposed(by: self.disposeBag)
        book.map{$0?.subtitle.collapseIfEmpty   ?? "----"}.bind(to: output.subtitle) .disposed(by: self.disposeBag)
        book.map{$0?.isbn10?.collapseIfEmpty    ?? "----"}.bind(to: output.isbn10)   .disposed(by: self.disposeBag)
        book.map{$0?.etcs?.collapseIfEmpty      ?? "----"}.bind(to: output.etcs)     .disposed(by: self.disposeBag)
        book.map{$0?.authors?.collapseIfEmpty   ?? "----"}.bind(to: output.authors)  .disposed(by: self.disposeBag)
        book.map{$0?.publisher?.collapseIfEmpty ?? "----"}.bind(to: output.publisher).disposed(by: self.disposeBag)
        book.map{$0?.language?.collapseIfEmpty  ?? "----"}.bind(to: output.language) .disposed(by: self.disposeBag)
        book.map{$0?.desc?.collapseIfEmpty      ?? "----"}.bind(to: output.desc)     .disposed(by: self.disposeBag)
        
        book.map{$0?.rating}.unwrap().distinctUntilChanged()
            .map{Int.init($0) ?? 0}
            .bind(to: output.rating)
            .disposed(by: self.disposeBag)
        
        book.unwrap()
            .subscribe(onNext: Local.Data.Glance.save)
            .disposed(by: self.disposeBag)
        
        book.unwrap().map{$0.image}.distinctUntilChanged()
            .map{try? $0.asURL()}.unwrap()
            .flatMapFirst{$0.image()}
            .map{ $0}.debug("image??")
            .bind(to: self.output.image)
            .disposed(by: self.disposeBag)
        
    }
}
