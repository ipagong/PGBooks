//
//  RemoteError.swift
//
//  Created by ipagong on 16/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct RemoteError : Error {
    let code:RemoteErrorCodable
    let message:String
    var status:Int?
}

extension RemoteError {
    init(json: JSON, handler:DomainErrorHandler) {
        let codeValue = json[Key.code].intValue
        
        var code = handler.create(codeValue) ??
            RemoteError.Code(rawValue: codeValue) ??
            RemoteError.Code.unknownError
        
        let message = json[Key.message].stringValue
        
        let invalidFormat = json.dictionaryValue.keys.filter { Key.values.contains($0) }
        
        if invalidFormat.isEmpty {
            code = RemoteError.Code.invalidDataFormat
            APILog("error가 다른 타입입니다. 가능한 상태인지 확인해주세요 \(invalidFormat)")
        }
        
        self.code = code
        self.message = (message.collapseIfEmpty ?? code.errorMessage) + "\n(CODE: \(codeValue))"
    }
    
    init(_ code: RemoteErrorCodable = RemoteError.Code.globalException, message: String = "", status: Int? = nil) {
        self.code = code
        self.message = code.errorMessage
        self.status = status
    }
}

extension RemoteError {
    struct Key {
        static let code    = "code"
        static let message = "message"
        static let values  = [Key.code, Key.message]
    }
}

extension RemoteError {
    
    func showMessagePopup() {
        let alert = UIAlertController(title: nil, message: self.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        
        self.target?.present(alert, animated: true, completion: nil)
    }
    
    fileprivate var target:UIViewController? {
        guard let rootVc = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        var top = rootVc
        while let newTop = top.presentedViewController { top = newTop }
        
        guard let last = top.children.last else { return top }
        
        return last
    }
    
}

extension String {
    public var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var isEmptyOrWhitespace: Bool {
        return self.trimmed.isEmpty
    }
    
    var collapseIfEmpty: String? {
        if self.isEmptyOrWhitespace {
            return nil
        } else {
            return self.trimmed
        }
    }
}
