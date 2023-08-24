//
//  ChallengeOpenRequest.swift
//  Cider
//
//  Created by 임영선 on 2023/08/24.
//

import Foundation

struct ChallengeOpenRequest: Codable {
    let challengeBranch, challengeName, challengeInfo, certifyMission: String
    let challengeCapacity, recruitPeriod, challengePeriod: Int
    let isPublic: Bool
}
