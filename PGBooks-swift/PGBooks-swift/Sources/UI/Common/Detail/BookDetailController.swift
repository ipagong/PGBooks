//
//  BookDetailController.swift
//  PGBooks-swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PGTransitionKit

protocol BookDetailTransitionable {
    var tableview:UITableView! { get }
}

class BookDetailController: UIViewController {
    @IBOutlet var scrollView        : UIScrollView!
    @IBOutlet var coverView         : UIImageView!
    @IBOutlet var stackContainer    : UIStackView!
    @IBOutlet var priceLabel        : PaddingLabel!
    @IBOutlet var linkButton        : UIButton!
    @IBOutlet var favoriteButton    : UIButton!
    @IBOutlet var isbn13Label       : UILabel!
    @IBOutlet var isbn10Label       : UILabel!
    @IBOutlet var ratingContainer   : UIStackView!
    @IBOutlet var bookTitleLabel    : UILabel!
    @IBOutlet var bookSubtitleLabel : UILabel!
    @IBOutlet var etcLabel          : UILabel!
    @IBOutlet var authorsLabel      : UILabel!
    @IBOutlet var publisherLabel    : UILabel!
    @IBOutlet var languagesLabel    : UILabel!
    @IBOutlet var descLabel         : UILabel!
    
    @IBOutlet weak var closeButton    : UIButton!
    
    var animator: PGTransitionKit.Animator!
    
    public var book:Book!
    
    private let viewModel = BookDetailViewModel.init()
    private let disposeBag = DisposeBag()
    
    static func createInstance() -> BookDetailController? {
        return UIStoryboard.init(name: "BookDetail", bundle: nil).instantiateViewController(withIdentifier: "BookDetailController") as? BookDetailController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
    }

    func setupUI() {
        self.animator.dismissInteractor = ScrollDownInteractor.init(targetView: self.scrollView)
    }
    
    func binding() {
        self.viewModel.output.price     .bind(to: priceLabel.rx.text)          .disposed(by: self.disposeBag)
        self.viewModel.output.isbn13    .bind(to: isbn13Label.rx.text)         .disposed(by: self.disposeBag)
        self.viewModel.output.title     .bind(to: bookTitleLabel.rx.text)      .disposed(by: self.disposeBag)
        self.viewModel.output.subtitle  .bind(to: bookSubtitleLabel.rx.text)   .disposed(by: self.disposeBag)
        self.viewModel.output.isbn10    .bind(to: isbn10Label.rx.text)         .disposed(by: self.disposeBag)
        self.viewModel.output.etcs      .bind(to: etcLabel.rx.text)            .disposed(by: self.disposeBag)
        self.viewModel.output.authors   .bind(to: authorsLabel.rx.text)        .disposed(by: self.disposeBag)
        self.viewModel.output.publisher .bind(to: publisherLabel.rx.text)      .disposed(by: self.disposeBag)
        self.viewModel.output.language  .bind(to: languagesLabel.rx.text)      .disposed(by: self.disposeBag)
        self.viewModel.output.desc      .bind(to: descLabel.rx.text)           .disposed(by: self.disposeBag)
        self.viewModel.output.image     .bind(to: coverView.rx.image)          .disposed(by: self.disposeBag)
        self.viewModel.output.favorite  .bind(to: favoriteButton.rx.isSelected).disposed(by: self.disposeBag)
        
        self.viewModel.output.rating
            .subscribe(onNext: { [weak self](rating) in
                self?.ratingContainer.subviews
                    .compactMap{ $0 as? UIImageView }
                    .forEach{ $0.isHighlighted = ($0.tag <= rating)}
            }).disposed(by: self.disposeBag)
        
        self.lifeCycle.signalViewWillAppear()
            .map{ [weak self] in self?.book }
            .bind(to: viewModel.input.loadSignal)
            .disposed(by: self.disposeBag)
        
        self.linkButton.rx.tap
            .bind(to: self.viewModel.input.link)
            .disposed(by: self.disposeBag)
        
        self.favoriteButton.rx.tap
            .bind(to: self.viewModel.input.favoriteToggle)
            .disposed(by: self.disposeBag)
        
        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.animator.dismissAnimatorViewController() })
            .disposed(by: self.disposeBag)
        
        
    }
}

extension BookDetailTransitionable where Self : UIViewController {
    func showBookDetail(_ book:Book) {
        guard let vc = BookDetailController.createInstance() else { return }
        vc.book = book
        
        vc.modalPresentationStyle = .fullScreen
    
        vc.animator = Animator.init(target: self, presenting: vc)
        vc.animator.presentDuration = 0.3
        vc.animator.dismissDuration = 0.3

        vc.animator.presentAnimatorViewController()
    }
}
