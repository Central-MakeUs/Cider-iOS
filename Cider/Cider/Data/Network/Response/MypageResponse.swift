//
//  MypageResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/08/12.
//

import Foundation

// MARK: - MypageResponse
struct MypageResponse: Codable {
    let simpleMember: SimpleMember
    let memberActivityInfo: MemberActivityInfo
    let memberLevelInfo: MemberLevelInfo
}

// MARK: - MemberActivityInfo
struct MemberActivityInfo: Codable {
    let myLevel, myCertifyNum, myLikeChallengeNum: Int
}

// MARK: - MemberLevelInfo
struct MemberLevelInfo: Codable {
    let myLevel, levelPercent: Int
    let percentComment: String
    let experienceLeft: Int
    let myLevelName: String
    let currentLevel, nextLevel: TLevel
}

// MARK: - TLevel
struct TLevel: Codable {
    let level: Int
    let levelName: String
    let requiredExperience: Int
}

// MARK: - SimpleMember
struct SimpleMember: Codable {
    let memberName, profilePath, memberLevelName: String?
    let participateChallengeNum: Int
}
