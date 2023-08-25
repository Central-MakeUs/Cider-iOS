//
//  ChallengeDetailInfoResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

import Foundation

// MARK: - ChallengeDetailInfoResponse
struct ChallengeDetailInfoResponse: Codable {
    let challengeId: Int
    let myChallengeStatus, challengeBranch, challengeName: String
    let challengeCapacity, participateNum: Int
    let challengeStatus, challengeIntro: String
    var challengeLikeNum: Int
    var isLike: Bool
    let challengeConditionResponseDto: ChallengeConditionResponseDto
    let challengeInfoResponseDto: ChallengeInfoResponseDto
    let challengeRuleResponseDto: ChallengeRuleResponseDto
    let certifyMissionResponseDto: CertifyMissionResponseDto
    let simpleMemberResponseDto: SimpleMemberResponseDto
}

// MARK: - CertifyMissionResponseDto
struct CertifyMissionResponseDto: Codable {
    let certifyMission: String
    let successExampleImage, failureExampleImage: String?
}

// MARK: - ChallengeConditionResponseDto
struct ChallengeConditionResponseDto: Codable {
    let challengePeriod, ongoingDate, averageCondition, myCondition: Int
}

// MARK: - ChallengeInfoResponseDto
struct ChallengeInfoResponseDto: Codable {
    let recruitPeriod, challengePeriod: String
    let challengeCapacity, certifyNum: Int
    let certifyTime: String
    let isReward: Bool
}

// MARK: - ChallengeRuleResponseDto
struct ChallengeRuleResponseDto: Codable {
    let failureRule, certifyRule: String
}
