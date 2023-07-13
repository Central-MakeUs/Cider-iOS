//
//  ChallengeOpenSelectionType.swift
//  Cider
//
//  Created by 임영선 on 2023/07/13.
//

import Foundation

enum ChallengeOpenSelectionType {
    
    case member
    case recruitment
    case participation
    
    var mainTitle: String {
        switch self {
        case .member:
            return "참여 정원 *"
        case .recruitment:
            return "모집 기간 *"
        case .participation:
            return "챌린지 기간 *"
        }
    }
    
    var subTitle: String {
        switch self {
        case .member:
            return "3명 이상 30명까지 가능합니다"
        case .recruitment:
            return "최소 1일부터 7일까지 가능합니다"
        case .participation:
            return "최소 1주부터 8주까지 가능합니다"
        }
    }
    
    var unit: String {
        switch self {
        case .member:
            return "3명"
        case .recruitment:
            return "1일"
        case .participation:
            return "1주"
        }
    }
    
    var iconName: String {
        switch self {
        case .member:
            return "line_profile_24"
        case .recruitment:
            return "line_arrow-down_24"
        case .participation:
            return "line_arrow-down_24"
        }
    }
}
