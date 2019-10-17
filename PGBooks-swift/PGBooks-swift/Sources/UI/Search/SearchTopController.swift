//
//  SearchTopController.swift
//  PGBooks-swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchTopController: UIViewController, BookDetailTransitionable {

    @IBOutlet weak var tableview : UITableView!
    
    private lazy var viewModel:SearchViewModel = { SearchViewModel.init() }()
    
    private let disposeBag = DisposeBag()
    
    lazy var searchController:UISearchController = {
        let search = UISearchController.init(searchResultsController: nil)
        
        search.obscuresBackgroundDuringPresentation = true
        search.definesPresentationContext = true
        search.dimsBackgroundDuringPresentation = false
        
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        binding()
    }
    
    func setupUI() {
        self.title = ServiceType.search.title
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.tableview.register(BookSimpleCell.nibByIdentifier,
                                forCellReuseIdentifier: BookSimpleCell.identifier)
        self.tableview.register(SearchHistoryCell.nibByIdentifier,
                                forCellReuseIdentifier: SearchHistoryCell.identifier)
        self.tableview.tableFooterView = UIView()
    }
    
    func binding() {
        
        self.lifeCycle.signalViewWillAppear()
            .bind(to: self.viewModel.input.loadSignal)
            .disposed(by: self.disposeBag)
        
        self.searchController.searchBar.rx.text.asObservable().distinctUntilChanged()
            .bind(to: self.viewModel.input.textSignal)
            .disposed(by: self.disposeBag)
        
        self.searchController.rx.didUpdateSearchResults.map{ $0.isActive }
            .bind(to: self.viewModel.input.activeSignal)
            .disposed(by: self.disposeBag)
        
        self.searchController.searchBar.rx.searchButtonClicked.asObservable()
            .bind(to: self.viewModel.input.searchSignal)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.sections
            .bind(to: self.tableview.rx.items(dataSource:
                RxTableViewSectionedReloadDataSource<SearchData.Section>.init(configureCell: { (ds, tb, ip, data) -> UITableViewCell in
                    switch data {
                    case .book(let book):
                        return tb.getCell(value: BookSimpleCell.self, indexPath: ip, data: book)
                    case .history(let text):
                        return tb.getCell(value: SearchHistoryCell.self, indexPath: ip, data: text)
                    }
                })
            ))
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.sections
            .flatMapLatest{ [weak self] data in
                self?.tableview.rx.itemSelected.map{ data[$0.section].items[$0.row] } ?? .empty()
            }.asOptional()
            .catchErrorJustReturn(nil).unwrap()
            .bind(to: self.viewModel.input.selectSignal)
            .disposed(by: self.disposeBag)
        
        self.tableview.rx.willDisplayCell.map{ $0.indexPath }
            .withLatestFrom(self.viewModel.output.sections) { (indexPath:$0, data: $1) }
            .filter { $0.indexPath.section == ($0.data.count - 1) }
            .filter { $0.indexPath.row == ($0.data[$0.indexPath.section].items.count - 1) }
            .collapseType()
            .bind(to: self.viewModel.input.pageSignal)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.changedText
            .subscribe(onNext: { [weak self] (text) in
                self?.searchController.searchBar.text = text
                self?.searchController.isActive = true
            }).disposed(by: self.disposeBag)

        self.viewModel.output.showBook
            .subscribe(onNext: { [weak self] (book) in
                guard let self = self else { return }
                self.showBookDetail(book)
            }).disposed(by: self.disposeBag)
    }

}
