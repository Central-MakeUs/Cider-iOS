//
//  LoginRequest.swift
//  Cider
//
//  Created by 임영선 on 2023/07/11.
//

import Foundation

struct LoginRequest: Codable {
    let socialType: String
    let clientType: String
}
