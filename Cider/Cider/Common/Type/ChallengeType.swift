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
    
    func getColor() -> UIColor? {
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
    
    func getAlphabet() -> String {
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
    
}
