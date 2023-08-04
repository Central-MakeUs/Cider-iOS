//
//  HomeCategoryResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/08/05.
//

import Foundation

struct HomeCategoryResponseElement: Codable {
    let challengeId: Int
    let challengeName, challengeStatus: String
    let participateNum, recruitLeft: Int
    let interestField: String
    let isOfficial, isReward, isLike: Bool
}

typealias HomeCategoryResponse = [HomeCategoryResponseElement]

