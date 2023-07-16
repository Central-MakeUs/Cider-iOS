//
//  OnboardingResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import Foundation

struct OnboardingResponse: Codable {
    let status: Int?
    let memberId: Int
    let memberName, memberBirth, memberGender, interestChallenge: String
}
