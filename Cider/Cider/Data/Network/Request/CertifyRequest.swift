//
//  CertifyRequest.swift
//  Cider
//
//  Created by 임영선 on 2023/08/23.
//

import Foundation

struct CertifyRequest: Codable {
    let challengeId: Int
    let certifyName, certifyContent: String
}
