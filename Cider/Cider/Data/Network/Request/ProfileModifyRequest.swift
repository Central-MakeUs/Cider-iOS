//
//  ProfileModifyRequest.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import Foundation

struct ProfileModifyRequest: Codable {
    let memberName: String
    var memberIntro: String = ""
}
