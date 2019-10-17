//
//  ITStoreConfig.swift
//  PGBooks-swift
//
//  Created by ipagong on 17/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct ITStoreServer:DomainConfig {
    static let domain : String =  "https://api.itbook.store"
    
    static var manager: Alamofire.SessionManager = {
        let policyManager = ServerTrustPolicyManager(policies: [:])
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        return Alamofire.SessionManager(configuration: configuration,
                                        serverTrustPolicyManager: policyManager)
    }()
    
    static var defaultHeader: [String : String]? {
        return ["Accept" : "application/json"]
    }
    
    static var parameters : [String: Any?]? { return nil }
    
    static var errorHandler: DomainErrorHandler { return ITStoreError.Handler() }
}


struct ITStoreError { }

extension ITStoreError {
    struct Handler : DomainErrorHandler {
        func create(_ code: Int) -> RemoteErrorCodable? {
            return ITStoreError.Code(rawValue: code)
        }
        
        func globalException(_ error: RemoteError) -> Bool {
            return false
        }
    }
}

extension ITStoreError {
    public enum Code : Int {
        case commonError
    }
}

extension ITStoreError.Code : RemoteErrorCodable {
    var value:Int { return self.rawValue }
    var errorMessage:String { return "에러가 발생했습니다. 잠시 후 다시 시도해주세요." }
}

