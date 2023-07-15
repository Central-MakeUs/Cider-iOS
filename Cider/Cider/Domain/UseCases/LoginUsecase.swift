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
    func appleLogin(token: String) async throws -> Bool
}


final class DefaultLoginUsecase: LoginUsecase {
    
    let loginRepository: DefaultLoginRepository
    
    init(loginRepository: DefaultLoginRepository) {
        self.loginRepository = loginRepository
    }
    
    func kakaoLogin(token: String) async throws -> Bool {
        UserDefaults.standard.write(key: .userIdentifier, value: token)
        Keychain.saveToken(data: token)
        print(token)
//        let request = LoginRequest(socialType: "KAKAO", clientType: "IOS")
//        let response = try await loginRepository.signInKakao(parameters: request)
//        print(response)
//        guard response.status == 200,
//              let accessToken = response.accessToken else {
//            return false
//        }
//        Keychain.saveToken(data: accessToken)
        return true
    }
    
    func appleLogin(token: String) async throws -> Bool {
        UserDefaults.standard.write(key: .userIdentifier, value: token)
        Keychain.saveToken(data: token)
        let request = LoginRequest(socialType: "APPLE", clientType: "IOS")
        let response = try await loginRepository.signInKakao(parameters: request)
        print(response)
        guard response.status == 200,
              let accessToken = response.accessToken else {
            return false
        }
        Keychain.saveToken(data: accessToken)
        return true
    }
    
}
