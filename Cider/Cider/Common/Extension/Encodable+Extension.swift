//
//  Encodable+Extension.swift
//  Cider
//
//  Created by 임영선 on 2023/07/11.
//

import Foundation

public extension Encodable {

    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        ) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

}
