//
//  APIConfig+Request.swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

extension APIConfig {
    
    internal func makeRequest() -> Observable<Self.Response> {
        return Observable<Response>.create { (observer: AnyObserver<Response>) -> Disposable in
            
            APILog("\n\n")
            APILog("<----------- REQUEST ----------->")
            APILog("")
            APILog("**** fullpath  : \(self.debugFullPath)")
            APILog("**** parameter : \(self.parameters ?? [:])")
            APILog("")
            APILog("<------------------------------->")
            APILog("\n")
            
            let request = Self.domainConfig.manager.request(self.fullPath,
                                                            method: self.method,
                                                            parameters: self.fullParamaters,
                                                            encoding: self.encoding,
                                                            headers: self.fullHeaders)
            
            request
                .validate()
                .responseData(completionHandler: self.responseHandler(observer))
            
            return Disposables.create { request.cancel() }
            }
    }
}

extension APIConfig {
    internal func responseHandler(_ observer: AnyObserver<Self.Response>) -> ((DataResponse<Data>) -> Void) {
        return { (response:DataResponse<Data>) -> Void in
            switch response.result {
            case .success(let data):
                do {
                    let json:JSON = try {
                        if data.isEmpty { return JSON(()) }
                        return try JSON(data: data)
                    }()
                    
                    APILog("json data: \(json)")
                    
                    let parsed = try self.parse(json)
                    observer.onNext(parsed)
                    observer.onCompleted()
                } catch let error {
                    observer.onError(RemoteError(code: RemoteError.Code.inconsistantModelParseFailed,
                                                 message: error.localizedDescription,
                                                 status: nil))
                }
            case .failure(let error):
                if let errorData = response.data { APILog(String(data: errorData, encoding: .utf8)! ) }
                observer.onError(self.failHandler(error: error, response: response))
            }
        }
    }
    
    private func failHandler(error:Error, response:DataResponse<Data>) -> RemoteError {
        guard error.isCanceled == false else {
            return RemoteError(RemoteError.Code.opertaionCanceled)
        }
        
        guard let afError = error as? AFError else {
            APILog("\n\n")
            APILog("<---- OS ERROR FAIL CODE ----->")
            APILog("")
            APILog("**** error: \(error)")
            APILog("")
            APILog("<------------------------------->")
            APILog("\n")
            return RemoteError(RemoteError.Code.networkError)
        }
        
        guard case let .responseValidationFailed(reason: .unacceptableStatusCode(code: code)) = afError else {
            return RemoteError(RemoteError.Code.malformedRequest)
        }
        
        switch code {
        case 503 :
            return RemoteError(RemoteError.Code.serviceExternalUnavailable)
        case (500..<600) :
            APILog("\n\n")
            APILog("<---- HTTP ERROR FAIL CODE ----->")
            APILog("")
            APILog("**** code: \(code)")
            APILog("")
            APILog("<------------------------------->")
            APILog("\n")
            return RemoteError(RemoteError.Code.internalServerError)
        default:
            guard let data = response.data, let json = try? JSON(data: data) else {
                return RemoteError(RemoteError.Code.http, status: code)
            }
            return RemoteError.init(json: json, handler: Self.domainConfig.errorHandler)
        }
    }

}

extension Observable {
    internal func globalException<T: APIConfig>(_ target:T) -> Observable {
        return self
            .do(onNext: { (data) in
                APILog("\n\n")
                APILog("<--------- API SUCCESS --------->")
                APILog("")
                APILog("***** success: [\(target.method)] \(target.path)")
                APILog("***** header: \(target.fullHeaders)")
                APILog("***** parameter: \(String(describing: target.fullParamaters))")
                APILog("***** data: \(data)")
                APILog("")
                APILog("<------------------------------->")
                APILog("\n")
                
            }, onError: { (error) in
                APILog("\n\n")
                APILog(">-------- API FAILED ---------<")
                APILog("")
                APILog("***** failed: [\(target.method)] \(target.path)")
                APILog("***** header: \(target.fullHeaders)")
                APILog("***** parameter: \(String(describing: target.fullParamaters))")
                APILog("***** error: \(error)")
                APILog("")
                APILog(">-------------------------------<")
                APILog("\n")
            })
            .catchError { (error) -> Observable<Element> in
                guard let remoteError = error as? RemoteError else { throw error }
                guard T.domainConfig.errorHandler.globalException(remoteError) == true else { throw remoteError }
                throw RemoteError(RemoteError.Code.globalException)
            }
    }
}

extension Error {
    fileprivate var isCanceled:Bool {
        return (self as NSError).domain == NSURLErrorDomain && (self as NSError).code == NSURLErrorCancelled
    }
}
