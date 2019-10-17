//
//  CustomViews.swift
//  PGBooks-swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    public var cornerRadius: CGFloat {
        set { self.layer.cornerRadius = newValue }
        get { return self.layer.cornerRadius     }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        set { self.layer.borderWidth = newValue }
        get { return self.layer.borderWidth     }
    }
    
    @IBInspectable
    public var borderColor:UIColor? {
        set { self.layer.borderColor = newValue?.cgColor }
        get {
            guard let color = self.layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

class PaddingLabel : UILabel {
    @IBInspectable public var topInset      : CGFloat = 0
    @IBInspectable public var bottomInset   : CGFloat = 0
    @IBInspectable public var leftInset     : CGFloat = 0
    @IBInspectable public var rightInset    : CGFloat = 0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: self.topInset,
                                  left: self.leftInset,
                                  bottom: self.bottomInset,
                                  right: self.rightInset)
        
        return super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        return CGSize(width: size.width + self.leftInset + self.rightInset,
                      height: size.height + self.topInset + self.bottomInset)
    }
}
