//
//  APIConfig.swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

protocol APIConfig {
    associatedtype Response
    static var domainConfig: DomainConfig.Type { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var parameters: [String: Any?]? { get }
    var encoding:ParameterEncoding { get }
    
    func parse(_: JSON) throws -> Response
    func makeRequest() -> Observable<Self.Response>
}

extension APIConfig {
    var encoding:ParameterEncoding {
        if self.method == .get { return URLEncoding.default }
        return JSONEncoding.default
    }
}

protocol DomainErrorHandler {
    func create(_ code: Int) -> RemoteErrorCodable?
    func globalException(_ error:RemoteError) -> Bool
}
protocol RemoteErrorCodable {
    var value:Int { get }
    var errorMessage:String { get }
}

protocol DomainConfig {
    static var defaultHeader: [String: String]? { get }
    static var parameters : [String: Any?]? { get }
    static var manager: Alamofire.SessionManager { get }
    static var domain : String { get }
    static var errorHandler: DomainErrorHandler { get }
}

protocol APISpecifiedHeaderConfig {
    var headers: [String : String]? { get }
}

struct APIConstant {
     static var hidepath:Bool = true
}

extension APIConfig {
    internal var fullPath: String { return Self.domainConfig.domain + self.path }
    
    internal var debugFullPath: String {
        if APIConstant.hidepath == true { return "http://{server_domain}" + self.path }
        return Self.domainConfig.domain + self.path
    }
    
    internal var fullHeaders: [String: String] {
        return (Self.domainConfig.defaultHeader ?? [:]) + ((self as? APISpecifiedHeaderConfig)?.headers ?? [:])
    }
    
    internal var fullParamaters: [String: Any]? {
        return (Self.domainConfig.parameters ?? [:]).unwrap() + (self.parameters ?? [:]).unwrap()
    }
    
    func request() -> Observable<Self.Response> {
        return self.makeRequest()
            .globalException(self)
            .do(onError: { (error) in
                if self is APIErrorIgnorable { return }
                #if DEBUG
                (error as? RemoteError)?.showMessagePopup()
                #endif
            })
    }
}


func APILog(_ message:String) {
    #if DEBUG
    print(message)
    #endif
}
