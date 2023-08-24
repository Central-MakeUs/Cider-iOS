//
//  MyCertifyResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/08/23.
//

import Foundation

struct MyCertifyResponse: Codable {
    let simpleMemberResponseDto: SimpleMemberResponseDto
    let simpleChallengeResponseDto: SimpleChallengeResponseDto
    var certifyResponseDtoList: [CertifyResponseDtoList]
}

struct CertifyResponseDtoList: Codable {
    let certifyId: Int
    let certifyName, certifyContent, createdDate: String
    let certifyImageUrl: String
    var certifyLike: Int
    var isLike: Bool
}
