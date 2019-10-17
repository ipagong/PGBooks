//
//  MainTabController.swift
//  PGBooks-swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class MainTabController: UIViewController {
    
    @IBOutlet weak var newButton    : UIButton!
    @IBOutlet weak var listButton   : UIButton!
    @IBOutlet weak var forYouButton : UIButton!
    @IBOutlet weak var searchButton : UIButton!

    @IBOutlet weak var tabBar: UIStackView!
    
    weak var container: TabContainer!
   
    private let current = BehaviorRelay<ServiceType>(value: .new)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.merge(newButton.rx.tap.mapTo(ServiceType.new),
                         listButton.rx.tap.mapTo(ServiceType.list),
                         forYouButton.rx.tap.mapTo(ServiceType.forYou),
                         searchButton.rx.tap.mapTo(ServiceType.search))
            .bind(to: self.current)
            .disposed(by: self.disposeBag)
        
        self.current
            .subscribe(onNext: { [weak self] (type) in
                guard let self = self else { return }
                
                self.tabBar.subviews
                    .compactMap { $0 as? UIButton }.enumerated()
                    .forEach { $0.element.isSelected = ($0.offset == type.rawValue) }
                
                self.container.swap(type)
            }).disposed(by: self.disposeBag)
            
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.container = segue.destination as? TabContainer
    }
    


}
