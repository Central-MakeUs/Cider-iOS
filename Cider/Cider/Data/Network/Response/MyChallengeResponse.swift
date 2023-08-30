//
//  MyChallengeResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

struct MyChallengeResponse: Codable {
    let ongoingChallengeListResponseDto: OngoingChallengeListResponseDto?
    let passedChallengeListResponseDto: PassedChallengeListResponseDto?
    let judgingChallengeListResponseDto: JudgingChallengeListResponseDto?
}

struct JudgingChallengeListResponseDto: Codable {
    let judgingChallengeNum, completeNum: Int
    let judgingChallengeResponseDtoList: [JudgingChallengeResponseDtoList]
}

struct JudgingChallengeResponseDtoList: Codable {
    let challengeId: Int
    let challengeName, challengeBranch, judgingStatus: String
}

struct OngoingChallengeListResponseDto: Codable {
    let ongoingChallengeNum: Int
    let ongoingChallengeResponseDtoList: [OngoingChallengeResponseDtoList]
}

struct OngoingChallengeResponseDtoList: Codable {
    let challengeName, challengeBranch: String
    let ongoingDate, challengePeriod, certifyNum: Int
}

struct PassedChallengeListResponseDto: Codable {
    let passedChallengeNum: Int
    let passedChallengeResponseDtoList: [PassedChallengeResponseDtoList]
}

struct PassedChallengeResponseDtoList: Codable {
    let challengeId: Int
    let challengeName, challengeBranch: String
    let challengePeriod: Int
    let isOfficial, isReward: Bool
    let isSuccess: String
    let successNum: Int
}
