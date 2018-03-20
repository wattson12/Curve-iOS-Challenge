//
//  Observable+Conversion.swift
//  CurveChallenge
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element == Data {

    func convert<T: Decodable>(to convertType: T.Type, usingDecoder decoder: JSONDecoder = .movieDecoder) -> Observable<T> {
        return self.map { data in
            try decoder.decode(convertType, from: data)
        }
    }
}
