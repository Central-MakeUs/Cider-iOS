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
    
    var toastMessage: String {
        switch self {
        case .userReport:
            return "작성자 신고가 완료되었습니다"
        case .postReport:
            return "게시글 신고가 완료되었습니다"
        case .userBlock:
            return "작성자 차단이 완료되었습니다"
        case .postBlock:
            return "게시글 차단이 완료되었습니다"
        }
    }
    
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
    
    var popUpMainTitle: String {
        switch self {
        case .userReport,
             .postReport:
            return "정말 신고하시겠습니까?"
            
        case .userBlock,
             .postBlock:
            return "정말 차단하시겠습니까?"
        }
    }
    
    var popUpSubTitle: String {
        switch self {
        case .userReport,
             .postReport:
            return "한번 신고하면\n신고를 철회할 수 없습니다"
            
        case .userBlock,
             .postBlock:
            return "한번 차단하면\n차단을 철회할 수 없습니다"
        }
    }
    
    var popUpButtonTitle: String {
        switch self {
        case .userReport,
             .postReport:
            return "신고할게요"
            
        case .userBlock,
             .postBlock:
            return "차단할게요"
        }
    }
    
}
