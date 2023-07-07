//
//  ChallengeType.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import Foundation

enum ChallengeType {
    case financialTech
    case moneySaving
    case moneyManagement
    case financialLearning
}

extension ChallengeType {
    func getSelectedName() -> String {
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
    
    func getUnselectedName() -> String {
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
    
    func getKoreanName() -> String {
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
}
