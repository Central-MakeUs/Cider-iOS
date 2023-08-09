//
//  HomeDetailType.swift
//  Cider
//
//  Created by 임영선 on 2023/07/24.
//

import Foundation
import UIKit

enum HomeDetailType {
    case popularChallenge
    case publicChallenge
    case allChallenge
    
    var subTitle: String? {
        switch self {
        case .popularChallenge:
            return "인기 챌린지 소개"
        case .publicChallenge:
            return "공식 챌린지 소개"
        case .allChallenge:
            return nil
        }
    }
    
    var mainTitle: String? {
        switch self {
        case .popularChallenge:
            return "사이다에서 가장 \n인기 있는 챌린지\nTop 10"
        case .publicChallenge:
            return "운영진이 함께하는\n공식 금융 챌린지"
        case .allChallenge:
            return nil
        }
    }
    
    var mainColor: UIColor? {
        switch self {
        case .popularChallenge:
            return .custom.btnMint
        case .publicChallenge:
            return .custom.btnPink
        case .allChallenge:
            return .white
        }
    }
    
    var navigationBarTitle: String {
        switch self {
        case .popularChallenge:
            return "인기 챌린지"
        case .publicChallenge:
            return "공식 챌린지"
        case .allChallenge:
            return "전체 챌린지"
        }
    }
    
    var iconName: String {
        switch self {
        case .popularChallenge:
            return "graph"
        case .publicChallenge:
            return "card"
        case .allChallenge:
            return ""
        }
    }
}
