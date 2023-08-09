//
//  ChallengeType.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import Foundation
import UIKit

enum ChallengeType {
    case financialTech
    case moneySaving
    case moneyManagement
    case financialLearning
}

extension ChallengeType {
    var selectedName: String {
        switch self {
        case .financialTech:
            return "financialTechSelected"
        case .moneySaving:
            return "moneySavingSelected"
        case .moneyManagement:
            return "moneyManagementSelected"
        case .financialLearning:
            return "financialLearningSelected"
        }
    }
    
    var unselectedName: String {
        switch self {
        case .financialTech:
            return "financialTechUnselected"
        case .moneySaving:
            return "moneySavingUnselected"
        case .moneyManagement:
            return "moneyManagementUnselected"
        case .financialLearning:
            return "financialLearningUnselected"
        }
    }
    
    var koreanName: String {
        switch self {
        case .financialTech:
            return "재테크"
        case .moneySaving:
            return "소비절약"
        case .moneyManagement:
            return "돈관리"
        case .financialLearning:
            return "금융학습"
        }
    }
    
    var color: UIColor? {
        switch self {
        case .financialTech:
            return .custom.btnMint
        case .moneySaving:
            return .custom.btnPink
        case .moneyManagement:
            return .custom.btnBlue
        case .financialLearning:
            return .custom.btnPurple
        }
    }
    
    var alphabet: String {
        switch self {
        case .financialTech:
            return "T"
        case .moneySaving:
            return "C"
        case .moneyManagement:
            return "M"
        case .financialLearning:
            return "L"
        }
    }
    
    var backgroundImageName: String {
        switch self {
        case .financialTech:
            return "financialTechBG"
        case .moneySaving:
            return "moneySavingBG"
        case .moneyManagement:
            return "moneyManagementBG"
        case .financialLearning:
            return "financialLearningBG"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .financialTech:
            return "home"
        case .moneySaving:
            return "pig"
        case .moneyManagement:
            return "graph"
        case .financialLearning:
            return "card"
        }
    }
    
    var infoMessage: String {
        switch self {
        case .financialTech:
            return "돈을 버는 습관을 길러주는 재테크 챌린지를 소개해요"
        case .moneySaving:
            return "불필요한 지출 줄이고 절약하는 챌린지를 소개해요"
        case .moneyManagement:
            return "상태 파악 및 관리 습관을 만드는 챌린지를 소개해요"
        case .financialLearning:
            return "재테크, 금융, 투자에 대한 지식을 쌓는 챌린지를 소개해요"
        }
    }
    
    var bannerImageName: String {
        switch self {
        case .financialTech:
            return "financialTechBanner"
        case .moneySaving:
            return "moneySavingBanner"
        case .moneyManagement:
            return "moneyManagementBanner"
        case .financialLearning:
            return "financialLearningBanner"
        }
    }
    
}
