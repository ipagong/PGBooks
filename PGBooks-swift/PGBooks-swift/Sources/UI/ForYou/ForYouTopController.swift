//
//  ForYouTopController.swift
//  PGBooks-swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ForYouTopController: UIViewController, BookDetailTransitionable {

    @IBOutlet weak var tableview : UITableView!
    
    private lazy var viewModel:ForYouViewModel = { ForYouViewModel.init() }()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
    
    }
    
    func setupUI() {
        self.title = ServiceType.forYou.title
        self.tableview.register(BookSimpleCell.nibByIdentifier,
                                forCellReuseIdentifier: BookSimpleCell.identifier)
        self.tableview.tableFooterView = UIView()
    }
    
    func binding() {
        self.lifeCycle.signalViewWillAppear()
            .bind(to: self.viewModel.input.loadSignal)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.sections
            .bind(to: self.tableview.rx.items(dataSource:
                RxTableViewSectionedReloadDataSource<Book.Section>.init(configureCell: { (ds, tb, ip, data) -> UITableViewCell in
                    return tb.getCell(value: BookSimpleCell.self, indexPath: ip, data: data)
                })
            ))
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.sections
            .flatMapLatest{ [weak self] data in
                self?.tableview.rx.itemSelected.map{ data[$0.section].items[$0.row] } ?? .empty()
            }.asOptional()
            .catchErrorJustReturn(nil).unwrap()
            .subscribe(onNext: { [weak self] (book) in
                guard let self = self else { return }
                self.showBookDetail(book)
            }).disposed(by: self.disposeBag)
    }

}
