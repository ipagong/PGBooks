//
//  UIViewController+Custom.swift
//  PGBooks-swift
//
//  Created by ipagong on 18/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit

extension UIViewController {
    var lastChildren:UIViewController? {
        var result = self
        while let last = result.children.last { result = last }
        return result
    }
}
