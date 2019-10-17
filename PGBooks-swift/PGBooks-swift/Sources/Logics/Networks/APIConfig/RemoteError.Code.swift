//
//  RemoteErrorCode.swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation

extension RemoteError {
    public enum Code : Int {
        case http = -9999
        case serviceExternalUnavailable
        case internalServerError
        case networkError
        case inconsistantModelParseFailed
        case opertaionCanceled
        case malformedRequest
        
        case unknownError
        case invalidDataFormat
        case globalException
    }
}

//글로벌 에러 코드. (서비스 에러 코드는 따로 구현해야함)
extension RemoteError.Code : RemoteErrorCodable {
    var value:Int { return self.rawValue }
    
    var errorMessage:String {
        switch self {
        case .unknownError:      return "알수 없는 에러가 발생 했습니다."
        case .invalidDataFormat: return "알수 없는 데이타입니다."
        case .globalException:   return "에러가 발생했습니다."
        default: return "에러가 발생했습니다. 잠시 후 다시 시도해주세요."
        }
    }
}
