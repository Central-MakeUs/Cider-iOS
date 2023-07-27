//
//  ReviewType.swift
//  Cider
//
//  Created by 임영선 on 2023/07/26.
//

import Foundation

enum ReviewType {
    case reviewing
    case failReview
    case successReview
    
    var koreanTitle: String {
        switch self {
        case .reviewing:
            return "심사중"
        case .failReview:
            return "반려/실패"
        case .successReview:
            return "심사완료"
        }
    }
}
