//
//  LoginUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/07/10.
//

import Foundation
import Combine

protocol LoginUsecase {
    func kakaoLogin(token: String) async throws -> LoginResponse?
    func appleLogin(token: String) async throws -> LoginResponse?
}


final class DefaultLoginUsecase: LoginUsecase {
    
    let loginRepository: LoginRepository
    
    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }
    
    func kakaoLogin(token: String) async throws -> LoginResponse? {
        UserDefaults.standard.write(key: .userIdentifier, value: token)
        Keychain.saveToken(data: token)
        let request = LoginRequest(socialType: "KAKAO", clientType: "IOS")
        let response = try await loginRepository.signInKakao(parameters: request)
        guard let accessToken = response.accessToken else {
            return nil
        }
        Keychain.saveToken(data: accessToken)
        return response
    }
    
    func appleLogin(token: String) async throws -> LoginResponse? {
        UserDefaults.standard.write(key: .userIdentifier, value: token)
        Keychain.saveToken(data: token)
        let request = LoginRequest(socialType: "APPLE", clientType: "IOS")
        let response = try await loginRepository.signInKakao(parameters: request)
        print(response)
        guard let accessToken = response.accessToken else {
            return nil
        }
        Keychain.saveToken(data: accessToken)
        return response
    }
    
}
