//
//  SearchHistoryCell.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit

class SearchHistoryCell: UITableViewCell, CellFactory {
    static let identifier = "SearchHistoryCell"
    
    @IBOutlet weak var queryLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.queryLabel.text = nil
    }
    
    func bindData(value: String) {
        self.queryLabel.text = value
    }
}
