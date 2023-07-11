//
//  LoginError.swift
//  Cider
//
//  Created by 임영선 on 2023/07/11.
//

import Foundation

enum LoginError: Error {
    case loginFail
    case expiredToken
    case noToken
    case others(String)
}

extension LoginError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loginFail:
            return NSLocalizedString("로그인에 실패했습니다. 잠시 후 다시 시도해주세요", comment: "Login Fail")
        case .expiredToken:
            return NSLocalizedString("다시 로그인해주세요", comment: "Expired Token")
        case .noToken:
            return NSLocalizedString("토큰이 없습니다", comment: "No Token")
        case .others(let message):
            return NSLocalizedString(message, comment: "Others Message")
        }
    }
}
