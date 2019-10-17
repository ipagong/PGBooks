//
//  ViewModelType.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input  : Input { get }
    var output : Output { get }
}
