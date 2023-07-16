//
//  LoginResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/07/11.
//

import Foundation

struct LoginResponse: Codable {
    let status: Int?
    let error: String?
    let accessToken, accessTokenExpireTime, refreshToken, refreshTokenExpireTime: String?
    let isNewMember: Bool?
    let memberId: Int?
    let memberName, birthday, gender: String?
}
