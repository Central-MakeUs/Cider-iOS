//
//  SortingType.swift
//  Cider
//
//  Created by 임영선 on 2023/08/08.
//

import Foundation

enum SortingType {
    case latest
    case participate
    case like
    
    var english: String {
        switch self {
        case .latest:
            return "latest"
        case .participate:
            return "participate"
        case .like:
            return "like"
        }
    }
    
    var korean: String {
        switch self {
        case .latest:
            return "최신순"
        case .participate:
            return "참여순"
        case .like:
            return "좋아요순"
        }
    }
    
}
