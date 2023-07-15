//
//  NicknameUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/07/14.
//

import Foundation

protocol NicknameUsecase {
    func isEnabledNickname(nickname: String) async throws -> (String, Bool)
    func getRandomNickname() async throws -> String?
}


final class DefaultNicknameUsecase: NicknameUsecase {
    
    let repository: NicknameRepository
    
    init(repository: NicknameRepository) {
        self.repository = repository
    }
    
    func isEnabledNickname(nickname: String) async throws -> (String, Bool) {
        let response = try await repository.getDuplicateNickname(nickname: nickname)
        return (response.message, response.message == "사용할 수 있는 닉네임입니다.")
    }
    
    func getRandomNickname() async throws -> String? {
        let response = try await repository.getRandomNickname()
        return response.randomName
    }
    
}
