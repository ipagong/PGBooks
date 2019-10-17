//
//  BookSimpleCell.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit
import AlamofireImage

class BookSimpleCell: UITableViewCell, CellFactory {
    static let identifier = "BookSimpleCell"
    
    @IBOutlet weak var coverView        : UIImageView!
    @IBOutlet weak var priceLabel       : PaddingLabel!
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var subtitleLabel    : UILabel!
    @IBOutlet weak var storeLinkButton  : UIButton!
    @IBOutlet weak var numberLabel      : PaddingLabel!

    var data:Book?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.coverView.af_cancelImageRequest()
        self.coverView.image = nil
    }
    
    func bindData(value: Book?) {
        self.data = value
        
        self.titleLabel.text     = value?.title
        self.subtitleLabel.text  = value?.subtitle
        self.priceLabel.text     = value?.price
        self.numberLabel.text    = value?.isbn13
        
        if let url = try? value?.image.asURL() { self.coverView.af_setImage(withURL: url) }
    }
    
    @IBAction func onClickButton(_ sender:Any?) {
        guard let url = try? data?.url.asURL() else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
