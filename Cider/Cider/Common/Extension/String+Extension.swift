//
//  String+Extension.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import Foundation
import UIKit

extension String {
    
    func substring(start: Int, end: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: start)
        let end = self.index(self.startIndex, offsetBy: end)
        return String(self[start..<end])
    }
    
    func convertStatusKorean() -> String {
        switch self {
        case "RECRUITING":
            return "모집중"
        case "POSSIBLE":
            return "참여가능"
        case "IMPOSSIBLE":
            return "종료"
        case "END":
            return "종료"
        default:
            return ""
        }
    }
    
    func convertChallengeType() -> ChallengeType {
        switch self {
        case "TECHNOLOGY":
            return .financialTech
        case "SAVING":
            return .moneySaving
        case "LEARNING":
            return .financialLearning
        case "MONEY":
            return .moneyManagement
        default:
            return .financialTech
        }
    }
    
    func formatYYYYMMDDHHMMDot() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            return outputFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func convertReviewType() -> ReviewType? {
        switch self {
        case "JUDGING":
            return .reviewing
        case "COMPLETE":
            return .successReview
        case "FAILURE":
            return .failReview
        default:
            return nil
        }
    }
    
}
