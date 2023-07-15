//
//  OnboardingRequest.swift
//  Cider
//
//  Created by 임영선 on 2023/07/15.
//

import Foundation

struct OnboardingRequest: Codable {
    let memberName, memberBirth, memberGender, interestChallenge: String
}
