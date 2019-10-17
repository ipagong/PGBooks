//
//  CellFactory.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit

protocol CellFactory: class {
    static var identifier: String { get }
    associatedtype Dependency
    func bindData(value: Dependency)
}

extension CellFactory {
    static var nibByIdentifier:UINib { return UINib(nibName: Self.identifier, bundle: nil) }
}

extension UITableView {
    func getCell<Cell>(value: Cell.Type, indexPath: IndexPath, data: Cell.Dependency) -> Cell where Cell: CellFactory {
        let cell = self.dequeueReusableCell(withIdentifier: value.identifier, for: indexPath) as! Cell
        cell.bindData(value: data)
        return cell
    }
}
