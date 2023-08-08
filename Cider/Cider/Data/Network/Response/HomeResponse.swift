//
//  HomeResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/08/04.
//

import Foundation

struct HomeResponse: Codable {
    let status: Int?
    let error: String?
    let popularChallengeResponseDto, officialChallengeResponseDto: [ChallengeResponseDto]?
}

struct ChallengeResponseDto: Codable {
    let challengeId: Int
    let challengeName, challengeStatus: String
    let participateNum, recruitLeft: Int
    let interestField: String
    let challengePeriod: Int
    let isOfficial, isReward, isLike: Bool
}
