//
//  WritingType.swift
//  Cider
//
//  Created by 임영선 on 2023/07/17.
//

import Foundation

enum WritingType {
    case authentication
    case feed
    case challengeOpen
    
    var iconImageName: String {
        switch self {
        case .authentication:
            return "line_calender_24"
        case .feed:
            return "line_edit_24"
        case .challengeOpen:
            return "line_new_24"
        }
    }
    
    var mainTitle: String {
        switch self {
        case .authentication:
            return "챌린지 인증하기"
        case .feed:
            return "챌린지 자유글"
        case .challengeOpen:
            return "챌린지 개설하기"
        }
    }
    
    var subTitle: String {
        switch self {
        case .authentication:
            return "챌린지를 인증합니다"
        case .feed:
            return "자유롭게 글을 작성합니다"
        case .challengeOpen:
            return "직접 챌린지를 제작합니다"
        }
    }
    
}
