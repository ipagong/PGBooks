//
//  DataOrError.swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation

enum DataOrError<D, E> where E: Error {
    case data(D)
    case error(E)
    
    var data: D? {
        if case .data(let data) = self {
            return data
        }else {
            return nil
        }
    }
    
    var error: E? {
        if case .error(let error) = self {
            return error
        } else {
            return nil
        }
    }

}

extension DataOrError {
    func mapData<V>(_ closure : (D) -> V) -> DataOrError<V, E> {
        switch self {
        case .data(let data):
            return DataOrError<V, E>.data(closure(data))
        case .error(let error):
            return .error(error)
        }
    }
    
    func mapError<E2>(_ closure : (E) -> E2) -> DataOrError<D, E2> where E2: Error {
        switch self {
        case .data(let data):
            return .data(data)
        case .error(let error):
            return DataOrError<D, E2>.error(closure(error))
        }
    }
}
