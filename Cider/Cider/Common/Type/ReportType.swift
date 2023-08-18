//
//  ReportType.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import Foundation

enum ReportType {
    case userReport
    case postReport
    case userBlock
    case postBlock
    
    var title: String {
        switch self {
        case .userReport:
            return "작성자 신고 사유 선택"
        case .postReport:
            return "게시글 신고 사유 선택"
        case .userBlock:
            return ""
        case .postBlock:
            return ""
        }
    }
    
}
