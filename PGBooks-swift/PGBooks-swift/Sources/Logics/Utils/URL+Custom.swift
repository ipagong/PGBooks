//
//  URL+Custom.swift
//  PGBooks-swift
//
//  Created by ipagong on 18/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import RxSwift

struct ImageCache {
    static let shared = ImageCache()
    public let downloader = ImageDownloader()
}

extension URL {
    public func image() -> Observable<UIImage> {
        return Observable<UIImage>.create { observer -> Disposable in
            let downloader =
               ImageCache.shared.downloader.download(URLRequest(url: self)) { (response) in
                    if let image = response.value { observer.onNext(image) }
                    observer.onCompleted()
            }

            return Disposables.create{ downloader?.request.cancel() }
        }
    }
    
}
