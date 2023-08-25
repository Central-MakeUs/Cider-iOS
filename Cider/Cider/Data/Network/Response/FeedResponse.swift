//
//  FeedResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/08/08.
//

import Foundation

struct FeedResponseElement: Codable {
    let simpleMemberResponseDto: SimpleMemberResponseDto
    let simpleChallengeResponseDto: SimpleChallengeResponseDto
    let createdDate: String
    let certifyId: Int
    let certifyName, certifyContent: String
    let certifyImageUrl: String
    var certifyLike: Int
    var isLike: Bool
}

struct SimpleChallengeResponseDto: Codable {
    let challengeName, challengeBranch: String
    let participateNum: Int
}

struct SimpleMemberResponseDto: Codable {
    let memberName: String
    let profilePath: String
    let memberLevelName: String
    let participateChallengeNum: Int
    let memberId: Int
}

typealias FeedResponse = [FeedResponseElement?]
