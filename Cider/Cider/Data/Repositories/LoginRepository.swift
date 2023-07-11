//
//  DefaultLoginRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/07/11.
//

import Foundation

protocol LoginRepository {
    func signInKakao(parameters: LoginRequest) async throws -> LoginResponse
    func signInApple(parameters: LoginRequest) async throws -> LoginResponse
}


final class DefaultLoginRepository: LoginRepository {
    
    func signInKakao(parameters: LoginRequest) async throws -> LoginResponse {
        return try await CiderAPI.request(target: .signInKakao(paramters: parameters.asDictionary()), dataType: LoginResponse.self)
    }
    
    func signInApple(parameters: LoginRequest) async throws -> LoginResponse {
        return try await CiderAPI.request(target: .signInApple(paramters: parameters.asDictionary()), dataType: LoginResponse.self)
    }
    
}
