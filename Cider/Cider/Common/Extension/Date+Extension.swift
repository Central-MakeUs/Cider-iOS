//
//  Date+Extension.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import Foundation

extension Date {
    
    func formatYYYYMMDDKorean() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
    
    func formatYYYYMMDDDash() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
}
