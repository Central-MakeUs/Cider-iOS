//
//  ChallengeDetailFeedResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

// MARK: - ChallengeDetailFeedResponse
struct ChallengeDetailFeedResponse: Codable {
    let challengeId: Int
    let challengeBranch, challengeName: String
    let challengeCapacity, participateNum: Int
    let certifyImageUrlList: [String]
    let simpleCertifyResponseDtoList: [SimpleCertifyResponseDtoList]
}

// MARK: - SimpleCertifyResponseDtoList
struct SimpleCertifyResponseDtoList: Codable {
    let simpleMemberResponseDto: SimpleMemberResponseDto
    let certifyId: Int
    let createdDate, certifyName, certifyContent: String
    let certifyImageUrl: String
    let certifyLike: Int
    let isLike: Bool
}
