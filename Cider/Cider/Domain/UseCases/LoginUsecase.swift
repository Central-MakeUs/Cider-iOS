//
//  LoginUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/07/10.
//

import Foundation
import Combine

protocol LoginUsecase {
    func kakaoLogin(token: String) async throws -> Bool
}


final class DefaultLoginUsecase: LoginUsecase {
    
    let loginRepository: DefaultLoginRepository
    
    init(loginRepository: DefaultLoginRepository) {
        self.loginRepository = loginRepository
    }
    
    func kakaoLogin(token: String) async throws -> Bool {
        Keychain.saveToken(data: token)
        let request = LoginRequest(socialType: "KAKAO", clientType: "IOS")
        let response = try await loginRepository.signInKakao(parameters: request)
        // TODO: 실패 response 서버에서 전달해주면 로직 수정
        print(response)
        guard let accessToken = response.accessToken else {
            return false
        }
        Keychain.saveToken(data: accessToken)
        return true
    }
    
}
