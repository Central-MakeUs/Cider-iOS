//
//  ParticiapteChallengeResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/08/23.
//

import Foundation

struct ParticiapteChallengeResponseElement: Codable {
    let challengeId: Int
    let challengeName, participateStatus: String
}

typealias ParticiapteChallengeResponse = [ParticiapteChallengeResponseElement]
