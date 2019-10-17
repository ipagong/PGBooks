//
//  APIConfig+Error.swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

protocol APIErrorCatachable  {
    associatedtype APISepecifedError: Error
    func catchError(_: RemoteError) -> APISepecifedError?
}

protocol APIErrorIgnorable  { }

extension APIErrorCatachable where Self : APIConfig {
    func requestWithCatch() -> Observable<DataOrError<Self.Response, Self.APISepecifedError>> {
        return self.makeRequest()
            .map(DataOrError<Self.Response, Self.APISepecifedError>.data)
            .catchError { (error) -> Observable<DataOrError<Self.Response, Self.APISepecifedError>> in
                guard let remoteError = error as? RemoteError else { throw error }
                guard let apiError = self.catchError(remoteError) else { throw error }
                
                return Observable.just(DataOrError<Self.Response, Self.APISepecifedError>.error(apiError))
                
            }.do(onError: { (error) in (error as? RemoteError)?.showMessagePopup() })
    }
}
